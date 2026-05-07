import bcrypt from 'bcrypt';
import { randomUUID } from 'node:crypto';

import User from '../models/user.model.js';
import { createToken, isBcryptHash } from '../utils/auth.js';
import { serializeUser } from '../utils/serializers.js';
import { uploadProfileImage } from '../utils/storage.js';

const SALT_ROUNDS = 10;

export function getMe(req, res) {
  return res.status(200).json({
    user: serializeUser(req.authUser),
  });
}

export async function signup(req, res) {
  try {
    const name = req.body?.name?.toString().trim() ?? '';
    const email = req.body?.email?.toString().trim().toLowerCase() ?? '';
    const password = req.body?.password?.toString() ?? '';
    const role = req.body?.role === 'trainer' ? 'trainer' : 'user';
    const height = Number(req.body?.height);
    const weight = Number(req.body?.weight);
    const birthdate = req.body?.birthdate?.toString().trim() ?? '';
    const focus = req.body?.focus?.toString().trim() ?? 'endurance';
    const weeklyDays = Number(req.body?.weeklyDays);
    const bio = req.body?.bio?.toString().trim() ?? '';

    if (!name || !email || !password) {
      return res.status(400).json({ message: 'Name, email, and password are required.' });
    }
    if (Number.isNaN(height) || height < 50 || height > 300) {
      return res.status(400).json({ message: 'Height must be between 50 and 300 cm.' });
    }
    if (Number.isNaN(weight) || weight < 20 || weight > 500) {
      return res.status(400).json({ message: 'Weight must be between 20 and 500 kg.' });
    }
    if (!birthdate) {
      return res.status(400).json({ message: 'Birthdate is required.' });
    }
    if (Number.isNaN(weeklyDays) || weeklyDays < 1 || weeklyDays > 7) {
      return res.status(400).json({ message: 'Weekly training days must be between 1 and 7.' });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(409).json({ message: 'An account with this email already exists.' });
    }

    const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS);
    const profile_pic = await uploadProfileImage(req.file, email);

    const newUser = await User.create({
      id: randomUUID(),
      name,
      email,
      passwordHash: hashedPassword,
      role,
      height,
      weight,
      birthdate,
      onboarding: { focus, weeklyDays, bio },
      profile_pic,
      challengesParticipated: 0,
    });

    return res.status(201).json({
      message: 'Account created successfully.',
      user: serializeUser(newUser),
      token: createToken(newUser),
    });
  } catch (error) {
    console.error('Signup failed:', error);
    return res.status(500).json({ message: 'Something went wrong while creating the account.' });
  }
}

export async function login(req, res) {
  try {
    const email = req.body?.email?.toString().trim().toLowerCase() ?? '';
    const password = req.body?.password?.toString() ?? '';

    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required.' });
    }

    const existingUser = await User.findOne({ email });
    if (!existingUser) {
      return res.status(404).json({ message: 'No account found for this email. Please sign up first.' });
    }

    const storedPasswordValue =
      typeof existingUser.passwordHash === 'string' && existingUser.passwordHash.length > 0
        ? existingUser.passwordHash
        : typeof existingUser.password === 'string' && existingUser.password.length > 0
          ? existingUser.password
          : '';

    if (storedPasswordValue.length == 0) {
      return res.status(500).json({
        message: 'This account has an invalid stored password. Please create it again.',
      });
    }

    let passwordMatches = false;
    if (isBcryptHash(storedPasswordValue)) {
      passwordMatches = await bcrypt.compare(password, storedPasswordValue);
    } else {
      passwordMatches = storedPasswordValue === password;
      if (passwordMatches) {
        existingUser.passwordHash = await bcrypt.hash(password, SALT_ROUNDS);
        existingUser.password = undefined;
        await existingUser.save();
      }
    }

    if (!passwordMatches) {
      return res.status(401).json({ message: 'Invalid email or password.' });
    }

    return res.status(200).json({
      message: 'Login successful.',
      user: serializeUser(existingUser),
      token: createToken(existingUser),
    });
  } catch (error) {
    console.error('Login failed:', error);
    return res.status(500).json({ message: 'Something went wrong while logging in.' });
  }
}

export async function updateProfile(req, res) {
  try {
    const user = await User.findOne({ id: req.params.id });
    if (!user) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const name = req.body?.name?.toString().trim() ?? '';
    const height = Number(req.body?.height);
    const weight = Number(req.body?.weight);
    const birthdate = req.body?.birthdate?.toString().trim() ?? '';
    const focus = req.body?.onboarding?.focus?.toString().trim() ?? 'endurance';
    const weeklyDays = Number(req.body?.onboarding?.weeklyDays);
    const bio = req.body?.onboarding?.bio?.toString().trim() ?? '';

    if (!name) {
      return res.status(400).json({ message: 'Name is required.' });
    }
    if (Number.isNaN(height) || height < 50 || height > 300) {
      return res.status(400).json({ message: 'Height must be between 50 and 300 cm.' });
    }
    if (Number.isNaN(weight) || weight < 20 || weight > 500) {
      return res.status(400).json({ message: 'Weight must be between 20 and 500 kg.' });
    }
    if (!birthdate) {
      return res.status(400).json({ message: 'Birthdate is required.' });
    }
    if (Number.isNaN(weeklyDays) || weeklyDays < 1 || weeklyDays > 7) {
      return res.status(400).json({ message: 'Weekly training days must be between 1 and 7.' });
    }

    user.name = name;
    user.height = height;
    user.weight = weight;
    user.birthdate = birthdate;
    user.onboarding = { focus, weeklyDays, bio };
    await user.save();

    return res.status(200).json({
      message: 'Profile updated successfully.',
      user: serializeUser(user),
    });
  } catch (error) {
    console.error('Profile update failed:', error);
    return res.status(500).json({ message: 'Something went wrong while updating the profile.' });
  }
}

export async function uploadProfilePhoto(req, res) {
  try {
    const user = await User.findOne({ id: req.params.id });
    if (!user) {
      return res.status(404).json({ message: 'User not found.' });
    }
    if (!req.file) {
      return res.status(400).json({ message: 'Profile image is required.' });
    }

    const profile_pic = await uploadProfileImage(req.file, user.email);
    user.profile_pic = profile_pic;
    await user.save();

    return res.status(200).json({
      message: 'Profile photo updated successfully.',
      user: serializeUser(user),
    });
  } catch (error) {
    console.error('Profile image upload failed:', error);
    return res.status(500).json({ message: 'Something went wrong while uploading the profile photo.' });
  }
}

export async function deleteProfile(req, res) {
  try {
    const deletedUser = await User.findOneAndDelete({ id: req.params.id });
    if (!deletedUser) {
      return res.status(404).json({ message: 'User not found.' });
    }
    return res.status(200).json({ message: 'Account deleted successfully.' });
  } catch (error) {
    console.error('Delete account failed:', error);
    return res.status(500).json({ message: 'Something went wrong while deleting the account.' });
  }
}
