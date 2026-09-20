const express = require('express');
const { getCustomerBookings } = require('../controllers/booking.controller');
const { requireAuth } = require('../middleware/auth.middleware');

const router = express.Router();

router.get('/bookings', requireAuth, getCustomerBookings);

module.exports = router;
