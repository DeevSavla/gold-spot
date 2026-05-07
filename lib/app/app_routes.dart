part of '../main.dart';

const List<AppScreen> hideBottomNav = <AppScreen>[
  AppScreen.onboarding,
  AppScreen.logoutLoading,
  AppScreen.login,
  AppScreen.signup,
  AppScreen.profileEdit,
  AppScreen.createChallenge,
  AppScreen.joinChallenge,
  AppScreen.dailyCheckin,
  AppScreen.challengeUserProgress,
  AppScreen.bodyComposition,
];

const Map<AppScreen, List<AuthRole>> screenAllowedRoles = <AppScreen, List<AuthRole>>{
  AppScreen.dashboard: <AuthRole>[AuthRole.user],
  AppScreen.profile: <AuthRole>[AuthRole.user, AuthRole.trainer],
  AppScreen.profileEdit: <AuthRole>[AuthRole.user, AuthRole.trainer],
  AppScreen.leaderboard: <AuthRole>[AuthRole.user],
  AppScreen.dailyCheckin: <AuthRole>[AuthRole.user],
  AppScreen.challengeDetails: <AuthRole>[AuthRole.user, AuthRole.trainer],
  AppScreen.challengeUserProgress: <AuthRole>[AuthRole.trainer],
  AppScreen.joinChallenge: <AuthRole>[AuthRole.user, AuthRole.trainer],
  AppScreen.bodyComposition: <AuthRole>[AuthRole.user, AuthRole.trainer],
  AppScreen.trainerDashboard: <AuthRole>[AuthRole.trainer],
  AppScreen.createChallenge: <AuthRole>[AuthRole.trainer],
};
