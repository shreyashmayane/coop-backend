require('dotenv').config();
const bcrypt = require('bcryptjs');
const pool   = require('./config/db');

/**
 * seed_admin.js — Inserts two test admin users.
 * Usage: node seed_admin.js
 *
 * society_admin  → phone 9000000001, password: admin123, society_id: 1
 * federation_admin → phone 9000000002, password: admin123, federation_id: 1
 *
 * Uses INSERT ... ON CONFLICT DO NOTHING so re-running is safe.
 */
async function seed() {
  const client = await pool.connect();
  try {
    const hash = await bcrypt.hash('admin123', 10);

    // Society Admin
    await client.query(
      `INSERT INTO users (name, phone, password_hash, role, status, society_id)
       VALUES ($1, $2, $3, $4, $5, $6)
       ON CONFLICT (phone) DO NOTHING`,
      ['Test Society Admin', '9000000001', hash, 'society_admin', 'active', 1]
    );

    // Federation Admin
    await client.query(
      `INSERT INTO users (name, phone, password_hash, role, status, federation_id)
       VALUES ($1, $2, $3, $4, $5, $6)
       ON CONFLICT (phone) DO NOTHING`,
      ['Test Federation Admin', '9000000002', hash, 'federation_admin', 'active', 1]
    );

    console.log('✅  Admin seed complete.');
    console.log('   society_admin    → phone: 9000000001  password: admin123');
    console.log('   federation_admin → phone: 9000000002  password: admin123');
  } catch (err) {
    console.error('❌  Seed failed:', err.message);
    process.exit(1);
  } finally {
    client.release();
    await pool.end();
  }
}

seed();
