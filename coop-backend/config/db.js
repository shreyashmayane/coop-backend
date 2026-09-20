require('dotenv').config();
const { Pool } = require('pg');

/**
 * Single shared PostgreSQL connection pool.
 * Supports two modes:
 *  - Cloud (Neon/production): set DATABASE_URL in .env → uses SSL automatically
 *  - Local dev: set DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD in .env
 */
const pool = new Pool(
  process.env.DATABASE_URL
    ? {
        connectionString: process.env.DATABASE_URL,
        ssl: { rejectUnauthorized: false }, // required for Neon + most cloud DBs
        max: 10,
        idleTimeoutMillis: 30000,
        connectionTimeoutMillis: 5000,
      }
    : {
        host:     process.env.DB_HOST     || 'localhost',
        port:     parseInt(process.env.DB_PORT) || 5432,
        database: process.env.DB_NAME     || 'coop_db',
        user:     process.env.DB_USER     || 'postgres',
        password: process.env.DB_PASSWORD || '',
        max: 10,
        idleTimeoutMillis: 30000,
        connectionTimeoutMillis: 2000,
      }
);

pool.on('error', (err) => {
  console.error('Unexpected PostgreSQL pool error:', err.message);
});

module.exports = pool;
