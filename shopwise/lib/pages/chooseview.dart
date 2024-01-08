import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shopwise/pages/custom_map_view.dart';
import 'package:shopwise/pages/login_screen.dart';
import 'package:shopwise/pages/scan_barcode_view.dart';
import 'package:shopwise/pages/shopping_list.dart';
import 'package:shopwise/pages/startup.dart';
import 'package:shopwise/pages/mqtt_client_test.dart';

class Choose extends StatefulWidget {
  Choose({super.key});
String userName = "";
  static const String routeName = '/choose';

  @override
  State<Choose> createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
  

  // @override
  // initState() {
  //   super.initState();
  //   getCurrentUser();

  //   Future<AuthUser> getUser = getCurrentUser();
  //   getUser.then((value) => {widget.userName = value.username});
  // }

  Future<void> logoutStep(context) async {
    try {
      // Sign out
      await Amplify.Auth.signOut();
      Navigator.pushReplacementNamed(context, StartupPage.routeName);
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Future<AuthUser> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    widget.userName = user.username;
    print(user.username);
    print("....");
    print(widget.userName);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    print("hi....${widget.userName}");

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text("On Your Way!"),
      ),
      body: Center(
        child: Container(
          height: 600,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 60),
              const Image(
                image: AssetImage("assets/images/secondary.png"),
              ),
              const SizedBox(height: 300),
              Container(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  key: ValueKey("starts"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, ShoppingList.routeName);
                  },
                  child: Text("Create the shopping list"),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ScanBarcode(),
                      ),
                    );
                  },
                  child: Text("Start shopping!"),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                width: 300,
                child: OutlinedButton(
                  child: Text("Log out"),
                  onPressed: () => {logoutStep(context)},
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: BorderSide(color: Colors.green)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
