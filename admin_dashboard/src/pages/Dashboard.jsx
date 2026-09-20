import { useEffect, useState } from 'react';
import api from '../config/api';
import StatCard from '../components/StatCard';

const STAT_CONFIG = [
  { key: 'totalWorkers',        icon: '👷', label: 'Total Workers',         variant: 'accent'   },
  { key: 'pendingVerification', icon: '⏳', label: 'Pending Verification',  variant: 'warning'  },
  { key: 'totalBookings',       icon: '📋', label: 'Total Bookings',         variant: 'info'     },
  { key: 'completedBookings',   icon: '✅', label: 'Completed Bookings',     variant: 'success'  },
];

export default function Dashboard() {
  const [stats, setStats]     = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError]     = useState('');
  const role = localStorage.getItem('role') || '';

  useEffect(() => {
    api.get('/admin/analytics')
      .then((res) => setStats(res.data))
      .catch(() => setError('Failed to load analytics.'))
      .finally(() => setLoading(false));
  }, []);

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Dashboard</h1>
        <p className="page-subtitle">
          {role === 'federation_admin'
            ? 'Federation-wide overview across all societies'
            : 'Society-level overview for your area'}
        </p>
      </div>

      {error && (
        <div className="error-alert" style={{ marginBottom: 24 }} role="alert">
          ⚠️ {error}
        </div>
      )}

      <div className="stat-grid">
        {STAT_CONFIG.map(({ key, icon, label, variant }) => (
          <StatCard
            key={key}
            icon={icon}
            label={label}
            variant={variant}
            value={stats ? stats[key] : 0}
            loading={loading}
          />
        ))}
      </div>

      {!loading && stats && (
        <div className="table-section">
          <div className="table-header">
            <span className="table-title">Quick Summary</span>
          </div>
          <div style={{ padding: '24px', color: 'var(--text-secondary)', fontSize: '0.9rem', lineHeight: 1.8 }}>
            <p>📌 <strong style={{ color: 'var(--text-primary)' }}>{stats.pendingVerification}</strong> worker(s) are waiting for your approval — visit the <strong style={{ color: 'var(--accent-light)' }}>Workers</strong> page to review.</p>
            <p style={{ marginTop: 12 }}>📌 <strong style={{ color: 'var(--text-primary)' }}>{stats.completedBookings}</strong> of <strong style={{ color: 'var(--text-primary)' }}>{stats.totalBookings}</strong> bookings have been completed ({stats.totalBookings > 0 ? Math.round((stats.completedBookings / stats.totalBookings) * 100) : 0}% completion rate).</p>
          </div>
        </div>
      )}
    </div>
  );
}
