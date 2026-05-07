part of '../main.dart';

class AthleteDashboardScreen extends StatelessWidget {
  const AthleteDashboardScreen({
    super.key,
    required this.user,
    required this.apiBaseUrl,
    required this.apiService,
    required this.challenges,
    required this.isChallengesLoading,
    required this.onRefreshChallenges,
    required this.onJoinChallenge,
    required this.onViewChallenge,
    required this.onLeaderboard,
  });

  final AuthUser user;
  final String apiBaseUrl;
  final ApiService apiService;
  final List<ChallengeSummary> challenges;
  final bool isChallengesLoading;
  final Future<void> Function() onRefreshChallenges;
  final Future<void> Function(String joinCode) onJoinChallenge;
  final VoidCallback onViewChallenge;
  final VoidCallback onLeaderboard;

  @override
  Widget build(BuildContext context) {
    return _DashboardShell(
      title: 'Welcome, ${user.name}',
      subtitle: 'Your athlete home page is now the default Flutter landing experience.',
      children: <Widget>[
        _InfoCard(
          title: 'Active challenge',
          subtitle: 'Mobility Reset · Day 8 of 21',
          trailing: _PrimaryButton.small(label: 'View', onTap: onViewChallenge),
        ),
        _InfoCard(
          title: 'Current streak',
          subtitle: '6 days logged with an average session score of 92%',
          accentColor: AppPalette.success,
        ),

        BackendHealthCard(apiService: apiService),
        Row(
          children: <Widget>[
            Expanded(
              child: _QuickActionCard(
                title: 'Leaderboard',
                icon: Icons.emoji_events_outlined,
                onTap: onLeaderboard,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _QuickActionCard(
                title: 'Join Challenge',
                icon: Icons.group_add_outlined,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TrainerDashboardScreen extends StatelessWidget {
  const TrainerDashboardScreen({
    super.key,
    required this.user,
    required this.apiBaseUrl,
    required this.apiService,
    required this.challenges,
    required this.isChallengesLoading,
    required this.onRefreshChallenges,
    required this.onCreateChallenge,
    required this.onViewChallenge,
    required this.onViewChallengeDetails,
  });

  final AuthUser user;
  final String apiBaseUrl;
  final ApiService apiService;
  final List<ChallengeSummary> challenges;
  final bool isChallengesLoading;
  final Future<void> Function() onRefreshChallenges;
  final VoidCallback onCreateChallenge;
  final ValueChanged<String> onViewChallenge;
  final ValueChanged<String> onViewChallengeDetails;

  @override
  Widget build(BuildContext context) {
    final List<ChallengeSummary> createdChallenges = challenges
        .where((ChallengeSummary challenge) => challenge.creatorId == user.id)
        .toList();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 380;
        final double horizontalPadding = compact ? 16 : 24;

        return RefreshIndicator(
          color: const Color(0xFFB7FF00),
          backgroundColor: const Color(0xFF1E1E1E),
          onRefresh: onRefreshChallenges,
          child: ListView(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 32),
            children: <Widget>[
              _DashboardHeroHeader(name: user.name),
              SizedBox(height: compact ? 22 : 26),
              _TrainerCreateChallengeCard(onTap: onCreateChallenge),
              SizedBox(height: compact ? 20 : 24),
              const _DashboardSectionTitle(title: 'YOUR CHALLENGES'),
              const SizedBox(height: 12),
              if (isChallengesLoading)
                const _DashboardLoadingCard()
              else if (createdChallenges.isEmpty)
                _TrainerEmptyChallengeCard(onCreateChallenge: onCreateChallenge)
              else
                ...createdChallenges.map((ChallengeSummary challenge) {
                  return _DashboardChallengeCard(
                    challenge: challenge,
                    onOpen: () => onViewChallenge(challenge.id),
                    onDetails: () => onViewChallengeDetails(challenge.id),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({
    super.key,
    required this.user,
    required this.challenges,
    required this.isChallengesLoading,
    required this.onRefreshChallenges,
    required this.onJoinChallenge,
    required this.onViewChallenge,
    required this.onViewChallengeDetails,
    required this.onOpenBodyComposition,
    required this.healthService,
  });

  final AuthUser user;
  final List<ChallengeSummary> challenges;
  final bool isChallengesLoading;
  final Future<void> Function() onRefreshChallenges;
  final Future<void> Function(String joinCode) onJoinChallenge;
  final ValueChanged<String> onViewChallenge;
  final ValueChanged<String> onViewChallengeDetails;
  final VoidCallback onOpenBodyComposition;
  final HealthService healthService;

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final List<ChallengeSummary> joinedChallenges = widget.challenges
        .where((ChallengeSummary challenge) => challenge.participants.contains(widget.user.id))
        .toList();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 380;
        final double horizontalPadding = compact ? 16 : 24;

        return RefreshIndicator(
          color: const Color(0xFFB7FF00),
          backgroundColor: const Color(0xFF1E1E1E),
          onRefresh: widget.onRefreshChallenges,
          child: ListView(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 32),
            children: <Widget>[
              _DashboardHeroHeader(name: widget.user.name),
              SizedBox(height: compact ? 22 : 26),
              _DashboardSummaryCard(
                activeChallenges: joinedChallenges.length,
                weeklyDays: widget.user.weeklyDays,
                onOpenBodyComposition: widget.onOpenBodyComposition,
              ),
              SizedBox(height: compact ? 20 : 24),
              const _DashboardSectionTitle(title: 'ACTIVE CHALLENGES'),
              const SizedBox(height: 12),
              if (widget.isChallengesLoading)
                const _DashboardLoadingCard()
              else if (joinedChallenges.isEmpty)
                _DashboardEmptyChallengeCard(onRefresh: widget.onRefreshChallenges)
              else
                ...joinedChallenges.map((ChallengeSummary challenge) {
                  return _DashboardChallengeCard(
                    challenge: challenge,
                    onOpen: () => widget.onViewChallenge(challenge.id),
                    onDetails: () => widget.onViewChallengeDetails(challenge.id),
                  );
                }),
              SizedBox(height: compact ? 20 : 24),
              HealthStepsCard(healthService: widget.healthService),
              SizedBox(height: compact ? 20 : 24),
              _DashboardBodyCompositionCard(onTap: widget.onOpenBodyComposition),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardHeroHeader extends StatelessWidget {
  const _DashboardHeroHeader({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'WELCOME BACK',
              style: TextStyle(
                color: const Color(0xFFB7FF00),
                fontSize: compact ? 19 : 22,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            SizedBox(height: compact ? 30 : 36),
            Text(
              name.toUpperCase(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 24 : 28,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DashboardSummaryCard extends StatelessWidget {
  const _DashboardSummaryCard({
    required this.activeChallenges,
    required this.weeklyDays,
    required this.onOpenBodyComposition,
  });

  final int activeChallenges;
  final int weeklyDays;
  final VoidCallback onOpenBodyComposition;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 360;
        final double padding = compact ? 18 : 24;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onOpenBodyComposition,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: compact ? 218 : 236),
              child: Ink(
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x66000000),
                      blurRadius: 20,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: compact ? -42 : -34,
                        top: compact ? 24 : 12,
                        child: _RibbedChallengeOrb(
                          size: compact ? 132 : 174,
                          tint: const Color(0xFF324D5B),
                        ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: <Color>[
                                Colors.black.withValues(alpha: 0.16),
                                const Color(0xFF1F1F1F),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(padding),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const _DashboardPill(label: 'Today'),
                            SizedBox(height: compact ? 18 : 22),
                            Text(
                              'KEEP YOUR MOMENTUM',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: compact ? 21 : 24,
                                fontWeight: FontWeight.w900,
                                height: 1.08,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '$activeChallenges active challenge${activeChallenges == 1 ? '' : 's'} - $weeklyDays training days/week',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFFC2C2C2),
                                fontSize: compact ? 14 : 15,
                                fontWeight: FontWeight.w500,
                                height: 1.35,
                              ),
                            ),
                            SizedBox(height: compact ? 24 : 30),
                            Row(
                              children: <Widget>[
                                _DashboardMetric(
                                  value: '$activeChallenges',
                                  label: 'ACTIVE',
                                  compact: compact,
                                ),
                                const SizedBox(width: 10),
                                _DashboardMetric(
                                  value: '$weeklyDays',
                                  label: 'DAYS/WK',
                                  compact: compact,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DashboardPill extends StatelessWidget {
  const _DashboardPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF60382F),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFFF8F72),
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.4,
        ),
      ),
    );
  }
}

class _DashboardMetric extends StatelessWidget {
  const _DashboardMetric({
    required this.value,
    required this.label,
    required this.compact,
  });

  final String value;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 92 : 108,
      padding: EdgeInsets.symmetric(vertical: compact ? 12 : 14),
      decoration: BoxDecoration(
        color: const Color(0xFF272727),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFFB7FF00),
              fontSize: compact ? 19 : 22,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFFA4A4A4),
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSectionTitle extends StatelessWidget {
  const _DashboardSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return const Text(
      'ACTIVE CHALLENGES',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _DashboardChallengeCard extends StatelessWidget {
  const _DashboardChallengeCard({
    required this.challenge,
    required this.onOpen,
    required this.onDetails,
  });

  final ChallengeSummary challenge;
  final VoidCallback onOpen;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final String description = challenge.description.trim().isEmpty
        ? 'No description yet.'
        : challenge.description.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onDetails,
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.bolt_rounded, color: Color(0xFFB7FF00)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        challenge.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${challenge.duration} days - $description',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFA4A4A4),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _DashboardOpenButton(onTap: onOpen),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardOpenButton extends StatelessWidget {
  const _DashboardOpenButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      height: 42,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFB7FF00),
          foregroundColor: const Color(0xFF252525),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onTap,
        child: const Text(
          'OPEN',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.8),
        ),
      ),
    );
  }
}

class _DashboardLoadingCard extends StatelessWidget {
  const _DashboardLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFFB7FF00)),
      ),
    );
  }
}

class _DashboardEmptyChallengeCard extends StatelessWidget {
  const _DashboardEmptyChallengeCard({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => onRefresh(),
        child: Ink(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Row(
            children: <Widget>[
              Icon(Icons.group_add_outlined, color: Color(0xFFB7FF00)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No active challenges yet. Pull to refresh or open Challenges to join one.',
                  style: TextStyle(color: Color(0xFFA4A4A4), height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardBodyCompositionCard extends StatelessWidget {
  const _DashboardBodyCompositionCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Row(
            children: <Widget>[
              _DashboardActionIcon(icon: Icons.monitor_weight_outlined),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'BODY COMPOSITION',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Connect your scale and capture body metrics.',
                      style: TextStyle(
                        color: Color(0xFFA4A4A4),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.chevron_right_rounded, color: Color(0xFFB7FF00)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrainerCreateChallengeCard extends StatelessWidget {
  const _TrainerCreateChallengeCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Row(
            children: <Widget>[
              _DashboardActionIcon(icon: Icons.add_circle_outline_rounded),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'CREATE CHALLENGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Publish a new plan and share its join code.',
                      style: TextStyle(
                        color: Color(0xFFA4A4A4),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.chevron_right_rounded, color: Color(0xFFB7FF00)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrainerEmptyChallengeCard extends StatelessWidget {
  const _TrainerEmptyChallengeCard({required this.onCreateChallenge});

  final VoidCallback onCreateChallenge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onCreateChallenge,
        child: Ink(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Row(
            children: <Widget>[
              Icon(Icons.assignment_outlined, color: Color(0xFFB7FF00)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No challenges created yet. Tap here to launch your first one.',
                  style: TextStyle(color: Color(0xFFA4A4A4), height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardActionIcon extends StatelessWidget {
  const _DashboardActionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(icon, color: Color(0xFFB7FF00)),
      ),
    );
  }
}

class HealthStepsCard extends StatefulWidget {
  const HealthStepsCard({
    super.key,
    required this.healthService,
  });

  final HealthService healthService;

  @override
  State<HealthStepsCard> createState() => _HealthStepsCardState();
}

class _HealthStepsCardState extends State<HealthStepsCard> {
  int? _steps;
  List<HourlyStepCount> _hourlySteps = <HourlyStepCount>[];
  String _message = 'Request permission to load today\'s real step count.';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSteps();
  }

  Future<void> _loadSteps() async {
    setState(() {
      _isLoading = true;
      _message = 'Reading today\'s steps...';
    });

    try {
      final int? steps = await widget.healthService.getTodaySteps();
      final List<HourlyStepCount>? hourlySteps = steps == null
          ? null
          : await widget.healthService.getTodayHourlySteps();
      if (!mounted) {
        return;
      }

      setState(() {
        _steps = steps;
        _hourlySteps = (hourlySteps ?? <HourlyStepCount>[])
            .where((HourlyStepCount item) => item.steps > 0)
            .toList();
        _message = steps == null
            ? 'Health permission was not granted or no step data is available.'
            : '$steps steps since midnight';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _steps = null;
        _hourlySteps = <HourlyStepCount>[];
        _message = 'Unable to read steps: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 360;

        return Container(
          padding: EdgeInsets.all(compact ? 18 : 22),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _DashboardActionIcon(icon: Icons.directions_walk_rounded),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'TODAY\'S STEPS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFFA4A4A4), height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _DashboardRefreshButton(
                    label: _isLoading ? '...' : 'REFRESH',
                    onTap: _isLoading ? () {} : _loadSteps,
                    compact: compact,
                  ),
                ],
              ),
              if (_steps != null) ...<Widget>[
                const SizedBox(height: 20),
                Text(
                  _steps.toString(),
                  style: const TextStyle(
                    color: Color(0xFFB7FF00),
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'STEPS',
                  style: TextStyle(
                    color: Color(0xFFA4A4A4),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.6,
                  ),
                ),
              ],
              if (_hourlySteps.isNotEmpty) ...<Widget>[
                const SizedBox(height: 18),
                _HourlyStepsChart(hourlySteps: _hourlySteps),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DashboardRefreshButton extends StatelessWidget {
  const _DashboardRefreshButton({
    required this.label,
    required this.onTap,
    required this.compact,
  });

  final String label;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? 78 : 92,
      height: 42,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFB7FF00),
          foregroundColor: const Color(0xFF252525),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onTap,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: compact ? 10 : 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _HourlyStepsChart extends StatelessWidget {
  const _HourlyStepsChart({
    required this.hourlySteps,
  });

  final List<HourlyStepCount> hourlySteps;

  @override
  Widget build(BuildContext context) {
    final int maxSteps = hourlySteps.fold<int>(
      0,
      (int max, HourlyStepCount item) => item.steps > max ? item.steps : max,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Hourly breakdown',
          style: TextStyle(
            color: AppPalette.text,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 116,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: hourlySteps.map((HourlyStepCount item) {
                final double ratio = maxSteps == 0 ? 0 : item.steps / maxSteps;
                final double barHeight = 16 + (ratio * 62);
                return Tooltip(
                  message: '${_formatHour(item.start)} - ${_formatHour(item.end)}: ${item.steps} steps',
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 42,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            item.steps.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppPalette.mutedText,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            width: 18,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: AppPalette.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatHour(item.start),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppPalette.mutedText,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  static String _formatHour(DateTime value) {
    final int hour = value.hour;
    if (hour == 0) {
      return '12 AM';
    }
    if (hour < 12) {
      return '$hour AM';
    }
    if (hour == 12) {
      return '12 PM';
    }
    return '${hour - 12} PM';
  }

}

class BackendHealthCard extends StatefulWidget {
  const BackendHealthCard({
    super.key,
    required this.apiService,
  });

  final ApiService apiService;

  @override
  State<BackendHealthCard> createState() => _BackendHealthCardState();
}

class _BackendHealthCardState extends State<BackendHealthCard> {
  String _message = 'Tap to check backend connectivity.';
  bool _isChecking = false;
  bool _isSuccess = false;

  Future<void> _checkBackend() async {
    setState(() {
      _isChecking = true;
      _message = 'Checking ${AppEnv.apiBaseUrl}/health ...';
    });

    try {
      final Map<String, dynamic> response = await widget.apiService.getJson('/health');
      setState(() {
        _isSuccess = true;
        _message = response['message']?.toString() ??
            response['status']?.toString() ??
            'Backend responded successfully.';
      });
    } catch (error) {
      setState(() {
        _isSuccess = false;
        _message = 'Health check failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: 'Backend health',
      subtitle: _message,
      accentColor: _isSuccess ? AppPalette.success : AppPalette.border,
      trailing: _PrimaryButton.small(
        label: _isChecking ? 'Checking...' : 'Test /health',
        onTap: _isChecking ? () {} : _checkBackend,
      ),
    );
  }
}
