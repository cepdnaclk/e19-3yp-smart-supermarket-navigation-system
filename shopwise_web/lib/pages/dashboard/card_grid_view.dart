import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/product_placement/database_manager.dart';

class CardGridView extends StatefulWidget {
  const CardGridView({super.key});

  @override
  _CardGridViewState createState() => _CardGridViewState();
}

class _CardGridViewState extends State<CardGridView> {
  final int cardCount = 3;
  final int crossAxisCountLarge = 3;
  final int crossAxisCountSmall = 2;
  final double width = 50;
  final double height = 50;

  late Future<List> futureData;

  @override
  void initState() {
    super.initState();
    futureData = FireStoreDataBase().getData();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    String currentSize;
    if (screenSize.width < 575) {
      currentSize = 'small';
    } else if (screenSize.width > 575 && screenSize.width < 790) {
      currentSize = "medium";
    } else {
      currentSize = "large";
    }

    print(screenSize.width);

    return FutureBuilder<List>(
      future: Future.wait([
        FireStoreDataBase().getData(),
        FireStoreDataBase().getOrderData(),
        FireStoreDataBase().getCustomerData(),
      ]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              alignment: Alignment.center,
              height: 50,
              child: const CircularProgressIndicator()); // or some other widget
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List products = snapshot.data![0];
          List orders = snapshot.data![1];
          List customers = snapshot.data![2];
          debugPrint(products.toString());
          /* int totalUsers = products.fold(
              0, (sum, item) => sum + ((item['users'] ?? 0) as int)); */
          // int totalSales = products.fold(0, (sum, item) => sum + item['sales']);

          Map detailsDict = {
            0: {
              // "title": totalUsers.toString(),
              "title": customers.length.toString(),
              "subtitle": "Total Customers",
              "icon": Icons.person,
              "cardColor": const Color.fromARGB(255, 248, 237, 142),
            },
            /* 1: {
              "title": "8000",
              "subtitle": "Total Sales",
              "icon": Icons.shopping_bag,
              "cardColor": const Color.fromARGB(255, 172, 208, 237),
            }, */
            1: {
              "title": products.length.toString(),
              "subtitle": "Total Products",
              "icon": Icons.shopping_cart,
              "cardColor": const Color.fromARGB(255, 237, 172, 172),
            },
            2: {
              "title": orders.length.toString(),
              "subtitle": "Total Orders",
              "icon": Icons.shopping_basket,
              "cardColor": const Color.fromARGB(255, 172, 237, 172),
            },
            // Add more cards here...
          };

          return Expanded(
            child: GridView.builder(
              gridDelegate: (currentSize == 'small')
                  ? SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCountSmall,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: screenSize.width * 0.05,
                    )
                  : (currentSize == 'large')
                      ? SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCountLarge,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: screenSize.width * 0.09,
                        )
                      : SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: screenSize.width * 0.065,
                        ),
              itemCount: cardCount,
              itemBuilder: (context, index) {
                /* if (!detailsDict.containsKey(index)) {
                  return Container(); // Return an empty container or a placeholder for missing data
                } */
                return Card(
                  elevation: 0,
                  color: detailsDict[index]["cardColor"] ?? Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: ListTile(
                      leading: Icon(
                        detailsDict[index]["icon"],
                        size: 30,
                      ),
                      subtitle: Text(
                        detailsDict[index]["title"],
                        style: TextStyle(
                            fontSize: currentSize == 'large' ? 22 : 20),
                      ),
                      title: Text(
                        detailsDict[index]["subtitle"],
                        style: TextStyle(
                            fontSize: currentSize == 'large' ? 16 : 13),
                      ),
                      trailing: index == 1
                          ? ElevatedButton(
                              onPressed: () {
                                // Add your button press logic here
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    TextEditingController
                                        _textFieldController1 =
                                        TextEditingController();
                                    TextEditingController
                                        _textFieldController2 =
                                        TextEditingController();
                                    TextEditingController
                                        _textFieldController3 =
                                        TextEditingController();
                                    TextEditingController
                                        _textFieldController4 =
                                        TextEditingController();
                                    TextEditingController
                                        _textFieldController5 =
                                        TextEditingController();

                                    return Dialog(
                                      child: Container(
                                        width: 350, // Set your desired width
                                        height: 450, // Set your desired height
                                        child: SingleChildScrollView(
                                          child: AlertDialog(
                                            title: const Text(
                                              'Add Item',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Color.fromARGB(
                                                      255, 41, 105, 49)),
                                            ),
                                            content: Column(
                                              children: <Widget>[
                                                TextField(
                                                  controller:
                                                      _textFieldController1,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Item Id',
                                                  ),
                                                ),
                                                // const SizedBox(height: 20),
                                                TextField(
                                                  controller:
                                                      _textFieldController2,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Item name',
                                                  ),
                                                ),
                                                TextField(
                                                  controller:
                                                      _textFieldController3,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Description',
                                                  ),
                                                ),
                                                TextField(
                                                  controller:
                                                      _textFieldController4,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Price',
                                                  ),
                                                ),
                                                TextField(
                                                  controller:
                                                      _textFieldController5,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Brand',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 41, 105, 49)),
                                                ),
                                                onPressed: () {
                                                  // Handle the form submission logic here
                                                  // Get a reference to the Firestore collection
                                                  CollectionReference products =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'products');

                                                  // Create a new document with the 'id' as the document ID
                                                  DocumentReference newProduct =
                                                      products.doc(
                                                          _textFieldController1
                                                              .text);

                                                  // Add a new document with the form data and default values
                                                  newProduct.set({
                                                    'id': _textFieldController1
                                                        .text,
                                                    'title':
                                                        _textFieldController2
                                                            .text,
                                                    'description':
                                                        _textFieldController3
                                                            .text,
                                                    'price':
                                                        _textFieldController4
                                                            .text,
                                                    'brand':
                                                        _textFieldController5
                                                            .text,
                                                    'cell': " ",
                                                    'image': "abc",
                                                    'promo_details': "abc",
                                                    'promotion': " ",
                                                    'side': 'left'
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Add Items',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 190, 138, 138),
                              ))
                          : null,
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
