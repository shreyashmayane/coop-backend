require('dotenv').config();
const express = require('express');
const cors = require('cors');

const authRoutes  = require('./routes/auth.routes');
const adminRoutes = require('./routes/admin.routes');

const app  = express();
const PORT = process.env.PORT || 3000;

// ─── CORS ─────────────────────────────────────────────────────────────────────
// Allow the admin dashboard (any port on LAN) and mobile app traffic.
// In production, replace origin with your deployed domain.
app.use(cors({
  origin: true,          // reflect the request origin — safe for LAN use
  credentials: true,
}));
app.use(express.json());

// ─── Routes ───────────────────────────────────────────────────────────────────
app.use('/api/auth',  authRoutes);
app.use('/api/admin', adminRoutes);

// ─── Health check ─────────────────────────────────────────────────────────────
app.get('/api/health', (_req, res) => res.json({ status: 'ok', ts: new Date() }));

// ─── 404 handler ──────────────────────────────────────────────────────────────
app.use((_req, res) => res.status(404).json({ error: 'Route not found' }));

// ─── Start ────────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`🚀  coop-backend listening on http://localhost:${PORT}`);
});
