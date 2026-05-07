part of '../main.dart';

class LogoutLoadingScreen extends StatelessWidget {
  const LogoutLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 360,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        decoration: BoxDecoration(
          color: AppPalette.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppPalette.border),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'KINETIC',
              style: TextStyle(
                color: AppPalette.primary,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 18),
            CircularProgressIndicator(color: AppPalette.primary),
            SizedBox(height: 18),
            Text(
              'Logging You Out',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppPalette.text,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Closing your session and taking you back to the landing page.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppPalette.mutedText, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

