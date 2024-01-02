import 'package:flutter/material.dart';
import 'package:shopwise_web/side_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Wise',
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: const SideNavBar(),
    );
  }
}

const primaryColor = Color.fromARGB(255, 196, 218, 200);
const canvasColor = Color.fromARGB(255, 44, 122, 59);
const scaffoldBackgroundColor = Color.fromARGB(255, 220, 240, 223);
