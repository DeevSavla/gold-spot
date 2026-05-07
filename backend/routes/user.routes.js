import { Router } from 'express';

import {
  deleteProfile,
  getMe,
  login,
  signup,
  updateProfile,
  uploadProfilePhoto,
} from '../controllers/user.controller.js';
import { authMiddleware } from '../middleware/auth.middleware.js';
import { upload } from '../middleware/upload.middleware.js';

const router = Router();

router.get('/auth/me', authMiddleware, getMe);
router.post('/signup', upload.single('profileImage'), signup);
router.post('/login', login);
router.patch('/profile/:id', updateProfile);
router.post('/profile/:id/photo', upload.single('profileImage'), uploadProfilePhoto);
router.delete('/profile/:id', deleteProfile);

export default router;
