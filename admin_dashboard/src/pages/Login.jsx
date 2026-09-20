import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../config/api';

export default function Login() {
  const navigate = useNavigate();
  const [phone, setPhone]     = useState('');
  const [password, setPassword] = useState('');
  const [error, setError]     = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const res = await api.post('/auth/login', { phone, password });
      const { token, user } = res.data;

      localStorage.setItem('token', token);
      localStorage.setItem('role',  user.role);

      navigate('/dashboard');
    } catch (err) {
      const msg = err.response?.data?.error || 'Login failed. Please try again.';
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <div className="login-logo">🛡️</div>
        <h1 className="login-title">Admin Portal</h1>
        <p className="login-subtitle">Sign in to manage your cooperative platform</p>

        <form onSubmit={handleSubmit} id="login-form">
          <div className="form-group">
            <label className="form-label" htmlFor="login-phone">Phone Number</label>
            <input
              id="login-phone"
              className="form-input"
              type="tel"
              placeholder="9000000001"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
              required
              autoComplete="username"
            />
          </div>

          <div className="form-group">
            <label className="form-label" htmlFor="login-password">Password</label>
            <input
              id="login-password"
              className="form-input"
              type="password"
              placeholder="••••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              autoComplete="current-password"
            />
          </div>

          <button
            id="login-submit"
            className="btn-login"
            type="submit"
            disabled={loading}
          >
            {loading ? 'Signing in…' : 'Sign In'}
          </button>

          {error && (
            <div className="error-alert" role="alert">
              ⚠️ {error}
            </div>
          )}
        </form>
      </div>
    </div>
  );
}
