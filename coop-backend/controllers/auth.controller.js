const bcrypt = require('bcryptjs');
const jwt    = require('jsonwebtoken');
const pool   = require('../config/db');

/**
 * POST /api/auth/register
 * Body: { name, phone, password, role? }
 * Default role is 'customer' if not provided.
 */
async function register(req, res) {
  const { name, phone, password, role = 'customer' } = req.body;

  if (!phone || !password) {
    return res.status(400).json({ error: 'phone and password are required' });
  }

  try {
    const hash = await bcrypt.hash(password, 10);
    const result = await pool.query(
      `INSERT INTO users (name, phone, password_hash, role)
       VALUES ($1, $2, $3, $4)
       RETURNING id, name, phone, role, created_at`,
      [name, phone, hash, role]
    );
    return res.status(201).json({ user: result.rows[0] });
  } catch (err) {
    if (err.code === '23505') {
      return res.status(409).json({ error: 'Phone number already registered' });
    }
    console.error('register error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

/**
 * POST /api/auth/login
 * Body: { phone, password }
 * Returns: { token, user }
 *
 * JWT payload includes society_id and federation_id for admin scope enforcement.
 */
async function login(req, res) {
  const { phone, password } = req.body;

  if (!phone || !password) {
    return res.status(400).json({ error: 'phone and password are required' });
  }

  try {
    const result = await pool.query(
      `SELECT id, name, phone, role, password_hash, society_id, federation_id
       FROM users WHERE phone = $1`,
      [phone]
    );

    const user = result.rows[0];
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const valid = await bcrypt.compare(password, user.password_hash);
    if (!valid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Include scope fields in JWT so admin middleware can use them without a DB hit
    const token = jwt.sign(
      {
        id:            user.id,
        role:          user.role,
        society_id:    user.society_id,
        federation_id: user.federation_id,
      },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    const { password_hash: _omit, ...safeUser } = user;
    return res.json({ token, user: safeUser });
  } catch (err) {
    console.error('login error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

module.exports = { register, login };
