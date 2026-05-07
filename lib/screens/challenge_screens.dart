part of '../main.dart';

class ChallengeViewScreen extends StatelessWidget {
  const ChallengeViewScreen({
    super.key,
    required this.challengeId,
    required this.trainerMode,
    required this.onViewUserProgress,
    required this.onOpenDetails,
  });

  final String challengeId;
  final bool trainerMode;
  final VoidCallback onViewUserProgress;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Challenge View', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          const SizedBox(height: 16),
          if (trainerMode) ...<Widget>[
            _PrimaryButton(
              label: 'View Athlete Progress',
              onTap: onViewUserProgress,
            ),
            const SizedBox(height: 12),
          ],
          _SecondaryButton(label: 'Challenge Details', onTap: onOpenDetails),
        ],
      ),
    );
  }
}

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({
    super.key,
    required this.user,
    required this.challenges,
    required this.isChallengesLoading,
    required this.onRefreshChallenges,
    required this.onJoinChallenge,
    required this.onViewChallengeDetails,
  });

  final AuthUser user;
  final List<ChallengeSummary> challenges;
  final bool isChallengesLoading;
  final Future<void> Function() onRefreshChallenges;
  final Future<void> Function(String joinCode) onJoinChallenge;
  final ValueChanged<String> onViewChallengeDetails;

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  bool _joining = false;

  Future<void> _promptJoin(ChallengeSummary challenge) async {
    final TextEditingController controller = TextEditingController();
    try {
      final String? code = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppPalette.surface,
            title: Text(
              'Join ${challenge.name}',
              style: const TextStyle(color: AppPalette.text),
            ),
            content: TextField(
              controller: controller,
              style: const TextStyle(color: AppPalette.text),
              decoration: const InputDecoration(
                hintText: 'Enter join code',
                hintStyle: TextStyle(color: AppPalette.mutedText),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(controller.text.trim()),
                child: const Text('Join'),
              ),
            ],
          );
        },
      );

      if (code == null || code.isEmpty) {
        return;
      }

      setState(() {
        _joining = true;
      });
      await widget.onJoinChallenge(code);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Challenge joined successfully.')),
        );
      }
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } finally {
      controller.dispose();
      if (mounted) {
        setState(() {
          _joining = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ChallengeSummary> availableChallenges = widget.challenges
        .where((ChallengeSummary challenge) => !challenge.participants.contains(widget.user.id))
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
              const _ChallengesHeroHeader(),
              SizedBox(height: compact ? 22 : 26),
              if (widget.isChallengesLoading)
                const _ChallengeLoadingCard()
              else if (availableChallenges.isEmpty)
                const _ChallengeEmptyCard()
              else
                ...availableChallenges.map((ChallengeSummary challenge) {
                  return _DiscoverChallengeCard(
                    challenge: challenge,
                    isJoining: _joining,
                    onViewDetails: () => widget.onViewChallengeDetails(challenge.id),
                    onJoin: _joining ? () {} : () => _promptJoin(challenge),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _ChallengesHeroHeader extends StatelessWidget {
  const _ChallengesHeroHeader();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'DISCOVER CHALLENGES',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFFB7FF00),
                fontSize: compact ? 19 : 22,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DiscoverChallengeCard extends StatelessWidget {
  const _DiscoverChallengeCard({
    required this.challenge,
    required this.isJoining,
    required this.onViewDetails,
    required this.onJoin,
  });

  final ChallengeSummary challenge;
  final bool isJoining;
  final VoidCallback onViewDetails;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final String description = challenge.description.trim().isEmpty
        ? 'A focused community challenge built to keep you moving.'
        : challenge.description.trim();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final bool compact = width < 360;
        final bool tiny = width < 320;
        final double padding = compact ? 18 : 24;
        final double orbSize = compact ? 132 : 172;
        final double descriptionWidth = width * (compact ? 0.82 : 0.72);
        final double buttonWidth = tiny ? 104 : (compact ? 116 : 128);

        return Padding(
          padding: EdgeInsets.only(bottom: compact ? 18 : 24),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onViewDetails,
              borderRadius: BorderRadius.circular(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: compact ? 260 : 268),
                child: Ink(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0x14141414)),
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
                          top: compact ? 20 : 10,
                          child: _RibbedChallengeOrb(
                            size: orbSize,
                            tint: _categoryTint(challenge.category),
                          ),
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: <Color>[
                                  Colors.black.withValues(alpha: 0.20),
                                  const Color(0xFF1F1F1F),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(padding, padding + 4, padding, padding),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _CategoryPill(
                                label: challenge.category,
                                compact: compact,
                              ),
                              SizedBox(height: compact ? 18 : 24),
                              Text(
                                challenge.name,
                                maxLines: compact ? 2 : 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: compact ? 20 : 23,
                                  fontWeight: FontWeight.w900,
                                  height: 1.08,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: descriptionWidth),
                                child: Text(
                                  description,
                                  maxLines: compact ? 3 : 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: const Color(0xFFC2C2C2),
                                    fontSize: compact ? 14 : 15,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                              SizedBox(height: compact ? 28 : 36),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'DURATION',
                                          style: TextStyle(
                                            color: const Color(0xFF8E8E8E),
                                            fontSize: compact ? 11 : 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        SizedBox(height: compact ? 12 : 14),
                                        Text(
                                          '${challenge.participants.length} ENROLLED',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFFB8B8B8),
                                            fontSize: compact ? 12 : 13,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        '${challenge.duration} DAYS',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: const Color(0xFFB7FF00),
                                          fontSize: compact ? 13 : 14,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(height: compact ? 12 : 14),
                                      _NeonJoinButton(
                                        label: isJoining ? 'JOINING...' : 'JOIN NOW',
                                        onTap: onJoin,
                                        width: buttonWidth,
                                        height: compact ? 46 : 50,
                                        fontSize: compact ? 12 : 13,
                                      ),
                                    ],
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
          ),
        );
      },
    );
  }

  static Color _categoryTint(String category) {
    final int hash = category.toLowerCase().codeUnits.fold<int>(0, (int sum, int unit) => sum + unit);
    final List<Color> tints = <Color>[
      Color(0xFF6C3B31),
      Color(0xFF324D5B),
      Color(0xFF3C4F2D),
      Color(0xFF4C3F68),
    ];
    return tints[hash % tints.length];
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    this.compact = false,
  });

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final String text = label.trim().isEmpty ? 'Challenge' : label.trim();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 14 : 18,
        vertical: compact ? 8 : 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF60382F),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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

class _NeonJoinButton extends StatelessWidget {
  const _NeonJoinButton({
    required this.label,
    required this.onTap,
    this.width = 128,
    this.height = 50,
    this.fontSize = 13,
  });

  final String label;
  final VoidCallback onTap;
  final double width;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFB7FF00),
          foregroundColor: const Color(0xFF252525),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _RibbedChallengeOrb extends StatelessWidget {
  const _RibbedChallengeOrb({
    required this.size,
    required this.tint,
  });

  final double size;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.42,
      child: Transform.rotate(
        angle: -0.52,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.35, -0.35),
              radius: 0.82,
              colors: <Color>[
                tint.withValues(alpha: 0.55),
                const Color(0xFF2C2C2C),
                const Color(0xFF080808),
              ],
            ),
          ),
          child: ClipOval(
            child: CustomPaint(
              painter: _OrbRibPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbRibPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint ribPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2;

    for (double x = -size.width * 0.35; x < size.width * 1.18; x += 12) {
      final Rect rect = Rect.fromLTWH(x, -size.height * 0.12, size.width * 0.42, size.height * 1.24);
      canvas.drawArc(rect, -1.42, 2.84, false, shadowPaint);
      canvas.drawArc(rect, -1.42, 2.84, false, ribPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChallengeLoadingCard extends StatelessWidget {
  const _ChallengeLoadingCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;

        return Container(
          height: compact ? 170 : 210,
          padding: EdgeInsets.all(compact ? 18 : 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFFB7FF00)),
          ),
        );
      },
    );
  }
}

class _ChallengeEmptyCard extends StatelessWidget {
  const _ChallengeEmptyCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;

        return Container(
          padding: EdgeInsets.all(compact ? 22 : 28),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'NO CHALLENGES AVAILABLE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 19 : 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You have already joined all current challenges or none are live yet.',
                style: TextStyle(
                  color: const Color(0xFFA4A4A4),
                  fontSize: compact ? 15 : 17,
                  height: 1.45,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppPalette.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 28),
              _PrimaryButton(label: actionLabel, onTap: onAction),
            ],
          ),
        ),
      ),
    );
  }
}
