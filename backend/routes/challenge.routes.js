import { Router } from 'express';

import {
  createChallenge,
  joinChallenge,
  listChallenges,
} from '../controllers/challenge.controller.js';

const router = Router();

router.post('/challenges', createChallenge);
router.get('/challenges', listChallenges);
router.post('/challenges/join', joinChallenge);

export default router;
