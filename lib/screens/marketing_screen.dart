part of '../main.dart';

class MarketingScreen extends StatelessWidget {
  const MarketingScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.startupError,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimary,
    required this.onSecondary,
  });

  final String title;
  final String subtitle;
  final String? startupError;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppPalette.surfaceAlt,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppPalette.border),
            ),
            child: const Text(
              'KINETIC',
              style: TextStyle(
                color: AppPalette.primary,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          const Spacer(),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 28),
          _PrimaryButton(label: primaryLabel, onTap: onPrimary),
          const SizedBox(height: 12),
          _SecondaryButton(label: secondaryLabel, onTap: onSecondary),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppPalette.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppPalette.border),
            ),
          ),
          const SizedBox(height: 16),
          
          const Spacer(),
        ],
      ),
    );
  }

  String _readApiSummary() {
    return AppEnv.apiBaseUrlHint;
  }
}

