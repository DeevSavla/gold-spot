import mongoose from 'mongoose';

const challengeProgressSchema = new mongoose.Schema(
  {
    challengeId: {
      type: String,
      required: true,
      index: true,
    },

    userId: {
      type: String,
      required: true,
      index: true,
    },

    logDate: {
      type: Date,
      required: true,
      index: true,
    },

    activity: {
      steps: {
        type: Number,
        default: 0,
      },

      distanceKm: {
        type: Number,
        default: 0,
      },

      calories: {
        type: Number,
        default: 0,
      },

      durationMinutes: {
        type: Number,
        default: 0,
      },

      activeMinutes: {
        type: Number,
        default: 0,
      },
    },

    bodyMetrics: {
      weight: Number,
      bmi: Number,
      bodyFat: Number,
      muscleMass: Number,
      waterContent: Number,
    },

    exertion: {
      type: Number,
      min: 1,
      max: 5,
      default: 1,
    },

    notes: {
      type: String,
      default: '',
    },

    source: {
      type: String,
      enum: ['manual', 'google_fit', 'apple_health', 'smart_scale'],
      default: 'manual',
    },
  },
  {
    timestamps: true,
  }
);

challengeProgressSchema.index(
  { challengeId: 1, userId: 1, logDate: 1 },
  { unique: true }
);
challengeProgressSchema.index({ challengeId: 1, logDate: -1 });
challengeProgressSchema.index({ challengeId: 1, userId: 1, logDate: -1 });

const ChallengeProgress = mongoose.model(
  'ChallengeProgress',
  challengeProgressSchema
);

export default ChallengeProgress;
