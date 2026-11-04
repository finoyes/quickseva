import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BrandConfig and CatalogData have pre-seeded categories and services',
      () {
    expect(BrandConfig.brandName, 'QuickSeva');
    expect(CatalogData.categories.length, 7);
    expect(CatalogData.services.isNotEmpty, isTrue);
  });
}
