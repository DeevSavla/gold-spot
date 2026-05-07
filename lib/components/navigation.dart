part of '../main.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentScreen,
    required this.role,
    required this.onSelect,
  });

  final AppScreen currentScreen;
  final AuthRole role;
  final ValueChanged<AppScreen> onSelect;

  @override
  Widget build(BuildContext context) {
    const Color activeTabColor = Color(0xFFB7FF00);
    final List<_NavItem> items = role == AuthRole.trainer
        ? const <_NavItem>[
            _NavItem(label: 'Home', icon: Icons.space_dashboard_outlined, screen: AppScreen.trainerDashboard),
            _NavItem(label: 'Create', icon: Icons.add_box_outlined, screen: AppScreen.createChallenge),
            _NavItem(label: 'Profile', icon: Icons.person_outline, screen: AppScreen.profile),
          ]
        : const <_NavItem>[
            _NavItem(label: 'Home', icon: Icons.home_outlined, screen: AppScreen.dashboard),
            _NavItem(label: 'Challenges', icon: Icons.emoji_events_outlined, screen: AppScreen.leaderboard),
            _NavItem(label: 'Profile', icon: Icons.person_outline, screen: AppScreen.profile),
          ];

    return Container(
      decoration: const BoxDecoration(
        color: AppPalette.surface,
        border: Border(top: BorderSide(color: AppPalette.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: items.map((item) {
            final bool selected = item.screen == currentScreen;
            return Expanded(
              child: InkWell(
                onTap: () => onSelect(item.screen),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        item.icon,
                        color: selected ? activeTabColor : AppPalette.mutedText,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: selected ? activeTabColor : AppPalette.mutedText,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.screen,
  });

  final String label;
  final IconData icon;
  final AppScreen screen;
}

class _DashboardShell extends StatelessWidget {
  const _DashboardShell({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

