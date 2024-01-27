import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopwise/models/product.dart';
import 'package:shopwise/providers/customer_provider.dart';
import 'package:shopwise/providers/shopping_list_provider.dart';
import 'package:shopwise/widgets/new_product.dart';
import 'package:shopwise/widgets/product_item.dart';

class SelectItems extends ConsumerStatefulWidget {
  static const String routeName = '/selectItem';
  SelectItems({super.key});

  List<Product> addedItems = [];

  List<Product> itemList = <Product>[];
  // final List<Product> itemList = <Product>[
  //   Product(
  //       title: "Milk powder",
  //       image:
  //           "https://www.jungle.lk/wp-content/uploads/2021/07/Anchor-Full-Cream-Milk-Powder-400g.jpg",
  //       price: "100",
  //       description: "small one",
  //       brand: "Anchor",
  //       id: "1"),
  //   Product(
  //       title: "Sugar",
  //       image:
  //           "https://5.imimg.com/data5/YD/DJ/MY-70422967/skyplus-sugar-500x500.jpg",
  //       price: "100",
  //       description: "small one",
  //       brand: "Shy Plus",
  //       id: "2"),
  // ];

  @override
  ConsumerState<SelectItems> createState() => _SelectItemsState();
}

class _SelectItemsState extends ConsumerState<SelectItems> {
  void fetchProducts() async {
    final List<Product> tempList = <Product>[];
    CollectionReference collection =
        FirebaseFirestore.instance.collection('products');
    QuerySnapshot<Object?> querySnapshot = await collection.get();

    // final List<Map<String, dynamic>> allData = querySnapshot.docs
    //     .map((doc) => doc.data())
    //     .where((data) => data != null)
    //     .toList() as List<Map<String, dynamic>>;

    for (QueryDocumentSnapshot<Object?> documentSnapshot
        in querySnapshot.docs) {
      String id = documentSnapshot.id;
      String title = documentSnapshot['title'] as String;
      String image = documentSnapshot['image'] as String;
      String price = documentSnapshot['price'] as String;
      String description = documentSnapshot['description'] as String;
      String brand = documentSnapshot['brand'] as String;
      String promo_details = documentSnapshot['promo_details'] as String;
      String cell = documentSnapshot['cell'] as String;
      String promotion = documentSnapshot['promotion'] as String;

      Product product = Product(
        title: title,
        image: image,
        price: price,
        description: description,
        brand: brand,
        promo_details: promo_details,
        cell: cell,
        promotion: promotion,
        id: id,
      );

      tempList.add(product);

      print("id: $id");
      print("title..............: $title");
    }
    // widget.itemList.addAll(
    //   querySnapshot..map(
    //     (product) => Product(
    //       title: product['title'],
    //       image: product['image'],
    //       price: product['price'],
    //       description: product['description'],
    //       brand: product['brand'],
    //       promo_details: product['promo_details'],
    //       cell: product['cell'],
    //       promotion: product['promotion'],
    //       id: product['id'],
    //     ),
    //   ),
    // );
    // print(allData);

    setState(() {
      widget.itemList = tempList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchProducts();
  }

  void addItem(Product item) {
    setState(() {
      widget.addedItems.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final myArguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    List<Product> myShoppingList = myArguments['shoppingList'];

    // myArguments != null ? widget.addedItems = myArguments as List<Product> : null;
    return WillPopScope(
      onWillPop: () async {
        String sub_UUID =
            ref.read(customerNotifierProvider.notifier).getSubUuid();
        String email = ref.read(customerNotifierProvider.notifier).getEmail();
        print("sub_UUID: $sub_UUID");
        ref
            .read(shoppingListProvider.notifier)
            .saveShoppingList(sub_UUID, email);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Select Items'),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.itemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductListItem(
                        product: widget.itemList[index],
                        theList: myArguments['shoppingList'],
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
          )),
    );
  }
}
