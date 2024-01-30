import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shopwise/models/product.dart';
import 'package:shopwise/pages/scan_barcode_view.dart';
import 'package:shopwise/pages/scan_qrcode_page.dart';
import 'package:shopwise/pages/select_items.dart';
import 'package:shopwise/providers/customer_provider.dart';
import 'package:shopwise/providers/shopping_list_provider.dart';
import 'package:shopwise/services/fetch_shoppinglist_products.dart';
import 'package:shopwise/services/mongodb_service.dart';
import 'package:shopwise/widgets/added_item.dart';

class ShoppingList extends ConsumerStatefulWidget {
  static const String routeName = '/shoppingList';
  ShoppingList({super.key});
  List<Product> shoppingList = <Product>[];

  @override
  ConsumerState<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends ConsumerState<ShoppingList> {
// Need to fetch the ids of the productList from the database if the shoppingList is empty

  @override
  void initState() {
    // TODO: implement initState
    fetchthelist();
    super.initState();
  }

  List<Product> callback(List<Product> list) {
    print("callback..........");
    print("list.length: ${list.length}");
    setState(() {
      widget.shoppingList = list;
    });
    return widget.shoppingList;
  }

  void fetchthelist() {
    print("fetchthelist..........");
    ShoppingListFetcher shoppingListFetcher = ShoppingListFetcher(
        email: ref.read(customerNotifierProvider.notifier).getEmail());

    shoppingListFetcher.fetchCustomersShoppingList(callback);

    // setState(() {
    //   widget.shoppingList = shoppingListFetcher.fetchCustomersShoppingList(callback);
    // });

    print("widget.shoppingList.length: ${widget.shoppingList.length}");
  }

//   void fetchCustomersShoppingList() {
//     final productsCollection =
//         FirebaseFirestore.instance.collection('products');
//         List<Product> tempRelatedProducts = [];
//     List<String> productIds;
//     List<QueryDocumentSnapshot<Map<String, dynamic>>> relatedProducts;
//     String currentEmail =
//         ref.read(customerNotifierProvider.notifier).getEmail();
//     final ordersCollection = FirebaseFirestore.instance.collection('orders');
//     List<QueryDocumentSnapshot<Map<String, dynamic>>> emailRelatedOrdersList;
//     ordersCollection.get().then((value) => {
//           print("value.docs.length..............: ${value.docs.length}"),
//           print(
//             value.docs.map(
//               (e) => e.data(),
//             ),
//           ),
//           emailRelatedOrdersList = value.docs
//               .where((e) => e.data()['email'] == currentEmail)
//               .toList(),

//           if (emailRelatedOrdersList.isNotEmpty)
//             {
//               print("emailRelatedOrdersList: ${emailRelatedOrdersList}"),
//               print("that data inside that" +
//                   emailRelatedOrdersList[0].data().toString()),
//               print(
//                   "The products list ${emailRelatedOrdersList[0].data()['products']}"),
//               productIds =
//                   (emailRelatedOrdersList[0].data()['products'] as List).map((e) => e.toString()).toList(),

//               // Need to fetch the products from the database using the product ids
//               productsCollection.get().then((value) => {
//                     print(
//                         "value.docs.length..............: ${value.docs.length}"),
//                     relatedProducts = value.docs
//                         .where((element) => productIds.contains(element.id))
//                         .toList(),
//                     print("relatedProducts: ${relatedProducts}"),

// // Create a Product object for each in relatedProducts
//                     relatedProducts.forEach((element) {
//                       Product product = Product(
//                         title: element.data()['title'],
//                         image: element.data()['image'],
//                         price: element.data()['price'],
//                         description: element.data()['description'],
//                         brand: element.data()['brand'],
//                         promo_details: element.data()['promo_details'],
//                         cell: element.data()['cell'],
//                         promotion: element.data()['promotion'],
//                         id: element.id,
//                       );
//                       tempRelatedProducts.add(product);
//                     }),

//                     setState(() {
//                       widget.shoppingList = tempRelatedProducts;
//                     }),

//                   }),

//             }
//           //   // Need to expand the emailRelatedOrdersList to get the product ids
//           //   // Need to fetch the products from the database using the product ids
//           //   // Need to add the products to the shoppingList
//           //   // List<String> productIds = emailRelatedOrdersList[0].data()['products'].toList() as List<String>,
//           // }
//         });
//   }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // Implement list save to MONGO DB
  }

  void addItem(Product product) {
    widget.shoppingList.add(product);
  }

  @override
  Widget build(BuildContext context) {
    final ordersCollection = FirebaseFirestore.instance.collection('orders');
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "logo",
          child: Text('Shopping List'),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget.shoppingList.length == 0
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Text(
                        "No items added",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: widget.shoppingList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            background: Container(
                              color: Colors.red,
                            ),
                            key: UniqueKey(),
                            onDismissed: (DismissDirection direction) {
                              ref
                                  .read(shoppingListProvider.notifier)
                                  .removeItem(
                                      widget.shoppingList[index],
                                      ref
                                          .read(
                                              customerNotifierProvider.notifier)
                                          .getEmail());
                              setState(() {
                                widget.shoppingList.removeAt(index);
                              });
                            },
                            child: AddedItem(
                              product: widget.shoppingList[index],
                              // theList: widget.shoppingList,
                            ));
                      },
                    ),
                  ),
            Hero(
              tag: "outlinedButton",
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlinedButton(
                  key: ValueKey("Add item"),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.0, color: Colors.green),
                      // backgroundColor: Colors.green, // background
                      foregroundColor: Colors.green // foreground
                      ),
                  onPressed: () {
                    final Future<dynamic?> item = Navigator.pushNamed(
                        context, SelectItems.routeName,
                        arguments: {'shoppingList': widget.shoppingList});
                    item.then((result) {
                      if (result is Product) {
                        Product theProduct = result;
                        setState(() {
                          widget.shoppingList.add(theProduct);
                        });
                        print(result != null ? result.title : "No result");
                      } else {
                        print("Not a product");
                        print(widget.shoppingList.length);
                        setState(() {});
                      }
                      // MongoDB_Service.initiateConnection();
                      // MongoDB_Service.insertData("products", {"title": "test"});
                      // MongoDB_Service.closeConnection();
            
                      // if (result != null && result is Product) {
                      //   String newItem = result;
                      //   // Do something with the newItem string here
                      //   setState(() {
                      //     widget.shoppingList.add(newItem);
                      //   });
                      //   print(newItem);
                      // }
                    });
                    print(item);
                  },
                  child: Text(
                    "Add Item",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Hero(
              tag: "greenButton",
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // background
                      foregroundColor: Colors.white // foreground
                      ),
                  onPressed: () => {
                    if (widget.shoppingList.length > 0)
                      {
                        // ref
                        //     .read(customerNotifierProvider.notifier)
                        //     .updateOrderId("5"),
                        // ordersCollection.add({
                        //   'id': '5',
                        //   'products': widget.shoppingList
                        //       .map((element) => element.id)
                        //       .toList()
                        // }),
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScanBarcode(),
                          ),
                        )
                      }
                    else
                      {
                        Fluttertoast.cancel(),
                        Fluttertoast.showToast(
                            msg:
                                "Please add atleast one item to your shopping list",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity
                                .TOP, // Change this to ToastGravity.BOTTOM for a bottom toast
                            timeInSecForIosWeb: 1,
                            // webBgColor: Colors.red,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0),
                      }
                  },
                  child: Text(
                    "Start Navigation",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final String? newItem =
      //         await Navigator.pushNamed(context, SelectItems.routeName);
      //     if (newItem != null) {
      //       setState(() {
      //         widget.shoppingList.add(newItem);
      //       });
      //     }
      //   },
      //   tooltip: 'Add Item',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
