const pool = require('../config/db');

// ─── Helpers ──────────────────────────────────────────────────────────────────

/**
 * Build the WHERE clause fragment and params array for scoping
 * queries to the admin's society or federation.
 * NEVER trusts req.body / req.query for scope — always uses req.user from JWT.
 */
function buildScopeFilter(user, tableAlias = 'u') {
  if (user.role === 'society_admin') {
    return {
      clause: `${tableAlias}.society_id = $1`,
      params: [user.society_id],
    };
  }
  // federation_admin
  return {
    clause: `${tableAlias}.federation_id = $1`,
    params: [user.federation_id],
  };
}

// ─── GET /api/admin/workers ───────────────────────────────────────────────────
/**
 * Returns workers scoped to the admin's society or federation.
 * Optional query param: ?status=pending|verified|rejected
 */
async function getWorkers(req, res) {
  const { status } = req.query;
  const { clause, params } = buildScopeFilter(req.user);

  let query = `
    SELECT id, name, phone, role, status, skills, society_id, federation_id, created_at
    FROM users u
    WHERE ${clause}
      AND u.role = 'worker'
  `;

  if (status) {
    params.push(status);
    query += ` AND u.status = $${params.length}`;
  }

  query += ' ORDER BY u.created_at DESC';

  try {
    const result = await pool.query(query, params);
    return res.json({ workers: result.rows });
  } catch (err) {
    console.error('getWorkers error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

// ─── PATCH /api/admin/workers/:id/verify ─────────────────────────────────────
/**
 * Body: { action: "verify" | "reject" }
 * Updates worker status. Scoped to admin's society/federation.
 */
async function verifyWorker(req, res) {
  const workerId = parseInt(req.params.id, 10);
  const { action } = req.body;

  if (!['verify', 'reject'].includes(action)) {
    return res.status(400).json({ error: 'action must be "verify" or "reject"' });
  }

  const newStatus = action === 'verify' ? 'verified' : 'rejected';
  const { clause, params } = buildScopeFilter(req.user);

  try {
    // Confirm the worker belongs to admin's scope before updating
    const check = await pool.query(
      `SELECT id FROM users u WHERE u.id = $${params.length + 1} AND u.role = 'worker' AND ${clause}`,
      [...params, workerId]
    );

    if (check.rows.length === 0) {
      return res.status(404).json({ error: 'Worker not found in your scope' });
    }

    const result = await pool.query(
      `UPDATE users SET status = $1 WHERE id = $2 RETURNING id, name, phone, status`,
      [newStatus, workerId]
    );

    return res.json({ worker: result.rows[0] });
  } catch (err) {
    console.error('verifyWorker error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

// ─── GET /api/admin/bookings ──────────────────────────────────────────────────
/**
 * Returns all bookings with customer and worker names,
 * scoped to the admin's society/federation via the worker's scope column.
 */
async function getBookings(req, res) {
  const { clause, params } = buildScopeFilter(req.user, 'w');

  const query = `
    SELECT
      b.id,
      b.service_type,
      b.status,
      b.created_at,
      c.name  AS customer_name,
      c.phone AS customer_phone,
      w.name  AS worker_name,
      w.phone AS worker_phone
    FROM bookings b
    LEFT JOIN users c ON c.id = b.customer_id
    LEFT JOIN users w ON w.id = b.worker_id
    WHERE ${clause}
    ORDER BY b.created_at DESC
  `;

  try {
    const result = await pool.query(query, params);
    return res.json({ bookings: result.rows });
  } catch (err) {
    console.error('getBookings error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

// ─── GET /api/admin/analytics ─────────────────────────────────────────────────
/**
 * Returns aggregated counts scoped to the admin's society/federation.
 * Response: { totalWorkers, totalBookings, completedBookings, pendingVerification }
 */
async function getAnalytics(req, res) {
  const { clause: workerClause, params } = buildScopeFilter(req.user, 'u');
  const bookingClause = buildScopeFilter(req.user, 'w').clause;

  try {
    const [workersRes, bookingsRes, completedRes, pendingRes] = await Promise.all([
      // Total workers in scope
      pool.query(
        `SELECT COUNT(*) FROM users u WHERE ${workerClause} AND u.role = 'worker'`,
        params
      ),
      // Total bookings in scope (via worker's scope)
      pool.query(
        `SELECT COUNT(*) FROM bookings b
         LEFT JOIN users w ON w.id = b.worker_id
         WHERE ${bookingClause}`,
        params
      ),
      // Completed bookings in scope
      pool.query(
        `SELECT COUNT(*) FROM bookings b
         LEFT JOIN users w ON w.id = b.worker_id
         WHERE ${bookingClause} AND b.status = 'completed'`,
        params
      ),
      // Workers pending verification in scope
      pool.query(
        `SELECT COUNT(*) FROM users u WHERE ${workerClause} AND u.role = 'worker' AND u.status = 'pending'`,
        params
      ),
    ]);

    return res.json({
      totalWorkers:        parseInt(workersRes.rows[0].count, 10),
      totalBookings:       parseInt(bookingsRes.rows[0].count, 10),
      completedBookings:   parseInt(completedRes.rows[0].count, 10),
      pendingVerification: parseInt(pendingRes.rows[0].count, 10),
    });
  } catch (err) {
    console.error('getAnalytics error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

module.exports = { getWorkers, verifyWorker, getBookings, getAnalytics };
