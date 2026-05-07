part of '../main.dart';

class _ProfileStatCell extends StatelessWidget {
  const _ProfileStatCell({
    required this.value,
    required this.label,
    required this.color,
    this.bordered = false,
  });

  final String value;
  final String label;
  final Color color;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: AppPalette.surfaceAlt,
          border: bordered
              ? const Border(
                  left: BorderSide(color: AppPalette.surface),
                  right: BorderSide(color: AppPalette.surface),
                )
              : null,
        ),
        child: Column(
          children: <Widget>[
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: AppPalette.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.icon,
    this.locked = false,
  });

  final IconData icon;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: locked ? const Color.fromRGBO(19, 19, 19, 0.5) : AppPalette.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: locked ? const Color.fromRGBO(255, 255, 255, 0.06) : Colors.transparent),
      ),
      child: Center(
        child: locked
            ? const Icon(Icons.lock, color: AppPalette.mutedText)
            : Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(209, 252, 0, 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(icon, color: AppPalette.primary),
              ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.imageUrl,
    required this.radius,
  });

  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final double diameter = radius * 2;

    return ClipOval(
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Container(
              color: AppPalette.surfaceAlt,
              alignment: Alignment.center,
              child: Icon(
                Icons.person,
                color: AppPalette.primary,
                size: radius,
              ),
            );
          },
          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }
            return Container(
              color: AppPalette.surfaceAlt,
              alignment: Alignment.center,
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EditSection extends StatelessWidget {
  const _EditSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

