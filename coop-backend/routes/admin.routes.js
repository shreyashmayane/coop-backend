const express    = require('express');
const router     = express.Router();
const { verifyToken, allowRoles } = require('../middleware/auth.middleware');
const {
  getWorkers,
  verifyWorker,
  getBookings,
  getAnalytics,
} = require('../controllers/admin.controller');

// Every route in this file is protected by verifyToken + allowRoles
const adminGuard = [verifyToken, allowRoles('society_admin', 'federation_admin')];

// GET  /api/admin/workers           — list workers (scope-filtered, ?status=pending)
router.get('/workers',                ...adminGuard, getWorkers);

// PATCH /api/admin/workers/:id/verify — approve or reject a worker
router.patch('/workers/:id/verify',   ...adminGuard, verifyWorker);

// GET  /api/admin/bookings           — list all bookings with names
router.get('/bookings',               ...adminGuard, getBookings);

// GET  /api/admin/analytics          — aggregate stat counts
router.get('/analytics',              ...adminGuard, getAnalytics);

module.exports = router;
