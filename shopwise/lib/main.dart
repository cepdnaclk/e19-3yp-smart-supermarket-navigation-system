import 'dart:convert';

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopwise/pages/all_products.dart';
import 'package:shopwise/pages/scan_qrcode_page.dart';
import 'package:shopwise/providers/customer_provider.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

import 'package:shopwise/pages/chooseview.dart';
import 'package:shopwise/pages/login_screen.dart';
import 'package:shopwise/pages/mqtt_client_test.dart';
import 'package:shopwise/pages/products_list_page.dart';
import 'package:shopwise/pages/register.dart';
import 'package:shopwise/pages/select_items.dart';
import 'package:shopwise/pages/shopping_list.dart';
import 'package:shopwise/pages/startup.dart';
import 'package:shopwise/utils/colors.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'amplifyconfiguration.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await dotenv.dotenv.load(fileName: "../.env");
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _configureAmplify();
  }

//   void encryptSUB(String encryptedSubBase64) {
//     final key = encrypt.Key.fromUtf8('1234567890987654');
//     final iv = encrypt.IV.fromLength(16); // AES block size is 16
//     final encrypter = encrypt.Encrypter(encrypt.AES(key));

// // Assuming `encryptedSub` is the encrypted sub ID you stored in your database
//     final encryptedSub = encrypt.Encrypted.fromBase64(encryptedSubBase64);

//     print('encryptedSub: ${encryptedSub}');

//     final decryptedSub = encrypter.decrypt(encryptedSub, iv: iv);

//     print('decryptedSub: ${decryptedSub}');

// // Now `decryptedSub` contains the original sub ID
//   }
  String encryptSUB(String sub) {
    final key = encrypt.Key.fromUtf8(
        "1234567890987654"); // Ensure this key is securely managed
    final iv = encrypt.IV.fromLength(16); // AES block size is 16
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encryptedSub = encrypter.encrypt(sub, iv: iv);

    print('encryptedSub: ${encryptedSub.base64}');

    final decryptedSub = encrypter.decrypt(encryptedSub, iv: iv);

    print('decryptedSub: ${decryptedSub}');

    return encryptedSub.base64.toString();

// Now `decryptedSub` contains the original sub ID
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

    try {
      var session = await Amplify.Auth.fetchAuthSession(
        options: FetchAuthSessionOptions(forceRefresh: true),
      );
      var cognitoToken =
          (session as CognitoAuthSession).userPoolTokensResult.value;
      print('User token: ${cognitoToken.idToken}');
      var sub_UUID = cognitoToken.idToken.claims.subject;
      print('User token expanded: ${sub_UUID}');
      var parts = cognitoToken.toJson();
      print('User token json: ${parts}');

      var encrypted = encryptSUB(sub_UUID.toString());

      print('encrypted: ${encrypted}');

      ref.read(customerNotifierProvider.notifier).updateSubUuid(encrypted);

      // ref.read(customerNotifierProvider.notifier).updateHashcode("myhashcode");

      ref.read(customerNotifierProvider.notifier).updateOrderId("5");

      ref
          .read(customerNotifierProvider.notifier)
          .updateShoppingDate(DateTime.now());

      // var header =
      //     json.decode(utf8.decode(base64.decode(base64.normalize(parts.))));
      // var payload =
      //     json.decode(utf8.decode(base64.decode(base64.normalize(parts[1]))));

      // print('kid: ${header['kid']}');
      // print('aud: ${payload['aud']}');
    } on AuthException catch (e) {
      print(e.message);
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
          MQTTClientTest.routeName: (context) =>
              AuthenticatedView(child: MQTTClientTest()),
          AllProducts.routeName: (context) =>
              AuthenticatedView(child: AllProducts()),
          ScanQrCodePage.routeName: (context) => ScanQrCodePage()
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
