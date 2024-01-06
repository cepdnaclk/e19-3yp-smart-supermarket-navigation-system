
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shopwise/pages/custom_map_view.dart';
import 'package:shopwise/pages/login_screen.dart';
import 'package:shopwise/pages/startup.dart';
import 'package:shopwise/pages/mqtt_client_test.dart';

class Choose extends StatelessWidget {
  const Choose({super.key});

  static const String routeName = '/choose';

  Future<void> logoutStep(context) async {
    try {
      // Sign out
      await Amplify.Auth.signOut();
      Navigator.pushReplacementNamed(context, StartupPage.routeName);
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: const Text("Choose"),
      ),
      body: Center(
        child: Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Image(
                image: AssetImage("assets/images/secondary.png"),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {},
                child: Text("Create the shopping list"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MQTTClientTest(),
                    ),
                  );
                },
                child: Text("Navigate"),
              ),

              TextButton(child: Text("Log out"), onPressed: ()=>{
                logoutStep(context)
              },)
            ],
          ),
        ),
      ),
    );
  }
}
