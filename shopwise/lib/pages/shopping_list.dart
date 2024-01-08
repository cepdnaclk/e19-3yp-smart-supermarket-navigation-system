import 'package:flutter/material.dart';
import 'package:shopwise/models/product.dart';
import 'package:shopwise/pages/select_items.dart';
import 'package:shopwise/services/mongodb_service.dart';
import 'package:shopwise/widgets/added_item.dart';

class ShoppingList extends StatefulWidget {
  static const String routeName = '/shoppingList';
  ShoppingList({super.key});
  final List<Product> shoppingList = <Product>[];

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.shoppingList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                      background: Container(
                        color: Colors.red.shade300,
                      ),
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          widget.shoppingList.removeAt(index);
                        });
                      },
                      child: AddedItem(
                        product: widget.shoppingList[index],
                        theList: widget.shoppingList,
                      ));
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                key: ValueKey("Add item"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // background
                    foregroundColor: Colors.white // foreground
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
                    MongoDB_Service.initiateConnection();
                    MongoDB_Service.insertData("products", {"title": "test"});
                    MongoDB_Service.closeConnection();

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
                child: Text("Add Item"),
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
