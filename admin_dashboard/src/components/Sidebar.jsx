import { NavLink, useNavigate } from 'react-router-dom';

const navItems = [
  { to: '/dashboard', icon: '📊', label: 'Dashboard' },
  { to: '/workers',   icon: '👷', label: 'Workers' },
  { to: '/bookings',  icon: '📋', label: 'Bookings' },
];

export default function Sidebar() {
  const navigate = useNavigate();
  const role = localStorage.getItem('role') || 'admin';

  const formatRole = (r) =>
    r.replace('_', ' ').replace(/\b\w/g, (c) => c.toUpperCase());

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('role');
    navigate('/login');
  };

  return (
    <aside className="sidebar">
      <div className="sidebar-brand">
        <div className="sidebar-brand-name">CoopAdmin</div>
        <div className="sidebar-brand-sub">Management Portal</div>
      </div>

      <div className="sidebar-role-badge">
        {formatRole(role)}
      </div>

      <nav className="sidebar-nav">
        {navItems.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) => (isActive ? 'active' : '')}
          >
            <span className="nav-icon">{item.icon}</span>
            {item.label}
          </NavLink>
        ))}
      </nav>

      <div className="sidebar-footer">
        <button className="btn-logout" onClick={handleLogout}>
          <span className="nav-icon">🚪</span>
          Logout
        </button>
      </div>
    </aside>
  );
}
