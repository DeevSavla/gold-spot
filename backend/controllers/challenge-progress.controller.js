import { randomUUID } from 'node:crypto';

import Challenge from '../models/challenge.model.js';
import ChallengeProgress from '../models/challenge-progress.model.js';
import User from '../models/user.model.js';
import { serializeChallengeProgress } from '../utils/serializers.js';

export async function createChallengeProgress(req, res) {
  try {
    const challengeId = req.body?.challengeId?.toString().trim() ?? '';
    const userId = req.body?.userId?.toString().trim() ?? '';
    const logDate = req.body?.logDate?.toString().trim() ?? new Date().toISOString().substring(0, 10);
    const distanceKm = Number(req.body?.distanceKm ?? 0);
    const durationMinutes = Number(req.body?.durationMinutes ?? 0);
    const exertion = Number(req.body?.exertion);
    const notes = req.body?.notes?.toString().trim() ?? '';

    if (!challengeId) {
      return res.status(400).json({ message: 'Challenge is required.' });
    }
    if (!userId) {
      return res.status(400).json({ message: 'User is required.' });
    }
    if (Number.isNaN(exertion) || exertion < 1 || exertion > 5) {
      return res.status(400).json({ message: 'Exertion must be between 1 and 5.' });
    }

    const [challenge, user] = await Promise.all([
      Challenge.findOne({ id: challengeId }),
      User.findById(userId),
    ]);

    if (!challenge) {
      return res.status(404).json({ message: 'Challenge not found.' });
    }
    if (!user) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const progress = await ChallengeProgress.create({
      id: randomUUID(),
      challengeId,
      userId,
      logDate,
      distanceKm: Number.isNaN(distanceKm) ? 0 : distanceKm,
      durationMinutes: Number.isNaN(durationMinutes) ? 0 : durationMinutes,
      exertion,
      notes,
    });

    return res.status(201).json({
      message: 'Challenge progress logged successfully.',
      progress: serializeChallengeProgress(progress),
    });
  } catch (error) {
    console.error('Create challenge progress failed:', error);
    return res.status(500).json({ message: 'Failed to log challenge progress.' });
  }
}

export async function listChallengeProgress(req, res) {
  try {
    const filter = {};
    if (req.query.challengeId) {
      filter.challengeId = req.query.challengeId.toString();
    }
    if (req.query.userId) {
      filter.userId = req.query.userId.toString();
    }

    const progress = await ChallengeProgress.find(filter).sort({ logDate: -1, createdAt: -1 });
    return res.status(200).json({
      progress: progress.map(serializeChallengeProgress),
    });
  } catch (error) {
    console.error('Fetch challenge progress failed:', error);
    return res.status(500).json({ message: 'Failed to fetch challenge progress.' });
  }
}
