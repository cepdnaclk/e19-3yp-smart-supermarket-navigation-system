import 'package:flutter_test/flutter_test.dart';
import 'package:shopwise_web/main.dart';
import 'package:shopwise_web/pages/login/login.dart';

void main() {
  testWidgets('should render MyApp and LoginPage', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(const MyApp());

    // Verify that MyApp widget is rendered
    expect(find.byType(MyApp), findsOneWidget);

    // Verify that LoginPage widget is rendered
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
