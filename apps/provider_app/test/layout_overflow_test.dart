import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider_app/main.dart';

/// Drives every provider screen at common Android phone sizes in both
/// languages. Any RenderFlex overflow is reported by Flutter as an exception,
/// which fails the test.
void main() {
  const sizes = <String, Size>{
    'small 320x640': Size(320, 640),
    'compact 360x740': Size(360, 740),
    'regular 412x915': Size(412, 915),
  };

  Future<void> tapKey(WidgetTester tester, String key) async {
    final finder = find.byKey(ValueKey(key));
    expect(finder, findsOneWidget, reason: 'missing "$key"');
    await tester.ensureVisible(finder);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(finder);
    await tester.pump(const Duration(milliseconds: 400));
  }

  for (final entry in sizes.entries) {
    for (final hindi in [false, true]) {
      final label = '${entry.key} ${hindi ? 'HI' : 'EN'}';

      testWidgets('no overflow: $label', (tester) async {
        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = entry.value;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(const QuickSevaProviderApp());
        await tester.pump();

        if (hindi) {
          await tester.tap(find.byType(LanguageTogglePill).first);
          await tester.pump();
        }

        // 1. Duty home -> open the incoming offer sheet.
        await tapKey(tester, 'simulate-offer');
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        // 2. Accept the offer.
        await tapKey(tester, 'offer-accept');
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(find.byKey(const ValueKey('offer-accept')), findsNothing);

        // 3. Advance through step 0 (assigned -> enRoute) and step 1 (enRoute -> arrived).
        await tapKey(tester, 'job-step-action');
        await tapKey(tester, 'job-step-action');

        // 3b. Open the Interactive 4-Digit OTP Keypad Modal at Arrived state, enter digits & verify!
        await tapKey(tester, 'open-otp-keypad');
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        await tapKey(tester, 'otp-key-4');
        await tapKey(tester, 'otp-key-8');
        await tapKey(tester, 'otp-key-2');
        await tapKey(tester, 'otp-key-9');
        await tapKey(tester, 'otp-verify-submit');
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        // 3c. Final step (inProgress -> completed).
        await tapKey(tester, 'job-step-action');
        expect(find.byKey(const ValueKey('job-step-action')), findsNothing);
        expect(find.byKey(const ValueKey('simulate-offer')), findsOneWidget);

        // 4. Scroll Duty screen back to top and toggle Offline state.
        final dutySwitch = find.byType(Switch).first;
        await tester.ensureVisible(dutySwitch);
        await tester.pump(const Duration(milliseconds: 200));
        await tester.tap(dutySwitch);
        await tester.pump(const Duration(milliseconds: 300));

        // 5. Earnings & ledger tab, scrolled to the end.
        await tester.tap(find.byIcon(Icons.query_stats_rounded));
        await tester.pump(const Duration(milliseconds: 400));
        await tester.drag(find.byType(ListView).last, const Offset(0, -3000));
        await tester.pump(const Duration(milliseconds: 400));

        // Let snackbars and the offer timer finish.
        await tester.pump(const Duration(seconds: 30));
      });
    }
  }
}
