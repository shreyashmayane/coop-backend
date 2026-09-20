/**
 * StatCard — Reusable metric display card.
 *
 * Props:
 *   icon    {string}  — emoji or character icon
 *   value   {number}  — the big number to display
 *   label   {string}  — description below the number
 *   variant {string}  — 'accent' | 'success' | 'warning' | 'info'
 *   loading {boolean} — shows skeleton while data loads
 */
export default function StatCard({ icon, value, label, variant = 'accent', loading = false }) {
  return (
    <div className={`stat-card ${variant}`}>
      <span className="stat-icon">{icon}</span>
      {loading ? (
        <div className="stat-value" style={{ color: 'var(--text-muted)', fontSize: '1.4rem' }}>
          —
        </div>
      ) : (
        <div className="stat-value">
          {typeof value === 'number' ? value.toLocaleString() : value}
        </div>
      )}
      <div className="stat-label">{label}</div>
    </div>
  );
}
