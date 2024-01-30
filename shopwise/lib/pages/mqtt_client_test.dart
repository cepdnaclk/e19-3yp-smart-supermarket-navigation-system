import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopwise/models/product.dart';
import 'package:shopwise/pages/the_map.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:shopwise/providers/customer_provider.dart';
import 'package:shopwise/providers/shopping_list_provider.dart';
import 'package:shopwise/services/fetch_shoppinglist_products.dart';
import 'package:shopwise/services/mqtt_service.dart';

class MQTTClientTest extends ConsumerStatefulWidget {
  static const String routeName = '/mqttClientTest';
  MQTTClientTest({Key? key}) : super(key: key);

  List<Product> shoppingList = [];

  @override
  _MQTTClientTestState createState() => _MQTTClientTestState();
}

class _MQTTClientTestState extends ConsumerState<MQTTClientTest> {
  bool isConnectionChanged = false;
  TextEditingController idTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // getShopingList();
    _connect_auto();
    print("init called");

    super.initState();
  }

  @override
  void dispose() {
    idTextController.dispose();
    MQTT_Service.client.disconnect();
    super.dispose();
  }

  void getShopingList() {
    print("Fetching shopping list............");

    List<int> ids = ref
        .watch(shoppingListProvider.notifier)
        .getShoppingIDsFromDB(
            ref.read(customerNotifierProvider.notifier).getEmail());

    ShoppingListFetcher shoppingListFetcher = ShoppingListFetcher(
        email: ref.read(customerNotifierProvider.notifier).getEmail());

    shoppingListFetcher.fetchCustomersShoppingList((list) {
      widget.shoppingList = list;
    });

    print("shopping list after fetching: ${widget.shoppingList}");
  }

  _connect_auto() async {
    MQTT_Service.isConnected =
        await MQTT_Service.mqttConnect(idTextController.text.trim());

    setState(() {
      isConnectionChanged = MQTT_Service.isConnected;
    });

    if (MQTT_Service.isConnected) {
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Congratulations!',
          message: 'You are online',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Sorry!',
          message: 'Please check your internet connection.',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    // // print(isConnected);
    // print("dismissing.................");
    // if (isConnected) {
    //   // pd.close();
    //   progressDialog.setBackgroundColor(Colors.red);
    //   progressDialog.setTitle(Text("Connected"));
    //   progressDialog.setMessage(Text("Connected to core"));
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     progressDialog.dismiss();
    //   });
    //   // progressDialog.dismiss();
    // } else {
    //   print('isConnected is false');
    // }
    // if (isConnected) {
    //   progressDialog.dismiss();
    // }
  }

  @override
  Widget build(BuildContext context) {
    getShopingList();
    // widget.shoppingList =
    //     ref.watch(shoppingListProvider.notifier).getShoppingProducts();
    print("build......................");
    return Scaffold(
      // appBar: AppBar(title: Text("Start Shopping")),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: const Color.fromRGBO(158, 158, 158, 1),
          child: TheMap(directionStream: MQTT_Service.streamController.stream),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: ((context) => Dialog(
                child: Container(
                  height: 500,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Your Shopping List",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 1,
                            color: Colors.green,
                          ),
                          for (var product in widget.shoppingList)
                            Card(
                              color: Colors.green[100],
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: ListTile(
                                leading: Image.network(product.image),
                                title: Text(product.title),
                                onTap: () {},
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ),
        child: Icon(Icons.list),
      ),
    );
  }
}
