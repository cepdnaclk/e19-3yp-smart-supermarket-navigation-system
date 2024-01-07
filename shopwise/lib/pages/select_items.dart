import 'package:flutter/material.dart';
import 'package:shopwise/models/product.dart';
import 'package:shopwise/widgets/new_product.dart';
import 'package:shopwise/widgets/product_item.dart';

class SelectItems extends StatefulWidget {
  static const String routeName = '/selectItem';
  SelectItems({super.key});

  List<Product> addedItems = [];

  final List<Product> itemList = <Product>[
    Product(
        title: "Milk powder",
        image:
            "https://www.jungle.lk/wp-content/uploads/2021/07/Anchor-Full-Cream-Milk-Powder-400g.jpg",
        price: "100",
        description: "small one",
        brand: "Anchor",
        id: "1")
  ];

  @override
  State<SelectItems> createState() => _SelectItemsState();
}

class _SelectItemsState extends State<SelectItems> {

  void addItem(Product item) {
    setState(() {
      widget.addedItems.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final myArguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    List<Product> myShoppingList = myArguments['shoppingList'];

    // myArguments != null ? widget.addedItems = myArguments as List<Product> : null;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Items'),
        ),
        body: Container(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.itemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductListItem(product: widget.itemList[index],
                    theList:  myArguments['shoppingList'],
                        );
                    // return ListTile(
                    //   onTap: () => Navigator.pop(
                    //       context, widget.itemList[index].toString()),
                    //   title: Text(widget.itemList[index].title),
                    // );
                  },
                ),
              ),

              // ProductListItem(), // SocialPictureGroup(
              //     imgUrl: "https://t4.ftcdn.net/jpg/02/47/92/55/360_F_247925567_FcVIHcFpkL6IQjQrZULxnBVtm3dPrtAx.jpg",

              //            title: "Burger",
              //     color: Colors.green,
              //     onTap: () {})
            ],
          ),
        ));
  }
}
