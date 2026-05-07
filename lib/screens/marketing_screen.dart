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
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.black),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool compact = constraints.maxWidth < 380;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                compact ? 20 : 24,
                22,
                compact ? 20 : 24,
                32,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 54,
                  maxWidth: 620,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const _MarketingTopBar(),
                    SizedBox(height: compact ? 34 : 44),
                    _MarketingPulseCard(compact: compact),
                    SizedBox(height: compact ? 30 : 38),
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 42 : 50,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w900,
                        height: 0.92,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: const Color(0xFFB8B8B8),
                        fontSize: compact ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (startupError != null) ...<Widget>[
                      _StartupErrorBanner(message: startupError!),
                      const SizedBox(height: 18),
                    ],
                    _MarketingPrimaryButton(label: primaryLabel, onTap: onPrimary),
                    const SizedBox(height: 12),
                    _MarketingSecondaryButton(label: secondaryLabel, onTap: onSecondary),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MarketingTopBar extends StatelessWidget {
  const _MarketingTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Text(
          'KINETIC',
          style: TextStyle(
            color: Color(0xFFD7FF00),
            fontSize: 21,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const Spacer(),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.bolt_rounded, color: Color(0xFFD7FF00)),
        ),
      ],
    );
  }
}

class _MarketingPulseCard extends StatelessWidget {
  const _MarketingPulseCard({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 18 : 22),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color.fromRGBO(215, 255, 0, 0.22)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(215, 255, 0, 0.16),
            blurRadius: 34,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: compact ? 92 : 112,
            height: compact ? 92 : 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD7FF00), width: 4),
              color: Colors.black,
            ),
            child: const Icon(
              Icons.directions_run_rounded,
              color: Color(0xFFD7FF00),
              size: 48,
            ),
          ),
          SizedBox(width: compact ? 16 : 22),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'TRAIN. COMPETE. REPEAT.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Challenge-based fitness with progress that feels alive.',
                  style: TextStyle(
                    color: Color(0xFFA4A4A4),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StartupErrorBanner extends StatelessWidget {
  const _StartupErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppPalette.danger.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.danger.withValues(alpha: 0.35)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: AppPalette.danger,
          fontWeight: FontWeight.w800,
          height: 1.3,
        ),
      ),
    );
  }
}

class _MarketingPrimaryButton extends StatelessWidget {
  const _MarketingPrimaryButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFD7FF00),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: onTap,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class _MarketingSecondaryButton extends StatelessWidget {
  const _MarketingSecondaryButton({
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
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color.fromRGBO(215, 255, 0, 0.28)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: onTap,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
