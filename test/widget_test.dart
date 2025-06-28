import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vitalink/main.dart';
import 'package:vitalink/core/di/dependency_injection.dart';

void main() {
  group('VitalLink App', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      await DependencyInjection.init();
    });

    testWidgets('App should build without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const VitalLinkApp());
      await tester.pumpAndSettle();
      
      // Verify that the app builds without throwing exceptions
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Should show splash screen initially', (WidgetTester tester) async {
      await tester.pumpWidget(const VitalLinkApp());
      await tester.pump();
      
      // Check if the splash screen is displayed
      expect(find.text('VitalLink'), findsOneWidget);
    });
  });
}
