import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(children: [
        Expanded(
          child: ListTile(
            leading: const Image(image: AssetImage("assets/images/coke.jpg")),
            title: const Text("Coke"),
            subtitle: const Text("small bottle"),
            trailing: const SizedBox(
              width: 100,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Text("Rs.100.00"), Text("x1")]),
            ),
            onTap: () {},
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 70,
            ),
            Text(
              "Added",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 100,
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete_outline)),
            IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
            Text("1"),
            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          ],
        )
      ]),
    );
  }
}
