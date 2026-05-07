import jwt from 'jsonwebtoken';

import User from '../models/user.model.js';

export async function authMiddleware(req, res, next) {
  try {
    const authHeader = req.headers.authorization ?? '';
    const token = authHeader.startsWith('Bearer ') ? authHeader.substring(7) : '';

    if (!token) {
      return res.status(401).json({ message: 'Authentication token is required.' });
    }

    if (!process.env.JWT_SECRET) {
      throw new Error('JWT_SECRET is missing. Add it to backend/.env.');
    }

    const payload = jwt.verify(token, process.env.JWT_SECRET);
    const userId = typeof payload === 'object' ? payload.sub : null;
    if (!userId) {
      return res.status(401).json({ message: 'Invalid token.' });
    }

    const user = await User.findById(userId);
    if (!user) {
      return res.status(401).json({ message: 'User not found for token.' });
    }

    req.authUser = user;
    next();
  } catch (error) {
    return res.status(401).json({ message: 'Invalid or expired token.' });
  }
}
