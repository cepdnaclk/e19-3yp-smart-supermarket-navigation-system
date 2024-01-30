import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopwise/models/product.dart';

import 'package:shopwise/pages/pixel.dart';
import 'package:shopwise/pages/player.dart';
import 'package:shopwise/pages/product.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shopwise/pages/product_pixel.dart';
import 'package:shopwise/pages/shopping_list.dart';
import 'package:shopwise/pages/the_bill.dart';
import 'package:shopwise/providers/customer_provider.dart';
import 'package:shopwise/services/fetch_shoppinglist_products.dart';
import 'package:shopwise/services/pathfinder.dart';

class TheMap extends ConsumerStatefulWidget {
  final Stream<String> directionStream;
  List<Product> shoppingList = [];

  String glassText = "Tap to Start!";
  int boughtProductIndex = 0;

  int createdCell = 0;

  Map<int, Product> productMap = {};

  TheMap({Key? key, required this.directionStream}) : super(key: key);

  @override
  _TheMapState createState() => _TheMapState();
}

class _TheMapState extends ConsumerState<TheMap> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 19;

  //palyer position
  int player = 178;

  List<int> cell_list = [];
  List<int> idList = [];

  List<int> pathcells = [];

  List<int> barriers = [
    176,
    165,
    154,
    143,
    132,
    121,
    110,
    99,
    100,
    111,
    122,
    133,
    144,
    155,
    166,
    177,
    179,
    168,
    157,
    146,
    135,
    124,
    113,
    102,
    103,
    114,
    125,
    136,
    147,
    158,
    169,
    180,
    182,
    171,
    160,
    149,
    138,
    127,
    116,
    105,
    106,
    117,
    128,
    139,
    150,
    161,
    172,
    183,
    185,
    174,
    163,
    152,
    141,
    130,
    119,
    108,
    109,
    120,
    131,
    142,
    153,
    164,
    175,
    186,
    77,
    66,
    55,
    44,
    33,
    22,
    11,
    12,
    23,
    34,
    45,
    56,
    67,
    78,
    80,
    69,
    58,
    47,
    36,
    25,
    14,
    15,
    26,
    37,
    48,
    59,
    70,
    81,
    83,
    72,
    61,
    50,
    39,
    28,
    17,
    18,
    29,
    40,
    51,
    62,
    73,
    84,
    86,
    75,
    64,
    53,
    42,
    31,
    20,
    21,
    32,
    43,
    54,
    65,
    76,
    87
  ];

  List<int> products = [147, 115];

  int productCount = 0;

  List<int> promotions = [125];

  List<int> locations = [];

  String _scanBarcodeResult = '';

  bool isStarting = true;

  @override
  Widget build(BuildContext context) {
    List<Product> callback(List<Product> list) {
      print("callback..........");
      print("list.length: ${list.length}");
      setState(() {
        widget.shoppingList = list;
      });
      cell_list = widget.shoppingList.map((e) => int.parse(e.cell)).toList();
      print("cell_list: $cell_list");

      idList = widget.shoppingList.map((e) => int.parse(e.id)).toList();

      print("idList: $idList");
      void settingTheDirections() {
        locations = List.from(cell_list);

        widget.shoppingList.asMap().forEach((index, element) {
          var direction = element.side;
          if (direction == "left") {
            setState(() {
              print("left");
              print("locations[index]: ${locations[index]}");
              locations[index] = locations[index] - 1;
              print("locations[index]: ${locations[index]}");
            });
          } else if (direction == "right") {
            setState(() {
              print("right");
              print("locations[index]: ${locations[index]}");
              locations[index] = locations[index] + 1;
              print("locations[index]: ${locations[index]}");
            });
          }
        });
      }

      idList.add(50);
      cell_list.add(192);
      widget.shoppingList.add(Product(
        title: "Exit",
        image:
            "https://t4.ftcdn.net/jpg/03/38/09/99/360_F_338099978_AI1TZ520242U90ucQDuBs9ZUUFW0GIHH.jpg",
        price: "0",
        description: "Exit",
        side: "right",
        brand: "Exit",
        promo_details: "Exit",
        cell: "192",
        promotion: "Exit",
        id: "50",
      ));

      debugPrint("Printing....................");

      debugPrint(idList.toString());
      debugPrint(cell_list.toString());
      debugPrint(widget.shoppingList.toString());
      PathFinder pathFinder =
          PathFinder(shopping_list: idList, cell_list: cell_list);
      settingTheDirections();

      // if (widget.shoppingList.isEmpty) {
      //   _showExitConfirmationDialog(context);
      // }

      setState(() {
        pathcells = pathFinder.findPath();
        products = locations;
      });

      return widget.shoppingList;
    }

    void fetchthelist() {
      print(
          "Fetching the list......................................................................................................");
      ShoppingListFetcher shoppingListFetcher = ShoppingListFetcher(
          email: ref.read(customerNotifierProvider.notifier).getEmail());

      shoppingListFetcher.fetchCustomersShoppingList(callback);
    }

    @override
    initState() {
      fetchthelist();
      super.initState();
    }

    Future<void> fetchData() async {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('orders');
      QuerySnapshot querySnapshot = await collection.get();
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      print(allData);

      // List<Object?> order = allData
      //     .where((element) => element!['id'] == ref
      //         .read(customerNotifierProvider)
      //         .order_id)
      //     .toList();
    }

    List<Product> myProducts = widget.shoppingList;

    widget.productMap = {
      for (var product in myProducts) int.parse(product.cell): product
    };

    return StreamBuilder<String>(
      stream: widget.directionStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        productCount = 0;
        if (snapshot.hasData) {
          // Update the class-level player variable directly
          player = int.parse(snapshot.data ?? '0');
          // You can call movePlayer here if you need additional logic
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.96,
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.95,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: numberOfSquares,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: numberInRow,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          if (player == index) {
                            if (promotions.contains(index - 1) ||
                                promotions.contains(index + 1)) {
                              print("Hi");
                              final snackBar = SnackBar(
                                /// need to set following properties for best effect of awesome_snackbar_content
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Promotion Alert!',
                                  message: '25% off',

                                  /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                  contentType: ContentType.success,
                                ),
                              );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              });
                            }
                            return Container(
                              color: Colors.blue
                                  .shade400, // Replace with your desired background color
                              child: MyPlayer(),
                            );
                          } else if (widget.productMap.containsKey(index - 1)) {
                            print(
                                "the product: ${widget.productMap[index - 1]}");

                            // if (widget.shoppingList[productCount].cell ==
                            //     player.toString()) {
                            //   Future.delayed(Duration(seconds: 2), () {
                            //     // Your code here will execute after a 2 second delay.
                            //   });
                            // }

                            //listing the shopping list numbers
                            return ProductPixel(
                              color: Colors.grey.shade400,
                              child: Image.network(
                                widget.productMap[index - 1]!.image == ""
                                    ? "https://thumbs.dreamstime.com/b/check-mark-icon-circle-isolated-green-background-vector-illustration-eps-111178423.jpg"
                                    : widget.productMap[index - 1]!.image,
                              ),
                              // child: Text((products.indexOf(index) + 1).toString()),
                            );
                          } else if (barriers.contains(index)) {
                            return MyPixel(
                              color: Color.fromARGB(255, 110, 187, 114),
                              child: Text(""),
                              // child: Text(index.toString()),
                            );
                          } else if (pathcells.contains(index)) {
                            return MyPixel(
                              color: Colors.blue.shade400,
                              child: Text(""),
                              // child: Text(index.toString()),
                            );
                          } else if (player == 181) {
                            _showExitConfirmationDialog(context);
                          } else {
                            return MyPixel(
                              color: Colors.grey.shade400,
                              child: Text(""),
                              // child: Text(index.toString()),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              isStarting
                  ? Center(
                      child: GestureDetector(
                        onTap: () => {
                          print("Glass tapped"),
                          fetchthelist(),

                          setState(() {
                            widget.glassText = "Crunching latest...";
                          }),

                          Future.delayed(Duration(seconds: 2), () {
                            // Your code here will execute after a 2 second delay.
                            setState(() {
                              isStarting = false;
                            });
                          }),
                          // setState(
                          //   () {
                          //     isStarting = false;
                          //   },
                          // )
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 300,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.white60, Colors.white10]),
                                borderRadius: BorderRadius.circular(25),
                                border:
                                    Border.all(color: Colors.white30, width: 2),
                              ), // Replace with your desired color
                              child: Center(
                                  child: Text(
                                widget.glassText,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              )),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white]),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: Container(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            // color: Colors.black.withOpacity(0.5),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),

                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.green,
                                  side: BorderSide(
                                    width: 2,
                                    color: Colors.green,
                                  ),
                                  // foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  print(
                                      "Printing order id ........................................");
                                  print("Order Id is: " +
                                      ref
                                          .read(customerNotifierProvider)
                                          .order_id);
                                  fetchData();

                                  scanBarcode();

                                  Future.delayed(Duration(seconds: 2), () {
                                    // Your code here will execute after a 2 second delay.
                                    setState(() {
                                      productCount = 0;
                                      widget
                                          .shoppingList[
                                              widget.boughtProductIndex++]
                                          .image = "";

                                      // productCount = productCount - 1;
                                      // callback(widget.shoppingList);
                                    });
                                  });

                                  // Navigator.pushNamed(context, BarcodeReader.routeName);
                                },
                                child: Text(
                                  "Scan Barcode",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            // color: Colors.black.withOpacity(0.5),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  side: BorderSide(
                                    color: Colors.red,
                                  ),
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  _showExitConfirmationDialog(context);
                                },
                                child: Text("End Shopping")),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on Exception {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      _scanBarcodeResult = barcodeScanRes;
    });
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit Confirmation'),
          content: Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigator.pop will pop the dialog without any action
                Navigator.pop(context);
              },
              child: Text('No', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                // Navigator.pushReplacement will navigate to a new screen
                Navigator.pushReplacementNamed(
                  context,
                  TheBill.routeName,
                );
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
