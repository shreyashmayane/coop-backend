const express = require('express');
const { getNearbyWorkers, getWorkerById, updateStatus } = require('../controllers/worker.controller');
const { getWorkerBookings, updateBookingStatus } = require('../controllers/booking.controller');
const { verifyToken } = require('../middleware/auth.middleware');

const router = express.Router();

router.get('/nearby', getNearbyWorkers);
router.get('/:id', getWorkerById);

// Protected routes (for workers themselves)
router.put('/status', verifyToken, updateStatus);
router.get('/bookings', verifyToken, getWorkerBookings);
router.patch('/bookings/:id/status', verifyToken, updateBookingStatus);

module.exports = router;
