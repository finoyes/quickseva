import 'package:customer_app/main.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const sizes = <String, Size>{
    'small 320x640': Size(320, 640),
    'compact 360x740': Size(360, 740),
    'regular 412x915': Size(412, 915),
  };

  for (final entry in sizes.entries) {
    for (final hindi in [false, true]) {
      final label = '${entry.key} ${hindi ? 'HI' : 'EN'}';

      testWidgets('customer app no overflow: $label', (tester) async {
        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = entry.value;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(const QuickSevaCustomerApp());
        await tester.pump();

        if (hindi) {
          await tester.tap(find.byType(LanguageTogglePill).first);
          await tester.pump();
        }

        // Scroll down to bring Essential Home Repairs & Rate Card button into the Sliver viewport
        final rateCardBtn = find.byKey(const ValueKey('open-rate-card-sheet'));
        await tester.scrollUntilVisible(
          rateCardBtn,
          250,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pump(const Duration(milliseconds: 250));

        // Open the UC-Style Interactive Sub-Category & Rate-Card Bottom Sheet
        expect(rateCardBtn, findsOneWidget);
        await tester.ensureVisible(rateCardBtn);
        await tester.pump(const Duration(milliseconds: 250));
        await tester.tap(rateCardBtn);
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(find.byKey(const ValueKey('rate-card-checkout')), findsOneWidget);

        // Close the Rate-Card sheet
        await tester.tap(find.byIcon(Icons.close_rounded));
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        // Scroll Home tab through remaining sections (Categories, Masonry, Escrow Shield, All Services)
        await tester.drag(
          find.byType(CustomScrollView).first,
          const Offset(0, -900),
        );
        await tester.pump(const Duration(milliseconds: 300));
        await tester.drag(
          find.byType(CustomScrollView).first,
          const Offset(0, -1500),
        );
        await tester.pump(const Duration(milliseconds: 300));

        // Switch to Discover tab and Bookings tab
        await tester.tap(find.byIcon(Icons.grid_view_outlined));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.byIcon(Icons.receipt_long_outlined));
        await tester.pump(const Duration(milliseconds: 300));
      });
    }
  }
}
