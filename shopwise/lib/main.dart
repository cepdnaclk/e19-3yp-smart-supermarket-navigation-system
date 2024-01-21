import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


import 'package:shopwise/pages/chooseview.dart';
import 'package:shopwise/pages/login_screen.dart';
import 'package:shopwise/pages/mqtt_client_test.dart';
import 'package:shopwise/pages/products_list_page.dart';
import 'package:shopwise/pages/register.dart';
import 'package:shopwise/pages/select_items.dart';
import 'package:shopwise/pages/shopping_list.dart';
import 'package:shopwise/pages/startup.dart';
import 'package:shopwise/utils/colors.dart';

import 'amplifyconfiguration.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        // builder: Authenticator.builder(),
        debugShowCheckedModeBanner: false,
        title: 'Shopwise',
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ).copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green),
          primaryColor: Colors.white,
          secondaryHeaderColor: AppColors.primaryColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(1, 40, 185, 54),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColorDark,
            ),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 4, // Add shadow to app bar
          ),
        ),
        initialRoute:
            StartupPage.routeName, // Set the startup page as the initial route
        routes: {
          StartupPage.routeName: (context) => StartupPage(),

          Choose.routeName: (context) => AuthenticatedView(child: Choose()),

          ShoppingList.routeName: (context) =>
              AuthenticatedView(child: ShoppingList()),
          SelectItems.routeName: (context) =>
              AuthenticatedView(child: SelectItems()),
              MQTTClientTest.routeName: (context) => AuthenticatedView(child: MQTTClientTest()),
          // LoginScreen.routeName: (context) => const LoginScreen(),
        },
        // home: const MyHomePage(title: 'Shop Wise'),

        // home: StartupPage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Wise'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Shop wise",
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
