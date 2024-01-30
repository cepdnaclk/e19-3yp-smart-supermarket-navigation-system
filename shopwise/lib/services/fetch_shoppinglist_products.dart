import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopwise/models/product.dart';

class ShoppingListFetcher {
  String currentEmail = "";

  ShoppingListFetcher({required String email}) {
    currentEmail = email;
  }

  List<Product> fetchCustomersShoppingList(
      void Function(List<Product>) callback) {
    final productsCollection =
        FirebaseFirestore.instance.collection('products');
    List<Product> tempRelatedProducts = [];
    List<String> productIds;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> relatedProducts;

    final ordersCollection = FirebaseFirestore.instance.collection('orders');
    List<QueryDocumentSnapshot<Map<String, dynamic>>> emailRelatedOrdersList;
    ordersCollection.get().then((value) => {
          print("value.docs.length..............: ${value.docs.length}"),
          print(
            value.docs.map(
              (e) => e.data(),
            ),
          ),
          emailRelatedOrdersList = value.docs
              .where((e) => e.data()['email'] == currentEmail)
              .toList(),

          if (emailRelatedOrdersList.isNotEmpty)
            {
              print("emailRelatedOrdersList: ${emailRelatedOrdersList}"),
              print("that data inside that" +
                  emailRelatedOrdersList[0].data().toString()),
              print(
                  "The products list ${emailRelatedOrdersList[0].data()['products']}"),
              productIds =
                  (emailRelatedOrdersList[0].data()['products'] as List)
                      .map((e) => e.toString())
                      .toList(),

              // Need to fetch the products from the database using the product ids
              productsCollection.get().then((value) => {
                    print(
                        "value.docs.length..............: ${value.docs.length}"),
                    relatedProducts = value.docs
                        .where((element) => productIds.contains(element.id))
                        .toList(),
                    print("relatedProducts: ${relatedProducts}"),

// Create a Product object for each in relatedProducts
                    relatedProducts.forEach((element) {
                      Product product = Product(
                        title: element.data()['title'],
                        image: element.data()['image'],
                        price: element.data()['price'],
                        description: element.data()['description'],
                        side: element.data()['side'],
                        brand: element.data()['brand'],
                        promo_details: element.data()['promo_details'],
                        cell: element.data()['cell'],
                        promotion: element.data()['promotion'],
                        id: element.id,
                      );
                      tempRelatedProducts.add(product);
                    }),
                    callback(tempRelatedProducts),
                  }),
            }
          //   // Need to expand the emailRelatedOrdersList to get the product ids
          //   // Need to fetch the products from the database using the product ids
          //   // Need to add the products to the shoppingList
          //   // List<String> productIds = emailRelatedOrdersList[0].data()['products'].toList() as List<String>,
          // }
        });
    print("Returning..............");
    print("tempRelatedProducts: ${tempRelatedProducts}");
    return tempRelatedProducts;
  }
}
