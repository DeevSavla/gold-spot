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
    participants: { type: [{ type: String }], default: null },
    completedUsers: { type: [{ type: String }], default: null },
  },
  { timestamps: true },
);

const Challenge = mongoose.models.Challenge || mongoose.model('Challenge', challengeSchema);

export default Challenge;
