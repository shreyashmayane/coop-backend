import { useEffect, useState, useCallback } from 'react';
import api from '../config/api';

function StatusBadge({ status }) {
  const cls = `badge badge-${status?.toLowerCase() || 'pending'}`;
  const labels = { pending: 'Pending', verified: 'Verified', rejected: 'Rejected' };
  return <span className={cls}>{labels[status] || status}</span>;
}

export default function Workers() {
  const [workers, setWorkers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError]     = useState('');
  const [actionLoading, setActionLoading] = useState({}); // { [id]: true }

  const fetchWorkers = useCallback(() => {
    setLoading(true);
    api.get('/admin/workers?status=pending')
      .then((res) => setWorkers(res.data.workers || []))
      .catch(() => setError('Failed to load workers.'))
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => { fetchWorkers(); }, [fetchWorkers]);

  const handleAction = async (id, action) => {
    setActionLoading((prev) => ({ ...prev, [id]: true }));
    try {
      await api.patch(`/admin/workers/${id}/verify`, { action });
      // Refresh list after action
      fetchWorkers();
    } catch (err) {
      alert(err.response?.data?.error || 'Action failed.');
    } finally {
      setActionLoading((prev) => ({ ...prev, [id]: false }));
    }
  };

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Worker Approvals</h1>
        <p className="page-subtitle">Review and verify pending worker registrations</p>
      </div>

      {error && (
        <div className="error-alert" style={{ marginBottom: 24 }} role="alert">
          ⚠️ {error}
        </div>
      )}

      <div className="table-section">
        <div className="table-header">
          <span className="table-title">Pending Workers</span>
          <span className="table-count">{loading ? '…' : `${workers.length} pending`}</span>
        </div>

        <div className="table-wrap">
          {loading ? (
            <div className="state-center">
              <div className="spinner" />
              <span className="state-text">Loading workers…</span>
            </div>
          ) : workers.length === 0 ? (
            <div className="state-center">
              <span className="state-icon">🎉</span>
              <span className="state-title">All caught up!</span>
              <span className="state-text">No workers are pending verification.</span>
            </div>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Phone</th>
                  <th>Skills</th>
                  <th>Status</th>
                  <th>Registered</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {workers.map((w) => (
                  <tr key={w.id}>
                    <td>
                      <strong>{w.name || '—'}</strong>
                      <div className="td-muted">ID: {w.id}</div>
                    </td>
                    <td className="td-muted">{w.phone}</td>
                    <td>
                      {w.skills && w.skills.length > 0 ? (
                        <div className="skills-list">
                          {w.skills.map((s, i) => (
                            <span key={i} className="skill-tag">{s}</span>
                          ))}
                        </div>
                      ) : (
                        <span className="td-muted">—</span>
                      )}
                    </td>
                    <td><StatusBadge status={w.status} /></td>
                    <td className="td-muted">
                      {new Date(w.created_at).toLocaleDateString('en-IN', {
                        day: '2-digit', month: 'short', year: 'numeric',
                      })}
                    </td>
                    <td>
                      <div className="btn-row">
                        <button
                          id={`approve-${w.id}`}
                          className="btn btn-approve"
                          disabled={!!actionLoading[w.id]}
                          onClick={() => handleAction(w.id, 'verify')}
                        >
                          {actionLoading[w.id] ? '…' : '✓ Approve'}
                        </button>
                        <button
                          id={`reject-${w.id}`}
                          className="btn btn-reject"
                          disabled={!!actionLoading[w.id]}
                          onClick={() => handleAction(w.id, 'reject')}
                        >
                          {actionLoading[w.id] ? '…' : '✕ Reject'}
                        </button>
                      </div>
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
