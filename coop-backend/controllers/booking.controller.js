const pool = require('../config/db');

/**
 * POST /api/bookings
 * Body: { workerId, serviceType, scheduledAt, address, isEmergency }
 */
async function createBooking(req, res) {
  const customerId = req.user.id;
  const { workerId, serviceType, scheduledAt, address, isEmergency } = req.body;

  try {
    const result = await pool.query(
      `INSERT INTO bookings (customer_id, worker_id, service_type, status)
       VALUES ($1, $2, $3, $4)
       RETURNING *`,
      [customerId, workerId, serviceType, 'pending']
    );

    // Mock extra fields for Flutter model
    const booking = {
      id: result.rows[0].id.toString(),
      workerId: result.rows[0].worker_id.toString(),
      workerName: 'Worker', // Ideally fetch from DB
      serviceType: result.rows[0].service_type,
      status: result.rows[0].status,
      scheduledAt: scheduledAt || new Date().toISOString(),
      address: address || 'Current Location',
      isEmergency: isEmergency || false,
      amount: 300,
      createdAt: result.rows[0].created_at
    };

    return res.status(201).json(booking);
  } catch (err) {
    console.error('createBooking error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

/**
 * GET /api/bookings/:id
 */
async function getBookingById(req, res) {
  const { id } = req.params;

  try {
    const result = await pool.query(`SELECT * FROM bookings WHERE id = $1`, [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    const row = result.rows[0];
    const booking = {
      id: row.id.toString(),
      workerId: row.worker_id ? row.worker_id.toString() : '',
      workerName: 'Worker',
      serviceType: row.service_type,
      status: row.status,
      scheduledAt: new Date().toISOString(),
      address: 'Current Location',
      isEmergency: false,
      amount: 300,
      createdAt: row.created_at
    };

    return res.json(booking);
  } catch (err) {
    console.error('getBookingById error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

/**
 * PATCH /api/bookings/:id/cancel
 */
async function cancelBooking(req, res) {
  const { id } = req.params;

  try {
    await pool.query(`UPDATE bookings SET status = 'cancelled' WHERE id = $1`, [id]);
    return res.json({ message: 'Booking cancelled' });
  } catch (err) {
    console.error('cancelBooking error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

/**
 * POST /api/bookings/:id/rate
 */
async function rateBooking(req, res) {
  return res.json({ message: 'Rating submitted' });
}

/**
 * GET /api/customer/bookings
 * Note: Mapped from server.js
 */
async function getCustomerBookings(req, res) {
  const customerId = req.user.id;

  try {
    const result = await pool.query(
      `SELECT * FROM bookings WHERE customer_id = $1 ORDER BY created_at DESC`,
      [customerId]
    );

    const bookings = result.rows.map(row => ({
      id: row.id.toString(),
      workerId: row.worker_id ? row.worker_id.toString() : '',
      workerName: 'Worker',
      serviceType: row.service_type,
      status: row.status,
      scheduledAt: row.created_at, // Mock
      address: 'Current Location',
      isEmergency: false,
      amount: 300,
      createdAt: row.created_at
    }));

    return res.json(bookings);
  } catch (err) {
    console.error('getCustomerBookings error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

/**
 * GET /api/workers/bookings
 * For the worker app to fetch incoming/active jobs
 */
async function getWorkerBookings(req, res) {
  const workerId = req.user.id;

  // Handle guest accounts gracefully to prevent database type errors
  if (workerId === 'guest' || isNaN(parseInt(workerId, 10))) {
    return res.json([]);
  }

  try {
    const result = await pool.query(
      `SELECT * FROM bookings WHERE worker_id = $1 ORDER BY created_at DESC`,
      [workerId]
    );

    const bookings = result.rows.map(row => ({
      id: row.id.toString(),
      customerId: row.customer_id ? row.customer_id.toString() : '',
      customerName: 'Customer',
      serviceType: row.service_type,
      status: row.status,
      createdAt: row.created_at
    }));

    return res.json(bookings);
  } catch (err) {
    console.error('getWorkerBookings error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

/**
 * PATCH /api/workers/bookings/:id/status
 * For worker app to accept/reject/complete
 * Body: { status }
 */
async function updateBookingStatus(req, res) {
  const { id } = req.params;
  const { status } = req.body;

  try {
    await pool.query(`UPDATE bookings SET status = $1 WHERE id = $2`, [status, id]);
    return res.json({ message: 'Status updated' });
  } catch (err) {
    console.error('updateBookingStatus error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

module.exports = {
  createBooking,
  getBookingById,
  cancelBooking,
  rateBooking,
  getCustomerBookings,
  getWorkerBookings,
  updateBookingStatus
};
