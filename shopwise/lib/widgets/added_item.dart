import 'package:flutter/material.dart';
import 'package:shopwise/models/product.dart';

class AddedItem extends StatelessWidget {
  final Product product;

  // final String title;
  // final String description;
  // final String price;
  // final String brand;
  // final String imageUrl;
  // Function? onTapAdd;
  AddedItem({
    super.key,
    required this.product,
    // required this.title,
    // required this.description,
    // required this.price,
    // required this.brand,
    // // required this.onTapAdd,
    // required this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Column(children: [
        Expanded(
          child: ListTile(
            // leading: const Image(image: AssetImage("assets/images/coke.jpg")),
            leading: Image.network(product.image, fit: BoxFit.fitHeight),
            title: Text(product.title),
            subtitle: Text(product.description),
            trailing: const SizedBox(
              width: 100,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Text("Rs.100.00"), Text("Anchor")]),
            ),
            onTap: () {},
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Available",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context, product);
              },
              child: const Text("Add Item"),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: BorderSide(color: Colors.green)),
            ),
            // SizedBox(
            //   width: 2
            // ),
            // const SizedBox(width: 100),
            // IconButton(onPressed: () {}, icon: Icon(Icons.delete_outline)),
            // IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
            // Text("1"),
            // IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          ],
        )
      ]),
    );
  }
}
