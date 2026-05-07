import { Router } from 'express';

import {
  createChallengeProgress,
  listChallengeProgress,
} from '../controllers/challenge-progress.controller.js';

const router = Router();

router.post('/challenge-progress', createChallengeProgress);
router.get('/challenge-progress', listChallengeProgress);

export default router;
