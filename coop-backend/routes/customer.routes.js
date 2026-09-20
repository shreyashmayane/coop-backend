const express = require('express');
const { getCustomerBookings } = require('../controllers/booking.controller');
const { verifyToken } = require('../middleware/auth.middleware');

const router = express.Router();

router.get('/bookings', verifyToken, getCustomerBookings);

module.exports = router;
