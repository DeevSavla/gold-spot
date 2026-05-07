import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  HealthService({Health? health}) : _health = health ?? Health();

  final Health _health;
  bool _isConfigured = false;

  static const List<HealthDataType> _stepTypes = <HealthDataType>[
    HealthDataType.STEPS,
  ];

  Future<void> _configure() async {
    if (_isConfigured) {
      return;
    }

    await _health.configure();
    _isConfigured = true;
  }

  Future<bool> requestPermissions() async {
    await _configure();
    if (!await _requestActivityRecognition()) {
      return false;
    }

    return _health.requestAuthorization(_stepTypes);
  }

  Future<int?> getTodaySteps() async {
    if (!await _ensureStepPermissions()) {
      return null;
    }

    final DateTime now = DateTime.now();
    final DateTime midnight = DateTime(now.year, now.month, now.day);
    return _health.getTotalStepsInInterval(midnight, now);
  }

  Future<List<HourlyStepCount>?> getTodayHourlySteps() async {
    if (!await _ensureStepPermissions()) {
      return null;
    }

    final DateTime now = DateTime.now();
    final DateTime midnight = DateTime(now.year, now.month, now.day);
    final List<HourlyStepCount> hourlySteps = <HourlyStepCount>[];

    for (DateTime start = midnight; start.isBefore(now); start = start.add(const Duration(hours: 1))) {
      final DateTime end = start.add(const Duration(hours: 1)).isBefore(now)
          ? start.add(const Duration(hours: 1))
          : now;
      final int steps = await _health.getTotalStepsInInterval(start, end) ?? 0;
      hourlySteps.add(
        HourlyStepCount(
          start: start,
          end: end,
          steps: steps,
        ),
      );
    }

    return hourlySteps;
  }

  Future<bool> _ensureStepPermissions() async {
    await _configure();

    if (!await _requestActivityRecognition()) {
      return false;
    }

    bool hasPermission = await _health.hasPermissions(_stepTypes) ?? false;
    if (!hasPermission) {
      hasPermission = await requestPermissions();
    }

    return hasPermission;
  }

  Future<bool> _requestActivityRecognition() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return true;
    }

    final PermissionStatus status = await Permission.activityRecognition.request();
    return status.isGranted || status.isLimited;
  }
}

class HourlyStepCount {
  const HourlyStepCount({
    required this.start,
    required this.end,
    required this.steps,
  });

  final DateTime start;
  final DateTime end;
  final int steps;
}
