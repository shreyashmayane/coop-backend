require('dotenv').config();
const pool = require('./config/db');

/**
 * migrate.js — Run once to set up all database tables.
 * Usage: node migrate.js
 *
 * Safe to re-run (uses IF NOT EXISTS / IF NOT EXISTS checks).
 */
async function migrate() {
  const client = await pool.connect();
  try {
    console.log('▶  Running migrations...');

    // ── users ────────────────────────────────────────────────────────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS users (
        id             SERIAL PRIMARY KEY,
        name           VARCHAR(100),
        phone          VARCHAR(15) UNIQUE NOT NULL,
        password_hash  TEXT NOT NULL,
        role           VARCHAR(30)  NOT NULL DEFAULT 'customer',
        status         VARCHAR(20)  NOT NULL DEFAULT 'active',
        skills         TEXT[]       DEFAULT '{}',
        society_id     INT,
        federation_id  INT,
        created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
      );
    `);
    console.log('  ✔  users table ready');

    // Apply spec-required columns in case table existed without them
    await client.query(`ALTER TABLE users ADD COLUMN IF NOT EXISTS society_id    INT;`);
    await client.query(`ALTER TABLE users ADD COLUMN IF NOT EXISTS federation_id INT;`);
    console.log('  ✔  society_id / federation_id columns ensured');

    // ── bookings ─────────────────────────────────────────────────────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS bookings (
        id            SERIAL PRIMARY KEY,
        customer_id   INT REFERENCES users(id) ON DELETE SET NULL,
        worker_id     INT REFERENCES users(id) ON DELETE SET NULL,
        service_type  VARCHAR(100),
        status        VARCHAR(30)  NOT NULL DEFAULT 'pending',
        created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
      );
    `);
    console.log('  ✔  bookings table ready');

    console.log('✅  All migrations complete.');
  } catch (err) {
    console.error('❌  Migration failed:', err.message);
    process.exit(1);
  } finally {
    client.release();
    await pool.end();
  }
}

migrate();
