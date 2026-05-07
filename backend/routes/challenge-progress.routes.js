import { Router } from 'express';

import {
  createChallengeProgress,
  listChallengeProgress,
  upsertDailyChallengeProgress,
} from '../controllers/challenge-progress.controller.js';

const router = Router();

router.post('/challenge-progress', createChallengeProgress);
router.patch('/challenge-progress/:challengeId/:userId/:logDate', upsertDailyChallengeProgress);
router.get('/challenge-progress', listChallengeProgress);

export default router;
