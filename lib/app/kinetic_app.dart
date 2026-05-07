part of '../main.dart';

class KineticApp extends StatelessWidget {
  const KineticApp({super.key, this.startupError});

  final String? startupError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinetic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppPalette.background,
        colorScheme: const ColorScheme.dark(
          primary: AppPalette.primary,
          secondary: AppPalette.secondary,
          surface: AppPalette.surface,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: AppPalette.text,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.4,
          ),
          titleLarge: TextStyle(
            color: AppPalette.text,
            fontWeight: FontWeight.w800,
          ),
          bodyLarge: TextStyle(
            color: AppPalette.text,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            color: AppPalette.mutedText,
            height: 1.5,
          ),
        ),
      ),
      home: HomeFlow(startupError: startupError),
    );
  }
}

