const express = require('express');
const {
  createBooking,
  getBookingById,
  cancelBooking,
  rateBooking
} = require('../controllers/booking.controller');
const { verifyToken } = require('../middleware/auth.middleware');

const router = express.Router();

router.post('/', verifyToken, createBooking);
router.get('/:id', verifyToken, getBookingById);
router.patch('/:id/cancel', verifyToken, cancelBooking);
router.post('/:id/rate', verifyToken, rateBooking);

module.exports = router;
