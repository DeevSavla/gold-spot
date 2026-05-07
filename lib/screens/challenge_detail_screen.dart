part of '../main.dart';

class ChallengeDetailScreen extends StatelessWidget {
  const ChallengeDetailScreen({
    super.key,
    required this.challenge,
    required this.fallbackChallengeId,
    required this.onLogProgress,
    required this.onBack,
    required this.showLogProgress,
  });

  final ChallengeSummary? challenge;
  final String fallbackChallengeId;
  final VoidCallback onLogProgress;
  final VoidCallback onBack;
  final bool showLogProgress;

  @override
  Widget build(BuildContext context) {
    final String title = challenge?.name ?? 'Challenge Details';
    final String category = challenge?.category ?? 'Training';
    final int duration = challenge?.duration ?? 0;
    final String description = challenge?.description.isNotEmpty == true
        ? challenge!.description
        : 'Review requirements, rewards, and schedule before joining.';
    final String participantText =
        challenge == null ? 'ID $fallbackChallengeId' : '${challenge!.participants.length}';

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 380;
        final double horizontalPadding = compact ? 16 : 24;

        return ListView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 32),
          children: <Widget>[
            _ChallengeDetailTopBar(onBack: onBack),
            SizedBox(height: compact ? 22 : 26),
            const _ChallengeDetailHeader(),
            SizedBox(height: compact ? 22 : 26),
            _ChallengeDetailHeroCard(
              title: title,
              category: category,
              description: description,
            ),
            SizedBox(height: compact ? 20 : 24),
            _ChallengeDetailStats(
              duration: duration,
              participants: participantText,
              category: category,
            ),
            SizedBox(height: compact ? 24 : 28),
            if (showLogProgress)
              _ChallengeDetailPrimaryButton(
                label: 'LOG TODAY\'S PROGRESS',
                onTap: onLogProgress,
              ),
          ],
        );
      },
    );
  }
}

class _ChallengeDetailTopBar extends StatelessWidget {
  const _ChallengeDetailTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Material(
          color: const Color(0xFF2A2A2A),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onBack,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),
        const Spacer(),
        const Text(
          'DETAILS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 40, height: 40),
      ],
    );
  }
}

class _ChallengeDetailHeader extends StatelessWidget {
  const _ChallengeDetailHeader();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'CHALLENGE DETAILS',
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
              'REVIEW THE PLAN',
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 22 : 25,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Know the goal before you jump in.',
              style: TextStyle(
                color: const Color(0xFFA4A4A4),
                fontSize: compact ? 15 : 17,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ChallengeDetailHeroCard extends StatelessWidget {
  const _ChallengeDetailHeroCard({
    required this.title,
    required this.category,
    required this.description,
  });

  final String title;
  final String category;
  final String description;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 360;
        final double padding = compact ? 18 : 24;

        return Container(
          constraints: BoxConstraints(minHeight: compact ? 190 : 210),
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
                  top: compact ? 22 : 12,
                  child: _RibbedChallengeOrb(
                    size: compact ? 132 : 172,
                    tint: _categoryTint(category),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: <Color>[
                          Colors.black.withValues(alpha: 0.18),
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
                      _DetailCategoryPill(label: category, compact: compact),
                      SizedBox(height: compact ? 14 : 18),
                      Text(
                        title,
                        maxLines: compact ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 21 : 24,
                          fontWeight: FontWeight.w900,
                          height: 1.06,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.78),
                        child: Text(
                          description,
                          maxLines: compact ? 2 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFFC2C2C2),
                            fontSize: compact ? 14 : 15,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Color _categoryTint(String category) {
    final int hash = category.toLowerCase().codeUnits.fold<int>(0, (int sum, int unit) => sum + unit);
    const List<Color> tints = <Color>[
      Color(0xFF6C3B31),
      Color(0xFF324D5B),
      Color(0xFF3C4F2D),
      Color(0xFF4C3F68),
    ];
    return tints[hash % tints.length];
  }
}

class _DetailCategoryPill extends StatelessWidget {
  const _DetailCategoryPill({
    required this.label,
    required this.compact,
  });

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final String text = label.trim().isEmpty ? 'Training' : label.trim();

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
        style: TextStyle(
          color: const Color(0xFFFF8F72),
          fontSize: compact ? 12 : 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.4,
        ),
      ),
    );
  }
}

class _ChallengeDetailStats extends StatelessWidget {
  const _ChallengeDetailStats({
    required this.duration,
    required this.participants,
    required this.category,
  });

  final int duration;
  final String participants;
  final String category;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;

        return Container(
          padding: EdgeInsets.all(compact ? 4 : 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: <Widget>[
              _DetailMetric(
                value: duration > 0 ? '$duration' : '--',
                label: 'DAYS',
                color: const Color(0xFFB7FF00),
                compact: compact,
              ),
              _DetailMetric(
                value: participants,
                label: 'ENROLLED',
                color: Colors.white,
                compact: compact,
              ),
              _DetailMetric(
                value: category.toUpperCase(),
                label: 'TYPE',
                color: const Color(0xFFFF8F72),
                compact: compact,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({
    required this.value,
    required this.label,
    required this.color,
    required this.compact,
  });

  final String value;
  final String label;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: compact ? 74 : 84,
        margin: EdgeInsets.all(compact ? 2 : 3),
        decoration: BoxDecoration(
          color: const Color(0xFF272727),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: compact ? 17 : 20,
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
      ),
    );
  }
}

class _ChallengeDetailPrimaryButton extends StatelessWidget {
  const _ChallengeDetailPrimaryButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFB7FF00),
          foregroundColor: const Color(0xFF252525),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _ChallengeDetailSecondaryButton extends StatelessWidget {
  const _ChallengeDetailSecondaryButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF2A2A2A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
