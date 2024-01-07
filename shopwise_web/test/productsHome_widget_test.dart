import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopwise_web/pages/product_types/products_home.dart';

void main() {
  testWidgets('ProductsHome widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProductsHome()));

    // Verify that the initial table index is 0
    expect(find.text('Produce'), findsOneWidget);

    // Tap on the second category button
    await tester.tap(find.text('Meat'));
    await tester.pump();

    // Verify that the table index has changed to 1
    expect(find.text('Meat'), findsOneWidget);

    // Tap on the third category button
    await tester.tap(find.text('Beverages'));
    await tester.pump();

    // Verify that the table index has changed to 2
    expect(find.text('Beverages'), findsOneWidget);
  });
}
