export function serializeUser(user) {
  return {
    id: user.id,
    name: user.name,
    email: user.email,
    role: user.role,
    height: user.height ?? null,
    weight: user.weight ?? null,
    birthdate: user.birthdate ?? null,
    onboarding: {
      focus: user.onboarding?.focus ?? 'endurance',
      weeklyDays: user.onboarding?.weeklyDays ?? 3,
      bio: user.onboarding?.bio ?? '',
    },
    profile_pic: user.profile_pic ?? null,
    challengesParticipated: user.challengesParticipated ?? 0,
  };
}

export function serializeChallenge(challenge) {
  const participantUsers = Array.isArray(challenge.participantUsers)
    ? challenge.participantUsers
    : [];

  return {
    id: challenge.id,
    name: challenge.name,
    category: challenge.category,
    duration: challenge.duration,
    description: challenge.description,
    creatorId: challenge.creatorId,
    joinCode: challenge.joinCode,
    participants: challenge.participants ?? [],
    activeParticipants: participantUsers.map((participant) => ({
      id: participant.id,
      name: participant.name,
    })),
    completedUsers: challenge.completedUsers ?? [],
  };
}

export function serializeChallengeProgress(progress) {
  return {
    id: progress.id,
    challengeId: progress.challengeId,
    userId: progress.userId,
    logDate: progress.logDate,
    activity: {
      steps: progress.activity?.steps ?? 0,
      distanceKm: progress.activity?.distanceKm ?? 0,
      calories: progress.activity?.calories ?? 0,
      durationMinutes: progress.activity?.durationMinutes ?? 0,
      activeMinutes: progress.activity?.activeMinutes ?? 0,
    },
    bodyMetrics: {
      weight: progress.bodyMetrics?.weight ?? null,
      bmi: progress.bodyMetrics?.bmi ?? null,
      bodyFat: progress.bodyMetrics?.bodyFat ?? null,
      muscleMass: progress.bodyMetrics?.muscleMass ?? null,
      waterContent: progress.bodyMetrics?.waterContent ?? null,
    },
    exertion: progress.exertion,
    notes: progress.notes,
    source: progress.source,
  };
}
