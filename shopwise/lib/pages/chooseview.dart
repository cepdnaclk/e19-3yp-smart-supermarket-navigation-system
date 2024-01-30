import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopwise/pages/all_products.dart';
import 'package:shopwise/pages/custom_map_view.dart';
import 'package:shopwise/pages/login_screen.dart';
import 'package:shopwise/pages/scan_barcode_view.dart';
import 'package:shopwise/pages/shopping_list.dart';
import 'package:shopwise/pages/startup.dart';
import 'package:shopwise/pages/mqtt_client_test.dart';
import 'package:shopwise/providers/customer_provider.dart';

class Choose extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: const Text("On your way!"),
      ),
      body: Center(
        child: Container(
          height: 1200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // const SizedBox(height: 60),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image(
                  image: AssetImage("assets/images/secondary.png"),
                ),
              ),

              const SizedBox(height: 300),
              Hero(
                tag: "greenButton",
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    key: ValueKey("starts"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, ShoppingList.routeName);
                    },
                    child: Text(
                      "Create the shopping list",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Container(
              //   height: 50,
              //   width: 300,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Theme.of(context).secondaryHeaderColor,
              //       foregroundColor: Colors.black,
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(
              //           builder: (context) => ScanBarcode(),
              //         ),
              //       );
              //     },
              //     child: Text("Start shopping!"),
              //   ),
              // ),
              // Container(
              //   height: 50,
              //   width: 300,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Theme.of(context).secondaryHeaderColor,
              //       foregroundColor: Colors.black,
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(
              //           builder: (context) => AllProducts(),
              //         ),
              //       );
              //     },
              //     child: Text("All Products"),
              //   ),
              // ),
              SizedBox(height: 10),
              Hero(
                tag: "outlinedButton",
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: OutlinedButton(
                    child: Text(
                      "Log out",
                      style: TextStyle(fontSize: 17),
                    ),
                    onPressed: () => {logoutStep(context)},
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: BorderSide(color: Colors.green)),
                  ),
                ),
              ),
              // Container(
              //   height: 50,
              //   width: 300,
              //   child: OutlinedButton(
              //     child: Text("Add the customer"),
              //     onPressed: () => {
              //       ref.read(customerNotifierProvider.notifier).saveCustomer()
              //     },
              //     style: OutlinedButton.styleFrom(
              //         foregroundColor: Colors.green,
              //         side: BorderSide(color: Colors.green)),
              //   ),
              // ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
