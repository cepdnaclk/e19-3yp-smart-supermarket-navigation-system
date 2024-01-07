
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopwise_web/pages/product_types/products_home.dart';
import 'package:shopwise_web/pages/product_types/product_tables.dart';

//test for table load relevant to pressed category button
void main() {
  testWidgets('ProductsHome widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProductsHome()));

    // Verify that the initial table is the ProduceTable with index 0
    expect(find.byType(ProduceTable), findsOneWidget);
    expect(find.byKey(const Key('produce_table_0')), findsOneWidget);

    // Tap on the second category button
    await tester.tap(find.text('Meat'));
    await tester.pump();

    // Verify that the table has changed to the ProduceTable with index 1
    expect(find.byType(ProduceTable), findsOneWidget);
    expect(find.byKey(const Key('produce_table_1')), findsOneWidget);

    // Tap on the third category button
    await tester.tap(find.text('Beverages'));
    await tester.pump();

    // Verify that the table has changed to the ProduceTable with index 2
    expect(find.byType(ProduceTable), findsOneWidget);
    expect(find.byKey(const Key('produce_table_2')), findsOneWidget);
  });
}
