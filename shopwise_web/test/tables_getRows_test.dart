import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopwise_web/pages/product_types/product_tables.dart';

void main() {
  testWidgets('getRows returns valid DataRows', (WidgetTester tester) async {
    final dataSource = ProductsTableDataSource();
    const index = 0;

    final result = dataSource.getRows(index);

    expect(result.length, equals(dataSource.products.length));
    for (var i = 0; i < result.length; i++) {
      final cells = result[i].cells;
      for (var j = 0; j < cells.length; j++) {
        final cellChild = cells[j].child;
        expect(cellChild, isA<Container>());
        final containerChild = (cellChild as Container).child;
        expect(containerChild, isA<Text>());
      }
    }
  });
}