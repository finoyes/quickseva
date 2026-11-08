import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BrandConfig and CatalogData have pre-seeded categories and services',
      () {
    expect(BrandConfig.brandName, 'QuickSeva');
    expect(CatalogData.categories.length, 8);
    expect(CatalogData.services.length, greaterThanOrEqualTo(18));
    expect(CatalogData.searchServices('masonry').isNotEmpty, isTrue);
    expect(CatalogData.searchServices('rajmistri').isNotEmpty, isTrue);
    expect(CatalogData.searchServices('tile').isNotEmpty, isTrue);
    expect(CatalogData.searchServices('welder').isNotEmpty, isTrue);
    expect(CatalogData.searchServices('carpenter').isNotEmpty, isTrue);
    expect(CatalogData.searchServices('beldar').isNotEmpty, isTrue);
  });

  test('DummyFeeEngine produces balanced double-entry journals for all 4 plans',
      () {
    for (final plan in MonetizationPlanType.values) {
      for (final mode in PaymentMode.values) {
        final result = DummyFeeEngine.computeFees(
          plan: plan,
          labourRupees: 499,
          sparePartsRupees: 89,
          paymentMode: mode,
        );
        final totalDr = result.journalLines
            .fold<int>(0, (sum, line) => sum + line.debitRupees);
        final totalCr = result.journalLines
            .fold<int>(0, (sum, line) => sum + line.creditRupees);
        expect(totalDr, equals(totalCr));
        expect(
          result.providerNetPayoutRupees + result.totalPlatformTakeRupees,
          equals(result.grossTotalRupees),
        );
      }
    }
  });
}
