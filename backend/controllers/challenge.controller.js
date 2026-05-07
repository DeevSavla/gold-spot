import { randomUUID } from 'node:crypto';

import Challenge from '../models/challenge.model.js';
import User from '../models/user.model.js';
import { serializeChallenge, serializeUser } from '../utils/serializers.js';

function generateJoinCode() {
  return Math.random().toString(36).substring(2, 8).toUpperCase();
}

export async function createChallenge(req, res) {
  try {
    const name = req.body?.name?.toString().trim() ?? '';
    const category = req.body?.category?.toString().trim() ?? '';
    const duration = Number(req.body?.duration);
    const description = req.body?.description?.toString().trim() ?? '';
    const creatorId = req.body?.creatorId?.toString().trim() ?? '';

    if (!name) {
      return res.status(400).json({ message: 'Challenge name is required.' });
    }
    if (!category) {
      return res.status(400).json({ message: 'Challenge category is required.' });
    }
    if (Number.isNaN(duration) || duration < 1) {
      return res.status(400).json({ message: 'Duration must be at least 1 day.' });
    }
    if (!creatorId) {
      return res.status(400).json({ message: 'Creator is required.' });
    }

    const creator = await User.findOne({ id: creatorId });
    if (!creator) {
      return res.status(404).json({ message: 'Creator user not found.' });
    }
    if (creator.role !== 'trainer') {
      return res.status(403).json({ message: 'Only trainer accounts can create challenges.' });
    }

    let joinCode = generateJoinCode();
    while (await Challenge.findOne({ joinCode })) {
      joinCode = generateJoinCode();
    }

    const challenge = await Challenge.create({
      id: randomUUID(),
      name,
      category,
      duration,
      description,
      creatorId,
      joinCode,
      participants: [],
      completedUsers: [],
    });

    return res.status(201).json({
      message: 'Challenge created successfully.',
      challenge: serializeChallenge(challenge),
    });
  } catch (error) {
    console.error('Create challenge failed:', error);
    return res.status(500).json({ message: 'Failed to create challenge.' });
  }
}

export async function listChallenges(_req, res) {
  try {
    const challenges = await Challenge.find().sort({ createdAt: -1 });
    return res.status(200).json({
      challenges: challenges.map(serializeChallenge),
    });
  } catch (error) {
    console.error('Fetch challenges failed:', error);
    return res.status(500).json({ message: 'Failed to fetch challenges.' });
  }
}

export async function joinChallenge(req, res) {
  try {
    const joinCode = req.body?.joinCode?.toString().trim().toUpperCase() ?? '';
    const userId = req.body?.userId?.toString().trim() ?? '';

    if (!joinCode) {
      return res.status(400).json({ message: 'Join code is required.' });
    }
    if (!userId) {
      return res.status(400).json({ message: 'User is required.' });
    }

    const user = await User.findOne({ id: userId });
    if (!user) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const challenge = await Challenge.findOne({ joinCode });
    if (!challenge) {
      return res.status(404).json({ message: 'Invalid join code.' });
    }

    const participants = Array.isArray(challenge.participants) ? challenge.participants : [];
    const alreadyJoined = participants.includes(user.id);

    if (!alreadyJoined) {
      challenge.participants = [...participants, user.id];
      user.challengesParticipated = (user.challengesParticipated ?? 0) + 1;
      await challenge.save();
      await user.save();
    }

    return res.status(200).json({
      message: alreadyJoined ? 'You already joined this challenge.' : 'Challenge joined successfully.',
      challenge: serializeChallenge(challenge),
      user: serializeUser(user),
    });
  } catch (error) {
    console.error('Join challenge failed:', error);
    return res.status(500).json({ message: 'Failed to join challenge.' });
  }
}
