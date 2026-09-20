require('dotenv').config();
const pool = require('./config/db');

async function makeWorkersPending() {
  const client = await pool.connect();
  try {
    const res = await client.query(
      "UPDATE users SET status = 'pending' WHERE role = 'worker'"
    );
    console.log(`Updated ${res.rowCount} workers to 'pending'`);
  } catch (err) {
    console.error(err);
  } finally {
    client.release();
    pool.end();
  }
}
makeWorkersPending();
