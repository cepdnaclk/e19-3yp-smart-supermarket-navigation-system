// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shopwise_web/pages/product_types/products_home.dart';

// void main() {
//   testWidgets('should display category buttons', (WidgetTester tester) async {
//     // Define the list of categories
//     final categories = [
//       'Produce',
//       'Meat',
//       'Beverages',
//       'Bakery',
//       'Diary',
//       'snacks',
//       'frozen',
//       'Health and Beauty',
//       'Cleaning',
//       'Household',
//       'Baby Care',
//       'other'
//     ];

// debugDumpApp(); // Print the widget hierarchy

//     // Build the widget tree
//     await tester.pumpWidget(const MaterialApp(home: ProductsHome()));

//     // Verify that each category button is displayed
//     for (var category in categories) {
//       expect(find.text(category), findsOneWidget);
//     }
//   });
// }


//--------------------------------------------------------------------------------------------
//done
  // The table should be displayed below the category buttons.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopwise_web/pages/product_types/products_home.dart';

void main() {
  testWidgets('should display table below category buttons', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(const MaterialApp(home: ProductsHome()));

    // Find the category buttons and table in the widget tree
    final categoryButtonsFinder = find.byType(Container).first;
    final tableFinder = find.byType(Container).last;

    // Get the top position (y-coordinate) of the category buttons and table
    final categoryButtonsTop = tester.getTopLeft(categoryButtonsFinder).dy;
    final tableTop = tester.getTopLeft(tableFinder).dy;

    // Verify that the table is displayed below the category buttons
    expect(tableTop, greaterThan(categoryButtonsTop));
  });
}

//---------------------------------------------------------------------------------------------
  // The categories list is empty.
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shopwise_web/pages/product_types/product_tables.dart';
// import 'package:shopwise_web/pages/product_types/products_home.dart';

// void main() {
//   testWidgets('should handle empty categories list', (WidgetTester tester) async {
//     // Build the widget tree
//     await tester.pumpWidget(const MaterialApp(home: ProductsHome()));

//     // Verify that no TextButton widgets are found in the widget tree
//     expect(find.byType(ListView), findsNothing);
//     expect(find.byType(ProduceTable), findsNothing);
//   });
// }


  // The tableIndex is null.
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shopwise_web/pages/product_types/products_home.dart';

// void main() {
//   testWidgets('should handle null table index', (WidgetTester tester) async {
//     int? tableIndex; // Declare tableIndex variable

//     // Build the widget tree
//     await tester.pumpWidget(MaterialApp(
//       home: ProductsHome(
//         tableIndex: tableIndex,
//         onUpdateTableIndex: (index) {
//           tableIndex = index;
//         },
//       ),
//     ));

//     // Verify the initial value of tableIndex
//     expect(tableIndex, 0);

//     // Set tableIndex to null using the callback onUpdateTableIndex
//     await tester.runAsync(() async {
//       await tester.pumpWidget(MaterialApp(
//         home: ProductsHome(
//           tableIndex: tableIndex,
//           onUpdateTableIndex: (index) {
//             tableIndex = index;
//           },
//         ),
//       ));

//       // Call the callback to update the tableIndex
//       ProductsHomeState? state = tester.state<ProductsHomeState>(find.byType(ProductsHome));
//       state?.widget.onUpdateTableIndex(null);
//     });

//     // Rebuild the widget tree
//     await tester.pump();

//     // Verify that the tableIndex is null
//     expect(tableIndex, isNull);
//   });
// }