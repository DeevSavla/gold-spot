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
    required this.exertion,
    required this.notes,
    this.weight,
    this.bmi,
    this.bodyFat,
    this.subcutaneousFat,
    this.visceralFat,
    this.muscleMass,
    this.skeletalMuscle,
    this.muscleRate,
    this.waterContent,
    this.protein,
    this.bmr,
    this.boneMass,
    this.physicalAge,
    this.bodyScore,
  });

  final DateTime logDate;
  final int steps;
  final int exertion;
  final String notes;
  final double? weight;
  final double? bmi;
  final double? bodyFat;
  final double? subcutaneousFat;
  final double? visceralFat;
  final double? muscleMass;
  final double? skeletalMuscle;
  final double? muscleRate;
  final double? waterContent;
  final double? protein;
  final double? bmr;
  final double? boneMass;
  final double? physicalAge;
  final double? bodyScore;
}

class BodyCompositionReading {
  const BodyCompositionReading({
    required this.weight,
    required this.bmi,
    required this.bodyFat,
    required this.subcutaneousFat,
    required this.visceralFat,
    required this.muscleMass,
    required this.skeletalMuscle,
    required this.muscleRate,
    required this.waterContent,
    required this.protein,
    required this.bmr,
    required this.boneMass,
    required this.physicalAge,
    required this.bodyScore,
  });

  final double weight;
  final double bmi;
  final double bodyFat;
  final double subcutaneousFat;
  final double visceralFat;
  final double muscleMass;
  final double skeletalMuscle;
  final double muscleRate;
  final double waterContent;
  final double protein;
  final double bmr;
  final double boneMass;
  final double physicalAge;
  final double bodyScore;
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
