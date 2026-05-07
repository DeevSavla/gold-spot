import mongoose from 'mongoose';

const challengeSchema = new mongoose.Schema(
  {
    id: { type: String, required: true, unique: true },
    name: { type: String, required: true },
    category: { type: String, required: true },
    duration: { type: Number, required: true },
    description: { type: String, default: '' },
    creatorId: { type: String, required: true },
    joinCode: { type: String, required: true, unique: true },
    participants: { type: [{ type: String }], default: [] },
    completedUsers: { type: [{ type: String }], default: [] },
  },
  { timestamps: true, toJSON: { virtuals: true }, toObject: { virtuals: true } },
);

challengeSchema.virtual('creator', {
  ref: 'User',
  localField: 'creatorId',
  foreignField: 'id',
  justOne: true,
});

challengeSchema.virtual('participantUsers', {
  ref: 'User',
  localField: 'participants',
  foreignField: 'id',
});

challengeSchema.virtual('completedUserProfiles', {
  ref: 'User',
  localField: 'completedUsers',
  foreignField: 'id',
});

const Challenge = mongoose.models.Challenge || mongoose.model('Challenge', challengeSchema);

export default Challenge;
