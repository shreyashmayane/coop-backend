import { useEffect, useState } from 'react';
import api from '../config/api';

const STATUS_MAP = {
  pending:   'badge-pending',
  completed: 'badge-completed',
  cancelled: 'badge-rejected',
  active:    'badge-active',
  verified:  'badge-verified',
};

function BookingBadge({ status }) {
  const cls = `badge ${STATUS_MAP[status?.toLowerCase()] || 'badge-pending'}`;
  const label = status
    ? status.charAt(0).toUpperCase() + status.slice(1)
    : 'Unknown';
  return <span className={cls}>{label}</span>;
}

export default function Bookings() {
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading]   = useState(true);
  const [error, setError]       = useState('');

  useEffect(() => {
    api.get('/admin/bookings')
      .then((res) => setBookings(res.data.bookings || []))
      .catch(() => setError('Failed to load bookings.'))
      .finally(() => setLoading(false));
  }, []);

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Bookings</h1>
        <p className="page-subtitle">Read-only overview of all service bookings in your scope</p>
      </div>

      {error && (
        <div className="error-alert" style={{ marginBottom: 24 }} role="alert">
          ⚠️ {error}
        </div>
      )}

      <div className="table-section">
        <div className="table-header">
          <span className="table-title">All Bookings</span>
          <span className="table-count">{loading ? '…' : `${bookings.length} total`}</span>
        </div>

        <div className="table-wrap">
          {loading ? (
            <div className="state-center">
              <div className="spinner" />
              <span className="state-text">Loading bookings…</span>
            </div>
          ) : bookings.length === 0 ? (
            <div className="state-center">
              <span className="state-icon">📭</span>
              <span className="state-title">No bookings yet</span>
              <span className="state-text">Bookings will appear here once customers start booking.</span>
            </div>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Customer</th>
                  <th>Worker</th>
                  <th>Service Type</th>
                  <th>Status</th>
                  <th>Date</th>
                </tr>
              </thead>
              <tbody>
                {bookings.map((b) => (
                  <tr key={b.id}>
                    <td className="td-muted">#{b.id}</td>
                    <td>
                      <strong>{b.customer_name || 'Unknown'}</strong>
                      {b.customer_phone && (
                        <div className="td-muted">{b.customer_phone}</div>
                      )}
                    </td>
                    <td>
                      <strong>{b.worker_name || 'Unassigned'}</strong>
                      {b.worker_phone && (
                        <div className="td-muted">{b.worker_phone}</div>
                      )}
                    </td>
                    <td className="td-muted">{b.service_type || '—'}</td>
                    <td><BookingBadge status={b.status} /></td>
                    <td className="td-muted">
                      {new Date(b.created_at).toLocaleDateString('en-IN', {
                        day: '2-digit', month: 'short', year: 'numeric',
                      })}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  );
}
