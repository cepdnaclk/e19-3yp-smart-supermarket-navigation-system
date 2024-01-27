import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/login/login.dart';
import 'package:shopwise_web/pages/login/register.dart';
import 'package:shopwise_web/side_navbar.dart';
import 'amplifyconfiguration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDlbIDquMpZs78Y5212IZhjTXwva-vGf0A",
          appId: "1:1051084283871:web:e11421632c96074f76ee6a",
          messagingSenderId: "1051084283871",
          projectId: "shop-wise-f9d93"));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
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

  // Future<bool> isUserSignedIn() async {
  //   final result = await Amplify.Auth.fetchAuthSession();
  //   return result.isSignedIn;
  // }

  // Future<AuthUser> getCurrentUser() async {
  //   final user = await Amplify.Auth.getCurrentUser();
  //   return user;
  // }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        // builder: Authenticator.builder(),
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
        
        initialRoute:
        // TestPage.routeName,
        LoginPage.routeName, // Set the startup page as the initial route

        routes: {
          // TestPage.routeName:(context) =>   TestPage(),
          LoginPage.routeName: (context) =>LoginPage(),
          RegisterPage.routeName: (context) =>
              AuthenticatedView(child: RegisterPage()),
          SideNavBar.routeName:(context) => AuthenticatedView(child: SideNavBar())
         }
      ),
    );
  }
}

const primaryColor = Color.fromARGB(255, 196, 218, 200);
const canvasColor = Color.fromARGB(255, 44, 122, 59);
const scaffoldBackgroundColor = Color.fromARGB(255, 220, 240, 223);
