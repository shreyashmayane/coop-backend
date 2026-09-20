const pool = require('../config/db');

/**
 * GET /api/workers/nearby
 * Query: lat, lng, serviceType
 */
async function getNearbyWorkers(req, res) {
  const { lat, lng, serviceType } = req.query;

  try {
    // For MVP, we ignore lat/lng and just fetch all workers with role='worker'
    // In a real app, we would use PostGIS or calculate distance.
    const result = await pool.query(
      `SELECT id, name, phone, status, skills, created_at 
       FROM users 
       WHERE role = 'worker'`
    );

    // Map to the format the Flutter app expects
    const workers = result.rows.map(row => {
      return {
        id: row.id.toString(),
        name: row.name,
        serviceType: serviceType || (row.skills && row.skills.length > 0 ? row.skills[0] : 'General'),
        avatarUrl: null, // No avatar in DB yet
        rating: 4.5, // Mock
        reviewCount: Math.floor(Math.random() * 100), // Mock
        distanceKm: Math.floor(Math.random() * 5 * 10) / 10, // Mock distance
        hourlyRate: 300, // Mock rate
        skills: row.skills || [],
        isAvailable: row.status === 'active',
        bio: `Professional cooperative worker.`,
      };
    });

    // Optionally filter by serviceType in memory if requested
    const filtered = serviceType 
      ? workers.filter(w => w.skills.includes(serviceType) || w.serviceType === serviceType)
      : workers;

    return res.json(filtered);
  } catch (err) {
    console.error('getNearbyWorkers error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

/**
 * GET /api/workers/:id
 */
async function getWorkerById(req, res) {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `SELECT id, name, phone, status, skills, created_at 
       FROM users 
       WHERE id = $1 AND role = 'worker'`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Worker not found' });
    }

    const row = result.rows[0];
    const worker = {
      id: row.id.toString(),
      name: row.name,
      serviceType: row.skills && row.skills.length > 0 ? row.skills[0] : 'General',
      avatarUrl: null,
      rating: 4.8,
      reviewCount: 42,
      distanceKm: 2.1,
      hourlyRate: 350,
      skills: row.skills || [],
      isAvailable: row.status === 'active',
      bio: 'Expert worker with years of experience.',
      reviews: []
    };

    return res.json(worker);
  } catch (err) {
    console.error('getWorkerById error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

/**
 * PUT /api/workers/status
 * Body: { status: 'active' | 'offline' }
 * Requires Auth
 */
async function updateStatus(req, res) {
  const { status } = req.body;
  const userId = req.user.id; // from auth middleware

  if (!['active', 'offline'].includes(status)) {
    return res.status(400).json({ error: 'Invalid status' });
  }

  try {
    await pool.query(
      `UPDATE users SET status = $1 WHERE id = $2`,
      [status, userId]
    );
    return res.json({ message: 'Status updated successfully', status });
  } catch (err) {
    console.error('updateStatus error:', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

module.exports = { getNearbyWorkers, getWorkerById, updateStatus };
