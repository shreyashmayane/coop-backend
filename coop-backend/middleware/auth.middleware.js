const jwt = require('jsonwebtoken');

/**
 * verifyToken
 * Validates the Bearer JWT in Authorization header.
 * Attaches decoded payload to req.user on success.
 */
function verifyToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'No token provided' });
  }

  const token = authHeader.split(' ')[1];
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; // { id, role, society_id, federation_id, iat, exp }
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid or expired token' });
  }
}

/**
 * allowRoles(...roles)
 * Factory that returns middleware rejecting requests whose
 * req.user.role is not in the allowed list.
 * Must be used AFTER verifyToken.
 *
 * Usage: router.get('/path', verifyToken, allowRoles('society_admin', 'federation_admin'), handler)
 */
function allowRoles(...roles) {
  return (req, res, next) => {
    if (!req.user || !roles.includes(req.user.role)) {
      return res.status(403).json({
        error: `Access denied. Required role(s): ${roles.join(', ')}`,
      });
    }
    next();
  };
}

module.exports = { verifyToken, allowRoles };
