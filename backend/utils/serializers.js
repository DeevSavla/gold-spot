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
    distanceKm: progress.distanceKm,
    durationMinutes: progress.durationMinutes,
    exertion: progress.exertion,
    notes: progress.notes,
  };
}
