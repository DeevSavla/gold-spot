import mongoose from 'mongoose';

const userSchema = new mongoose.Schema(
  {
    id: { type: String, required: true, unique: true },
    name: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, trim: true, lowercase: true },
    passwordHash: { type: String, required: true },
    role: { type: String, enum: ['user', 'trainer'], required: true },
    height: { type: Number },
    weight: { type: Number },
    birthdate: { type: String },
    onboarding: {
      focus: { type: String, enum: ['endurance', 'strength', 'mobility', 'nutrition'] },
      weeklyDays: { type: Number },
      bio: { type: String },
    },
    profile_pic: { type: String },
    challengesParticipated: { type: Number, default: 0 },
  },
  { timestamps: true },
);

const User = mongoose.models.User || mongoose.model('User', userSchema);

export default User;
