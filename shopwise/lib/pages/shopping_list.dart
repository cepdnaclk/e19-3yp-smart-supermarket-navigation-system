import 'package:flutter/material.dart';
import 'package:shopwise/models/product.dart';
import 'package:shopwise/pages/select_items.dart';

class ShoppingList extends StatefulWidget {
  static const String routeName = '/shoppingList';
  ShoppingList({super.key});
  final List<Product> shoppingList = <Product>[];

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
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
                  return ListTile(
                    title: Text(widget.shoppingList[index].title),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final Future<dynamic?> item =
                    Navigator.pushNamed(context, SelectItems.routeName, arguments: {'shoppingList':widget.shoppingList});
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
                    setState(() {
                        
                    });
                  }

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
