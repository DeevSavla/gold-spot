part of '../main.dart';

class HomeFlow extends StatefulWidget {
  const HomeFlow({super.key, this.startupError});

  final String? startupError;

  @override
  State<HomeFlow> createState() => _HomeFlowState();
}

class _HomeFlowState extends State<HomeFlow> {
  static const String _tokenStorageKey = 'kinetic_token_v1';
  final ApiService _apiService = ApiService();
  final HealthService _healthService = HealthService();
  AppScreen currentScreen = AppScreen.onboarding;
  AppScreen? pendingAfterLogin;
  AuthRole? pendingRole;
  AuthUser? user;
  bool isLoading = false;
  bool isChallengesLoading = false;
  String? activeChallengeId;
  String? activeChallengeUserId;
  List<ChallengeSummary> challenges = <ChallengeSummary>[];

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  AuthUser _userFromResponse(Map<String, dynamic> userData, {required AuthRole fallbackRole}) {
    final String roleValue = userData['role']?.toString() ?? fallbackRole.name;
    final Map<String, dynamic> onboarding =
        (userData['onboarding'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    return AuthUser(
      id: userData['id']?.toString() ?? '',
      name: userData['name']?.toString() ?? 'Kinetic User',
      email: userData['email']?.toString() ?? '',
      role: roleValue == 'trainer' ? AuthRole.trainer : AuthRole.user,
      height: (userData['height'] as num?)?.toDouble(),
      weight: (userData['weight'] as num?)?.toDouble(),
      birthdate: userData['birthdate']?.toString(),
      focus: onboarding['focus']?.toString() ?? 'endurance',
      weeklyDays: (onboarding['weeklyDays'] as num?)?.toInt() ?? 3,
      bio: onboarding['bio']?.toString() ?? '',
      profile_pic: userData['profile_pic']?.toString(),
      challengesParticipated: (userData['challengesParticipated'] as num?)?.toInt() ?? 0,
    );
  }

  ChallengeSummary _challengeFromResponse(Map<String, dynamic> data) {
    final List<dynamic> rawActiveParticipants =
        (data['activeParticipants'] as List?) ?? <dynamic>[];

    return ChallengeSummary(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      duration: (data['duration'] as num?)?.toInt() ?? 0,
      description: data['description']?.toString() ?? '',
      creatorId: data['creatorId']?.toString() ?? '',
      joinCode: data['joinCode']?.toString() ?? '',
      participants: ((data['participants'] as List?) ?? <dynamic>[])
          .map((dynamic value) => value.toString())
          .toList(),
      activeParticipants: rawActiveParticipants
          .whereType<Map>()
          .map((Map<dynamic, dynamic> value) {
            final Map<String, dynamic> participant = value.cast<String, dynamic>();
            return ChallengeParticipant(
              id: participant['id']?.toString() ?? '',
              name: participant['name']?.toString() ?? 'Unnamed participant',
            );
          })
          .where((ChallengeParticipant participant) => participant.id.isNotEmpty)
          .toList(),
    );
  }

  Future<void> _restoreSession() async {
    setState(() {
      isLoading = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(_tokenStorageKey);
      if (token == null || token.isEmpty) {
        return;
      }

      _apiService.setAuthToken(token);
      final Map<String, dynamic> response = await _apiService.getJson('/auth/me');
      final Map<String, dynamic> userData =
          (response['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
      final AuthUser restoredUser = _userFromResponse(
        userData,
        fallbackRole: AuthRole.user,
      );

      setState(() {
        user = restoredUser;
        currentScreen =
            restoredUser.role == AuthRole.trainer ? AppScreen.trainerDashboard : AppScreen.dashboard;
      });
      await _fetchChallenges();
    } catch (_) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenStorageKey);
      _apiService.setAuthToken(null);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _persistToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenStorageKey, token);
    _apiService.setAuthToken(token);
  }

  Future<void> _clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenStorageKey);
    _apiService.setAuthToken(null);
  }

  void setScreen(AppScreen screen) {
    setState(() {
      currentScreen = screen;
    });
    _guardRoute();
  }

  void viewChallenge(String id) {
    setState(() {
      activeChallengeId = id;
      currentScreen = AppScreen.challengeDetails;
    });
    _guardRoute();
  }

  void viewChallengeDetails(String id) {
    setState(() {
      activeChallengeId = id;
      currentScreen = AppScreen.challengeDetails;
    });
    _guardRoute();
  }

  void openDailyCheckin(String challengeId) {
    setState(() {
      activeChallengeId = challengeId;
      currentScreen = AppScreen.dailyCheckin;
    });
    _guardRoute();
  }

  void viewChallengeUserProgress(String challengeId, String userId) {
    setState(() {
      activeChallengeId = challengeId;
      activeChallengeUserId = userId;
      currentScreen = AppScreen.challengeUserProgress;
    });
    _guardRoute();
  }

  void _guardRoute() {
    if (isLoading) {
      return;
    }

    final List<AuthRole>? allowed = screenAllowedRoles[currentScreen];
    final bool isProtected = allowed != null;

    if (isProtected && user == null) {
      setState(() {
        pendingAfterLogin = currentScreen;
        pendingRole = allowed.first;
        currentScreen = AppScreen.login;
      });
      return;
    }

    if (isProtected && !allowed.contains(user!.role)) {
      setState(() {
        pendingAfterLogin = currentScreen;
        pendingRole = allowed.first;
        currentScreen = AppScreen.login;
      });
      return;
    }

    if (pendingAfterLogin != null && user != null) {
      final List<AuthRole>? destinationRoles = screenAllowedRoles[pendingAfterLogin!];
      if (destinationRoles != null && destinationRoles.contains(user!.role)) {
        setState(() {
          currentScreen = pendingAfterLogin!;
          pendingAfterLogin = null;
          pendingRole = null;
        });
      } else {
        setState(() {
          pendingAfterLogin = null;
          pendingRole = null;
          currentScreen =
              user!.role == AuthRole.trainer ? AppScreen.trainerDashboard : AppScreen.dashboard;
        });
      }
      return;
    }

    if (pendingAfterLogin == null &&
        user != null &&
        (currentScreen == AppScreen.login || currentScreen == AppScreen.signup)) {
      setState(() {
        currentScreen =
            user!.role == AuthRole.trainer ? AppScreen.trainerDashboard : AppScreen.dashboard;
      });
    }
  }

  Future<void> _login(LoginPayload payload) async {
    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> response = await _apiService.postJson(
        '/login',
        body: <String, dynamic>{
          'email': payload.email,
          'password': payload.password,
          'role': payload.role.name,
        },
      );

      final Map<String, dynamic> userData =
          (response['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
      final String token = response['token']?.toString() ?? '';
      if (token.isNotEmpty) {
        await _persistToken(token);
      }

      setState(() {
        user = _userFromResponse(
          userData,
          fallbackRole: payload.role,
        );
        isLoading = false;
      });
      await _fetchChallenges();
      _guardRoute();
    } catch (_) {
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  Future<void> _signup(SignupPayload payload) async {
    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> response = await _apiService.postMultipart(
        '/signup',
        fields: <String, String>{
          'name': payload.name,
          'email': payload.email,
          'password': payload.password,
          'role': payload.role.name,
          'height': payload.height.toString(),
          'weight': payload.weight.toString(),
          'birthdate': payload.birthdate,
          'focus': payload.focus,
          'weeklyDays': payload.weeklyDays.toString(),
          'bio': payload.bio,
        },
        file: payload.profileImage == null
            ? null
            : ApiMultipartFile(
                fieldName: 'profileImage',
                filename: payload.profileImage!.filename,
                bytes: payload.profileImage!.bytes,
              ),
      );

      final Map<String, dynamic> userData =
          (response['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
      final String token = response['token']?.toString() ?? '';
      if (token.isNotEmpty) {
        await _persistToken(token);
      }

      setState(() {
        user = _userFromResponse(
          userData,
          fallbackRole: payload.role,
        );
        isLoading = false;
      });
      await _fetchChallenges();
      _guardRoute();
    } catch (_) {
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  Future<void> _updateProfile(ProfileUpdatePayload payload) async {
    if (user == null) {
      return;
    }

    final Map<String, dynamic> response = await _apiService.patchJson(
      '/profile/${user!.id}',
      body: <String, dynamic>{
        'name': payload.name,
        'height': payload.height,
        'weight': payload.weight,
        'birthdate': payload.birthdate,
        'onboarding': <String, dynamic>{
          'focus': payload.focus,
          'weeklyDays': payload.weeklyDays,
          'bio': payload.bio,
        },
      },
    );

    final Map<String, dynamic> userData =
        (response['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    setState(() {
      user = _userFromResponse(userData, fallbackRole: user!.role);
    });
  }

  Future<void> _uploadProfilePicture(SignupImageFile image) async {
    if (user == null) {
      return;
    }

    final Map<String, dynamic> response = await _apiService.postMultipart(
      '/profile/${user!.id}/photo',
      file: ApiMultipartFile(
        fieldName: 'profileImage',
        filename: image.filename,
        bytes: image.bytes,
      ),
    );
    final Map<String, dynamic> userData =
        (response['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    setState(() {
      user = _userFromResponse(userData, fallbackRole: user!.role);
    });
  }

  Future<void> _deleteAccount() async {
    if (user == null) {
      return;
    }
    await _apiService.deleteJson('/profile/${user!.id}');
    await _clearToken();
    setState(() {
      user = null;
      pendingAfterLogin = null;
      pendingRole = null;
      activeChallengeId = null;
      activeChallengeUserId = null;
      challenges = <ChallengeSummary>[];
      currentScreen = AppScreen.onboarding;
    });
  }

  Future<void> _fetchChallenges() async {
    setState(() {
      isChallengesLoading = true;
    });

    try {
      final Map<String, dynamic> response = await _apiService.getJson('/challenges');
      final List<dynamic> rawChallenges = (response['challenges'] as List?) ?? <dynamic>[];
      setState(() {
        challenges = rawChallenges
            .whereType<Map>()
            .map((Map item) => _challengeFromResponse(item.cast<String, dynamic>()))
            .toList();
        isChallengesLoading = false;
      });
    } catch (_) {
      setState(() {
        isChallengesLoading = false;
      });
    }
  }

  Future<void> _joinChallenge(String joinCode) async {
    if (user == null) {
      throw StateError('No authenticated user found.');
    }

    final Map<String, dynamic> response = await _apiService.postJson(
      '/challenges/join',
      body: <String, dynamic>{
        'joinCode': joinCode,
        'userId': user!.id,
      },
    );

    final Map<String, dynamic> userData =
        (response['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    final Map<String, dynamic> challengeData =
        (response['challenge'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    setState(() {
      user = _userFromResponse(userData, fallbackRole: user!.role);
      final ChallengeSummary updatedChallenge = _challengeFromResponse(challengeData);
      final int index = challenges.indexWhere((ChallengeSummary c) => c.id == updatedChallenge.id);
      if (index >= 0) {
        challenges[index] = updatedChallenge;
      } else {
        challenges = <ChallengeSummary>[updatedChallenge, ...challenges];
      }
    });
  }

  Future<String> _createChallenge(CreateChallengePayload payload) async {
    if (user == null) {
      throw StateError('No authenticated user found.');
    }

    final Map<String, dynamic> response = await _apiService.postJson(
      '/challenges',
      body: <String, dynamic>{
        'name': payload.name,
        'category': payload.category,
        'duration': payload.duration,
        'description': payload.description,
        'creatorId': user!.id,
      },
    );

    final Map<String, dynamic> challenge =
        (response['challenge'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    final ChallengeSummary createdChallenge = _challengeFromResponse(challenge);
    setState(() {
      challenges = <ChallengeSummary>[
        createdChallenge,
        ...challenges.where((ChallengeSummary item) => item.id != createdChallenge.id),
      ];
    });
    return challenge['joinCode']?.toString() ?? '';
  }

  ChallengeSummary? get activeChallenge {
    for (final ChallengeSummary challenge in challenges) {
      if (challenge.id == activeChallengeId) {
        return challenge;
      }
    }
    return null;
  }

  Future<void> _logout() async {
    setState(() {
      currentScreen = AppScreen.logoutLoading;
      isLoading = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));
    await _clearToken();

    setState(() {
      user = null;
      pendingAfterLogin = null;
      pendingRole = null;
      activeChallengeId = null;
      activeChallengeUserId = null;
      isLoading = false;
      currentScreen = AppScreen.onboarding;
    });
  }

  Widget _buildScreen() {
    switch (currentScreen) {
      case AppScreen.onboarding:
        return MarketingScreen(
          title: 'Train with structure. Compete with purpose.',
          subtitle:
              'Bring your React Native home flow into Flutter with role-based journeys for athletes and trainers.',
          startupError: widget.startupError,
          primaryLabel: 'Get Started',
          secondaryLabel: 'Login',
          onPrimary: () => setScreen(AppScreen.signup),
          onSecondary: () {
            setState(() {
              pendingRole = AuthRole.trainer;
            });
            setScreen(AppScreen.login);
          },
        );
      case AppScreen.logoutLoading:
        return const LogoutLoadingScreen();
      case AppScreen.login:
        return LoginScreen(
          initialRole: pendingRole,
          onBack: () => setScreen(AppScreen.onboarding),
          onSignup: () => setScreen(AppScreen.signup),
          onSubmit: _login,
        );
      case AppScreen.signup:
        return SignupScreen(
          initialRole: pendingRole,
          onBack: () => setScreen(AppScreen.onboarding),
          onSubmit: _signup,
          onLogin: () => setScreen(AppScreen.login),
        );
      case AppScreen.dashboard:
        return UserDashboardScreen(
          user: user!,
          onViewChallenge: viewChallenge,
          onViewChallengeDetails: viewChallengeDetails,
          onOpenBodyComposition: () => setScreen(AppScreen.bodyComposition),
          healthService: _healthService,
          challenges: challenges,
          isChallengesLoading: isChallengesLoading,
          onRefreshChallenges: _fetchChallenges,
          onJoinChallenge: _joinChallenge,
        );
      case AppScreen.profile:
        return ProfileScreen(
          user: user!,
          onEdit: () => setScreen(AppScreen.profileEdit),
          onLogout: _logout,
          onDeleteAccount: _deleteAccount,
          onOpenHome: () => setScreen(
            user?.role == AuthRole.trainer ? AppScreen.trainerDashboard : AppScreen.dashboard,
          ),
        );
      case AppScreen.profileEdit:
        return ProfileEditScreen(
          user: user!,
          onBack: () => setScreen(AppScreen.profile),
          onSave: _updateProfile,
          onUploadProfilePicture: _uploadProfilePicture,
        );
      case AppScreen.challengeDetails:
        return ChallengeDetailScreen(
          challenge: activeChallenge,
          fallbackChallengeId: activeChallengeId ?? 'mobility-21',
          onLogProgress: () => openDailyCheckin(activeChallengeId ?? 'mobility-21'),
          onBack: () => setScreen(
            user?.role == AuthRole.trainer ? AppScreen.trainerDashboard : AppScreen.dashboard,
          ),
          showLogProgress: user?.role != AuthRole.trainer,
          showActiveParticipants: user?.role == AuthRole.trainer,
        );
      case AppScreen.bodyComposition:
        return BodyCompositionScreen(
          user: user!,
          onBack: () => setScreen(
            user?.role == AuthRole.trainer ? AppScreen.trainerDashboard : AppScreen.dashboard,
          ),
        );
      case AppScreen.leaderboard:
        return ChallengesScreen(
          user: user!,
          challenges: challenges,
          isChallengesLoading: isChallengesLoading,
          onRefreshChallenges: _fetchChallenges,
          onJoinChallenge: _joinChallenge,
          onViewChallengeDetails: viewChallengeDetails,
        );
      case AppScreen.createChallenge:
        return CreateChallengeScreen(
          onClose: () => setScreen(AppScreen.trainerDashboard),
          onSubmit: _createChallenge,
          onDone: () => setScreen(AppScreen.trainerDashboard),
        );
      case AppScreen.dailyCheckin:
        return DetailScreen(
          title: 'Daily Check-in',
          subtitle: 'Log today\'s effort, add notes, and mark your streak progress.',
          actionLabel: 'Return to Challenge',
          onAction: () => viewChallengeDetails(activeChallengeId ?? 'mobility-21'),
        );
      case AppScreen.trainerDashboard:
        return TrainerDashboardScreen(
          user: user!,
          apiBaseUrl: _safeApiBaseUrl,
          apiService: _apiService,
          challenges: challenges,
          isChallengesLoading: isChallengesLoading,
          onRefreshChallenges: _fetchChallenges,
          onCreateChallenge: () => setScreen(AppScreen.createChallenge),
          onViewChallenge: viewChallenge,
          onViewChallengeDetails: viewChallengeDetails,
        );
      case AppScreen.challengeUserProgress:
        return DetailScreen(
          title: 'Athlete Progress',
          subtitle:
              'Viewing ${activeChallengeUserId ?? 'user-101'} inside ${activeChallengeId ?? 'challenge'}.',
          actionLabel: 'Back to Challenge',
          onAction: () => viewChallengeDetails(activeChallengeId ?? 'mobility-21'),
        );
      case AppScreen.joinChallenge:
        return DetailScreen(
          title: 'Join Challenge',
          subtitle: 'Use a code or accept an invite to enter a team challenge.',
          actionLabel: 'Go to Dashboard',
          onAction: () => setScreen(
            user?.role == AuthRole.trainer ? AppScreen.trainerDashboard : AppScreen.dashboard,
          ),
        );
    }
  }

  String get _safeApiBaseUrl {
    return _apiService.currentBaseUrl;
  }

  @override
  Widget build(BuildContext context) {
    final bool showBottomNavigation = user != null && !hideBottomNav.contains(currentScreen);

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: _buildScreen(),
        ),
      ),
      bottomNavigationBar: showBottomNavigation
          ? AppBottomNav(
              currentScreen: currentScreen,
              role: user!.role,
              onSelect: setScreen,
            )
          : null,
    );
  }
}

