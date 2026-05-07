part of '../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onLogout,
    required this.onDeleteAccount,
    required this.onOpenHome,
  });

  final AuthUser user;
  final VoidCallback onEdit;
  final Future<void> Function() onLogout;
  final Future<void> Function() onDeleteAccount;
  final VoidCallback onOpenHome;

  String _formatName(String value) {
    return value
        .split(' ')
        .where((String word) => word.trim().isNotEmpty)
        .map((String word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = user.profile_pic ?? 'https://via.placeholder.com/200x200.png?text=Profile';
    final String roleLabel = user.role == AuthRole.trainer ? 'Trainer' : 'Athlete';

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 380;
        final double horizontalPadding = compact ? 16 : 24;

        return ListView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 32),
          children: <Widget>[
            const _ProfileHeroHeader(),
            SizedBox(height: compact ? 22 : 26),
            _ProfileHeroCard(
              imageUrl: imageUrl,
              name: _formatName(user.name),
              roleLabel: roleLabel,
              weeklyDays: user.weeklyDays,
              onEdit: onEdit,
              onOpenHome: onOpenHome,
            ),
            SizedBox(height: compact ? 16 : 20),
            _ProfileStatsPanel(
              challenges: user.challengesParticipated,
              weeklyDays: user.weeklyDays,
            ),
            SizedBox(height: compact ? 20 : 24),
            const _ProfileSectionTitle(title: 'ACHIEVEMENTS', action: 'VIEW ALL'),
            const SizedBox(height: 12),
            const _ProfileAchievementsPanel(),
            SizedBox(height: compact ? 20 : 24),
            _ProfileAccountPanel(
              onEdit: onEdit,
              onLogout: onLogout,
              onDeleteAccount: onDeleteAccount,
            ),
          ],
        );
      },
    );
  }
}

class _ProfileHeroHeader extends StatelessWidget {
  const _ProfileHeroHeader();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'PROFILE',
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

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({
    required this.imageUrl,
    required this.name,
    required this.roleLabel,
    required this.weeklyDays,
    required this.onEdit,
    required this.onOpenHome,
  });

  final String imageUrl;
  final String name;
  final String roleLabel;
  final int weeklyDays;
  final VoidCallback onEdit;
  final VoidCallback onOpenHome;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 360;
        final bool tiny = constraints.maxWidth < 320;
        final double padding = compact ? 18 : 24;
        final double avatarSize = compact ? 66 : 78;
        final double orbSize = compact ? 132 : 178;

        return Container(
          constraints: BoxConstraints(minHeight: compact ? 224 : 244),
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
                  right: compact ? -42 : -38,
                  top: compact ? 24 : 14,
                  child: _RibbedChallengeOrb(
                    size: orbSize,
                    tint: const Color(0xFF344D39),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: <Color>[
                          Colors.black.withValues(alpha: 0.12),
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
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: onOpenHome,
                            child: Container(
                              width: avatarSize,
                              height: avatarSize,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFB7FF00), width: 2),
                              ),
                              child: _ProfileAvatar(imageUrl: imageUrl, radius: (avatarSize - 6) / 2),
                            ),
                          ),
                          const Spacer(),
                          _ProfileIconButton(icon: Icons.edit_outlined, onTap: onEdit, compact: compact),
                          SizedBox(width: compact ? 8 : 10),
                          _ProfileIconButton(icon: Icons.home_outlined, onTap: onOpenHome, compact: compact),
                        ],
                      ),
                      SizedBox(height: compact ? 24 : 34),
                      _ProfilePill(label: roleLabel, compact: compact),
                      SizedBox(height: compact ? 14 : 16),
                      Text(
                        name,
                        maxLines: tiny ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 22 : 25,
                          fontWeight: FontWeight.w900,
                          height: 1.08,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$weeklyDays DAYS/WK',
                        style: TextStyle(
                          color: const Color(0xFFA4A4A4),
                          fontSize: compact ? 12 : 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
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
}

class _ProfileIconButton extends StatelessWidget {
  const _ProfileIconButton({
    required this.icon,
    required this.onTap,
    this.compact = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF2A2A2A),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: compact ? 34 : 38,
          height: compact ? 34 : 38,
          child: Icon(icon, color: Colors.white, size: compact ? 17 : 19),
        ),
      ),
    );
  }
}

class _ProfilePill extends StatelessWidget {
  const _ProfilePill({
    required this.label,
    this.compact = false,
  });

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
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
        label,
        style: TextStyle(
          color: Color(0xFFFF8F72),
          fontSize: compact ? 12 : 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.4,
        ),
      ),
    );
  }
}

class _ProfileStatsPanel extends StatelessWidget {
  const _ProfileStatsPanel({
    required this.challenges,
    required this.weeklyDays,
  });

  final int challenges;
  final int weeklyDays;

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
              _ProfileMetric(
                value: '$challenges',
                label: 'CHALLENGES',
                color: const Color(0xFFB7FF00),
                compact: compact,
              ),
              _ProfileMetric(
                value: '0',
                label: 'COMPLETED',
                color: Colors.white,
                compact: compact,
              ),
              _ProfileMetric(
                value: '$weeklyDays',
                label: 'DAYS/WK',
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

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({
    required this.value,
    required this.label,
    required this.color,
    this.compact = false,
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
              style: TextStyle(
                color: color,
                fontSize: compact ? 19 : 22,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle({
    required this.title,
    required this.action,
  });

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 16 : 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              action,
              style: TextStyle(
                color: const Color(0xFFB7FF00),
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileAchievementsPanel extends StatelessWidget {
  const _ProfileAchievementsPanel();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;
        final double badgeSize = compact ? 56 : 64;

        return Container(
          padding: EdgeInsets.all(compact ? 12 : 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Wrap(
            spacing: compact ? 10 : 12,
            runSpacing: compact ? 10 : 12,
            children: <Widget>[
              for (final IconData icon in <IconData>[
                Icons.bolt,
                Icons.workspace_premium,
                Icons.military_tech,
                Icons.verified,
                Icons.local_fire_department,
                Icons.star,
              ])
                _ProfileAchievementBadge(icon: icon, size: badgeSize),
              _ProfileAchievementBadge(icon: Icons.lock, locked: true, size: badgeSize),
              _ProfileAchievementBadge(icon: Icons.lock, locked: true, size: badgeSize),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileAchievementBadge extends StatelessWidget {
  const _ProfileAchievementBadge({
    required this.icon,
    this.locked = false,
    this.size = 64,
  });

  final IconData icon;
  final bool locked;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: locked ? const Color(0xFF171717) : const Color(0xFF272727),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: locked ? const Color(0x12FFFFFF) : const Color(0x10B7FF00),
        ),
      ),
      child: Icon(
        locked ? Icons.lock_outline : icon,
        color: locked ? const Color(0xFF777777) : const Color(0xFFB7FF00),
        size: size * 0.40,
      ),
    );
  }
}

class _ProfileAccountPanel extends StatelessWidget {
  const _ProfileAccountPanel({
    required this.onEdit,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  final VoidCallback onEdit;
  final Future<void> Function() onLogout;
  final Future<void> Function() onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 340;

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
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'ACCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 16 : 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  _ProfileMiniButton(label: 'EDIT', onTap: onEdit, compact: compact),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Manage your profile, session, and account access.',
                style: TextStyle(
                  color: const Color(0xFFA4A4A4),
                  fontSize: compact ? 13 : 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              _ProfileActionButton(
                label: 'LOG OUT',
                foregroundColor: const Color(0xFF252525),
                backgroundColor: const Color(0xFFB7FF00),
                compact: compact,
                onTap: () => onLogout(),
              ),
              const SizedBox(height: 12),
              _ProfileActionButton(
                label: 'DELETE ACCOUNT',
                foregroundColor: AppPalette.danger,
                backgroundColor: const Color.fromRGBO(255, 82, 82, 0.12),
                borderColor: const Color.fromRGBO(255, 82, 82, 0.20),
                compact: compact,
                onTap: () async {
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: AppPalette.surface,
                        title: const Text(
                          'DELETE ACCOUNT?',
                          style: TextStyle(color: AppPalette.text),
                        ),
                        content: const Text(
                          'This action is permanent and cannot be undone. All your progress will be lost.',
                          style: TextStyle(color: AppPalette.mutedText),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('DELETE', style: TextStyle(color: AppPalette.danger)),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirm == true) {
                    await onDeleteAccount();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileMiniButton extends StatelessWidget {
  const _ProfileMiniButton({
    required this.label,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF2A2A2A),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 13 : 16,
            vertical: compact ? 8 : 9,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFFB7FF00),
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onTap,
    this.borderColor,
    this.compact = false,
  });

  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback onTap;
  final Color? borderColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: compact ? 48 : 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: borderColor ?? Colors.transparent),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: compact ? 12 : 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
