import 'package:flutter_test/flutter_test.dart';
import 'package:mini_product_catalog/main.dart';

void main() {
  testWidgets('Login screen displays guest login button', (tester) async {
    await tester.pumpWidget(const MiniProductCatalogApp());
    expect(find.text('Login as Guest'), findsOneWidget);
  });
}
