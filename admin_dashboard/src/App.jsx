import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import Sidebar    from './components/Sidebar';
import Login      from './pages/Login';
import Dashboard  from './pages/Dashboard';
import Workers    from './pages/Workers';
import Bookings   from './pages/Bookings';

/**
 * ProtectedRoute — wraps any route that requires authentication.
 * Redirects to /login if no token is found in localStorage.
 */
function ProtectedRoute({ children }) {
  const token = localStorage.getItem('token');
  if (!token) return <Navigate to="/login" replace />;
  return (
    <div className="app-shell">
      <Sidebar />
      <main className="main-content">
        {children}
      </main>
    </div>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* Public */}
        <Route path="/login" element={<Login />} />

        {/* Protected */}
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <Dashboard />
            </ProtectedRoute>
          }
        />
        <Route
          path="/workers"
          element={
            <ProtectedRoute>
              <Workers />
            </ProtectedRoute>
          }
        />
        <Route
          path="/bookings"
          element={
            <ProtectedRoute>
              <Bookings />
            </ProtectedRoute>
          }
        />

        {/* Fallback */}
        <Route path="*" element={<Navigate to="/dashboard" replace />} />
      </Routes>
    </BrowserRouter>
  );
}
