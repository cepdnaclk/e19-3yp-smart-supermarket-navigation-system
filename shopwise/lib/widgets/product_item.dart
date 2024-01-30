import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopwise/models/product.dart';
import 'package:shopwise/providers/shopping_list_provider.dart';

class ProductListItem extends ConsumerStatefulWidget {
  final Product product;
  final List<Product> theList;

  // final String title;
  // final String description;
  // final String price;
  // final String brand;
  // final String imageUrl;
  // Function? onTapAdd;
  ProductListItem({
    super.key,
    required this.product,
    required this.theList,
    // required this.title,
    // required this.description,
    // required this.price,
    // required this.brand,
    // // required this.onTapAdd,
    // required this.imageUrl
  });

  @override
  ConsumerState<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends ConsumerState<ProductListItem> {
  var color = Colors.green;
  var clicked = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Column(children: [
        Expanded(
          child: ListTile(
            // leading: const Image(image: AssetImage("assets/images/coke.jpg")),
            leading: Image.network(widget.product.image, fit: BoxFit.fitHeight),
            title: Text(widget.product.title),
            subtitle: Text(widget.product.description),
            trailing: SizedBox(
              width: 100,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Rs.${widget.product.price}"),
                    Text(widget.product.brand)
                  ]),
            ),
            onTap: () {},
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                "Available",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: clicked
                    ? () {}
                    : () {
                        widget.theList.add(widget.product);

                        print(widget.theList.length);

                        setState(() {
                          ref
                              .read(shoppingListProvider.notifier)
                              .addItem(widget.product);
                          clicked = true;
                        });
                        print(ref.read(shoppingListProvider.notifier).state);
                        // Navigator.pop(context, product);
                      },
                child: clicked ? Text("Added") : Text("Add Item"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: clicked ? Colors.grey : Colors.green,
                    foregroundColor: Colors.black,
                    side: BorderSide(
                        color: clicked ? Colors.grey : Colors.green)),
              ),
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
