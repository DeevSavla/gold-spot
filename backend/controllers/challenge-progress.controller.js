import Challenge from '../models/challenge.model.js';
import ChallengeProgress from '../models/challenge-progress.model.js';
import User from '../models/user.model.js';
import { serializeChallengeProgress } from '../utils/serializers.js';

const sourceValues = new Set(['manual', 'google_fit', 'apple_health', 'smart_scale']);

function normalizeLogDate(value = new Date()) {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    return null;
  }

  return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()));
}

function parseNumber(value, fallback = 0) {
  const parsed = Number(value);
  return Number.isNaN(parsed) ? fallback : parsed;
}

function buildActivityPayload(rawActivity = {}) {
  return {
    steps: Math.max(0, Math.round(parseNumber(rawActivity.steps))),
    distanceKm: Math.max(0, parseNumber(rawActivity.distanceKm)),
    calories: Math.max(0, Math.round(parseNumber(rawActivity.calories))),
    durationMinutes: Math.max(0, Math.round(parseNumber(rawActivity.durationMinutes))),
    activeMinutes: Math.max(0, Math.round(parseNumber(rawActivity.activeMinutes))),
  };
}

function optionalMetric(value) {
  if (value === undefined || value === null || value === '') {
    return undefined;
  }

  const parsed = Number(value);
  return Number.isNaN(parsed) ? undefined : parsed;
}

function buildBodyMetricsPayload(rawBodyMetrics = {}) {
  const bodyMetrics = {
    weight: optionalMetric(rawBodyMetrics.weight),
    bmi: optionalMetric(rawBodyMetrics.bmi),
    bodyFat: optionalMetric(rawBodyMetrics.bodyFat),
    muscleMass: optionalMetric(rawBodyMetrics.muscleMass),
    waterContent: optionalMetric(rawBodyMetrics.waterContent),
  };

  return Object.fromEntries(
    Object.entries(bodyMetrics).filter(([, value]) => value !== undefined),
  );
}

async function validateChallengeAndUser(challengeId, userId) {
  const [challenge, user] = await Promise.all([
    Challenge.findOne({ id: challengeId }),
    User.findOne({ id: userId }),
  ]);

  if (!challenge) {
    return { status: 404, message: 'Challenge not found.' };
  }
  if (!user) {
    return { status: 404, message: 'User not found.' };
  }
  if (!challenge.participants.includes(userId)) {
    return { status: 403, message: 'User has not joined this challenge.' };
  }

  return { challenge, user };
}

export async function upsertDailyChallengeProgress(req, res) {
  try {
    const challengeId =
      req.params.challengeId?.toString().trim() || req.body?.challengeId?.toString().trim() || '';
    const userId = req.params.userId?.toString().trim() || req.body?.userId?.toString().trim() || '';
    const logDate = normalizeLogDate(req.params.logDate || req.body?.logDate);
    const exertion = parseNumber(req.body?.exertion, 1);
    const source = req.body?.source?.toString().trim() || 'manual';

    if (!challengeId) {
      return res.status(400).json({ message: 'Challenge is required.' });
    }
    if (!userId) {
      return res.status(400).json({ message: 'User is required.' });
    }
    if (!logDate) {
      return res.status(400).json({ message: 'A valid log date is required.' });
    }
    if (exertion < 1 || exertion > 5) {
      return res.status(400).json({ message: 'Exertion must be between 1 and 5.' });
    }
    if (!sourceValues.has(source)) {
      return res.status(400).json({ message: 'Invalid progress source.' });
    }

    const validation = await validateChallengeAndUser(challengeId, userId);
    if (validation.status) {
      return res.status(validation.status).json({ message: validation.message });
    }

    const activity = buildActivityPayload(req.body?.activity ?? req.body);
    const bodyMetrics = buildBodyMetricsPayload(req.body?.bodyMetrics ?? {});
    const notes = req.body?.notes?.toString().trim() ?? '';

    const $set = {
      activity,
      exertion,
      notes,
      source,
    };

    for (const [key, value] of Object.entries(bodyMetrics)) {
      $set[`bodyMetrics.${key}`] = value;
    }

    const progress = await ChallengeProgress.findOneAndUpdate(
      { challengeId, userId, logDate },
      {
        $set,
        $setOnInsert: { challengeId, userId, logDate },
      },
      {
        upsert: true,
        returnDocument: 'after',
        runValidators: true,
        setDefaultsOnInsert: true,
      },
    );

    return res.status(200).json({
      message: 'Daily challenge progress saved successfully.',
      progress: serializeChallengeProgress(progress),
    });
  } catch (error) {
    console.error('Upsert challenge progress failed:', error);
    return res.status(500).json({ message: 'Failed to save challenge progress.' });
  }
}

export async function createChallengeProgress(req, res) {
  return upsertDailyChallengeProgress(req, res);
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

    const dateFilter = {};
    const from = req.query.from ? normalizeLogDate(req.query.from.toString()) : null;
    const to = req.query.to ? normalizeLogDate(req.query.to.toString()) : null;
    if (from) {
      dateFilter.$gte = from;
    }
    if (to) {
      dateFilter.$lte = to;
    }
    if (Object.keys(dateFilter).length > 0) {
      filter.logDate = dateFilter;
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
