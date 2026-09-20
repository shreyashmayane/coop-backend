const express = require('express');
const { getNearbyWorkers, getWorkerById, updateStatus } = require('../controllers/worker.controller');
const { getWorkerBookings, updateBookingStatus } = require('../controllers/booking.controller');
const { requireAuth } = require('../middleware/auth.middleware');

const router = express.Router();

router.get('/nearby', getNearbyWorkers);
router.get('/:id', getWorkerById);

// Protected routes (for workers themselves)
router.put('/status', requireAuth, updateStatus);
router.get('/bookings', requireAuth, getWorkerBookings);
router.patch('/bookings/:id/status', requireAuth, updateBookingStatus);

module.exports = router;
