import 'dart:typed_data';

enum AppScreen {
  onboarding,
  logoutLoading,
  login,
  signup,
  dashboard,
  profile,
  profileEdit,
  challengeDetails,
  leaderboard,
  createChallenge,
  dailyCheckin,
  trainerDashboard,
  challengeUserProgress,
  joinChallenge,
  bodyComposition,
}

enum AuthRole { user, trainer }

class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.height,
    this.weight,
    this.birthdate,
    this.focus = 'endurance',
    this.weeklyDays = 3,
    this.bio = '',
    this.profile_pic,
    this.challengesParticipated = 0,
  });

  final String id;
  final String name;
  final String email;
  final AuthRole role;
  final double? height;
  final double? weight;
  final String? birthdate;
  final String focus;
  final int weeklyDays;
  final String bio;
  final String? profile_pic;
  final int challengesParticipated;
}

class LoginPayload {
  const LoginPayload({
    required this.email,
    required this.password,
    required this.role,
  });

  final String email;
  final String password;
  final AuthRole role;
}

class SignupPayload {
  const SignupPayload({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.height,
    required this.weight,
    required this.birthdate,
    required this.focus,
    required this.weeklyDays,
    required this.bio,
    this.profileImage,
  });

  final String name;
  final String email;
  final String password;
  final AuthRole role;
  final double height;
  final double weight;
  final String birthdate;
  final String focus;
  final int weeklyDays;
  final String bio;
  final SignupImageFile? profileImage;
}

class SignupImageFile {
  const SignupImageFile({
    required this.filename,
    required this.bytes,
  });

  final String filename;
  final Uint8List bytes;
}

class ProfileUpdatePayload {
  const ProfileUpdatePayload({
    required this.name,
    required this.height,
    required this.weight,
    required this.birthdate,
    required this.focus,
    required this.weeklyDays,
    required this.bio,
  });

  final String name;
  final double height;
  final double weight;
  final String birthdate;
  final String focus;
  final int weeklyDays;
  final String bio;
}

class CreateChallengePayload {
  const CreateChallengePayload({
    required this.name,
    required this.category,
    required this.duration,
    required this.description,
  });

  final String name;
  final String category;
  final int duration;
  final String description;
}

class DailyProgressPayload {
  const DailyProgressPayload({
    required this.logDate,
    required this.steps,
    required this.distanceKm,
    required this.calories,
    required this.durationMinutes,
    required this.activeMinutes,
    required this.exertion,
    required this.notes,
    this.weight,
    this.bmi,
    this.bodyFat,
    this.muscleMass,
    this.waterContent,
  });

  final DateTime logDate;
  final int steps;
  final double distanceKm;
  final int calories;
  final int durationMinutes;
  final int activeMinutes;
  final int exertion;
  final String notes;
  final double? weight;
  final double? bmi;
  final double? bodyFat;
  final double? muscleMass;
  final double? waterContent;
}

class BodyCompositionReading {
  const BodyCompositionReading({
    required this.weight,
    required this.bmi,
    required this.bodyFat,
    required this.muscleMass,
    required this.waterContent,
  });

  final double weight;
  final double bmi;
  final double bodyFat;
  final double muscleMass;
  final double waterContent;
}

class ChallengeSummary {
  const ChallengeSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.description,
    required this.creatorId,
    required this.joinCode,
    required this.participants,
    this.activeParticipants = const <ChallengeParticipant>[],
  });

  final String id;
  final String name;
  final String category;
  final int duration;
  final String description;
  final String creatorId;
  final String joinCode;
  final List<String> participants;
  final List<ChallengeParticipant> activeParticipants;
}

class ChallengeParticipant {
  const ChallengeParticipant({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}
