part of '../main.dart';

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? _kineticNeon.withValues(alpha: 0.16) : _authPanel,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? _kineticNeon : const Color.fromRGBO(215, 255, 0, 0.12),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? _kineticNeon : AppPalette.text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleSelectorButton extends StatelessWidget {
  const _RoleSelectorButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _kineticNeon : _authPanel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _kineticNeon : const Color.fromRGBO(215, 255, 0, 0.12),
          ),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: _kineticNeon.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              label == 'TRAINER' ? Icons.workspace_premium : Icons.person,
              size: 17,
              color: selected ? Colors.black : _kineticNeon,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.black : AppPalette.mutedText,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

