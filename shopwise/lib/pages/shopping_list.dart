import 'package:flutter/material.dart';

class ShoppingList extends StatefulWidget {
  static const String routeName = '/shoppingList';
  ShoppingList({super.key});
  final List<String> shoppingList = <String>[];

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
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
                    title: Text(widget.shoppingList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? newItem =
              await Navigator.pushNamed(context, '/addItem');
          if (newItem != null) {
            setState(() {
              widget.shoppingList.add(newItem);
            });
          }
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
