import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopwise/pages/login_screen.dart';
import 'package:shopwise/pages/products_list_page.dart';
import 'package:shopwise/pages/register.dart';
import 'package:shopwise/pages/startup.dart';
import 'package:shopwise/utils/colors.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopwise',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ).copyWith(
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
      initialRoute: StartupPage.routeName, // Set the startup page as the initial route
      routes: {
        StartupPage.routeName: (context) => StartupPage(),
        LoginScreen.routeName: (context) => const LoginScreen(),
      },
      // home: const MyHomePage(title: 'Shop Wise'),

      home: StartupPage(),
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
