import 'package:customer_app/main.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Customer app renders QuickSeva brand and Discover section',
      (WidgetTester tester) async {
    await tester.pumpWidget(const QuickSevaCustomerApp());
    expect(find.textContaining(BrandConfig.brandName), findsWidgets);
    expect(find.text('Discover'), findsWidgets);
  });
}
