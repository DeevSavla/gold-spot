import 'package:flutter_test/flutter_test.dart';

import 'package:gold_spot_flutter/main.dart';

void main() {
  testWidgets('shows onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(const KineticApp());

    expect(find.text('KINETIC'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
