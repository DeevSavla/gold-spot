import mongoose from 'mongoose';

const challengeProgressSchema = new mongoose.Schema(
  {
    id: { type: String, required: true, unique: true },
    challengeId: { type: String, required: true, index: true },
    userId: { type: String, required: true, index: true },
    logDate: { type: String, required: true },
    distanceKm: { type: Number, default: 0, min: 0 },
    durationMinutes: { type: Number, default: 0, min: 0 },
    exertion: { type: Number, required: true, min: 1, max: 5 },
    notes: { type: String, default: '' },
  },
  { timestamps: true },
);

const ChallengeProgress =
  mongoose.models.ChallengeProgress || mongoose.model('ChallengeProgress', challengeProgressSchema);

export default ChallengeProgress;
