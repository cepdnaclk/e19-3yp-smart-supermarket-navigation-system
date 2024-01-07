import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopwise/main.dart';
import 'package:shopwise/pages/chooseview.dart';
import 'package:shopwise/pages/custom_map_view.dart';
import 'package:shopwise/pages/login_screen.dart';
import 'package:shopwise/pages/mqtt_client_test.dart';
import 'package:shopwise/pages/products_list_page.dart';
import 'package:shopwise/pages/select_items.dart';
import 'package:shopwise/pages/shopping_list.dart';
import 'package:shopwise/pages/startup.dart';

void main() {

  testWidgets('Testing the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Choose(),
    ));

    final startChoppingButton  = find.byKey(ValueKey("starts"));

    await tester.pumpWidget(MaterialApp(
      home: Choose(),
    ));

    await tester.tap(startChoppingButton);
    await tester.pump();

    expect(find.byKey(ValueKey("Add item")), findsWidgets);
    // expect(find.text("Start shopping!"), findsWidgets);

    // expect(find.text("Get Started!"), findsWidgets);
    // expect(find.byKey(ValueKey("logo")), findsWidgets);
    // expect(find.byKey(ValueKey("start")), findsWidgets);
    // expect(find.byType(MaterialApp), findsOneWidget);
    // expect(find.byType(Authenticator), findsOneWidget);
    // expect(find.byType(MaterialApp), findsOneWidget);
    // expect(find.byType(StartupPage), findsOneWidget);
    // expect(find.byType(LoginScreen), findsOneWidget);
    // expect(find.byType(Register), findsOneWidget);
    // expect(find.byType(Choose), findsOneWidget);
    // expect(find.byType(ShoppingList), findsOneWidget);
    // expect(find.byType(SelectItems), findsOneWidget);
    // expect(find.byType(ProductsListPage), findsOneWidget);
    // expect(find.byType(CustomMapView), findsOneWidget);
    // expect(find.byType(MQTTClientTest), findsOneWidget);
  });
}
