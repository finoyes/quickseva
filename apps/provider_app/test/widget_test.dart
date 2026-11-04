import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider_app/main.dart';

void main() {
  testWidgets('Provider app renders QuickSeva Partner & Online toggle',
      (WidgetTester tester) async {
    await tester.pumpWidget(const QuickSevaProviderApp());
    expect(find.textContaining(BrandConfig.brandName), findsWidgets);
    expect(find.text('YOU ARE ONLINE'), findsOneWidget);
  });
}
