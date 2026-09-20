const express = require('express');
const {
  createBooking,
  getBookingById,
  cancelBooking,
  rateBooking
} = require('../controllers/booking.controller');
const { requireAuth } = require('../middleware/auth.middleware');

const router = express.Router();

router.post('/', requireAuth, createBooking);
router.get('/:id', requireAuth, getBookingById);
router.patch('/:id/cancel', requireAuth, cancelBooking);
router.post('/:id/rate', requireAuth, rateBooking);

module.exports = router;
