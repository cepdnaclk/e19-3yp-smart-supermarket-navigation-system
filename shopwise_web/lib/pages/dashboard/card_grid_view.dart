import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/product_placement/database_manager.dart';

class CardGridView extends StatefulWidget {
  CardGridView({Key? key}) : super(key: key);

  @override
  _CardGridViewState createState() => _CardGridViewState();
}

class _CardGridViewState extends State<CardGridView> {
  final int cardCount = 3;
  final int crossAxisCountLarge = 3;
  final int crossAxisCountSmall = 2;
  final double width = 50;
  final double height = 50;

  late Future<List> futureData;

  @override
  void initState() {
    super.initState();
    futureData = FireStoreDataBase().getData();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print(screenSize.width);

    return FutureBuilder<List>(
      future: Future.wait([
        FireStoreDataBase().getData(),
        FireStoreDataBase().getOrderData(),
        FireStoreDataBase().getCustomerData(),
      ]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or some other widget
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List products = snapshot.data![0];
          List orders = snapshot.data![1];
          List customers = snapshot.data![2];
          debugPrint(products.toString());
          /* int totalUsers = products.fold(
              0, (sum, item) => sum + ((item['users'] ?? 0) as int)); */
          // int totalSales = products.fold(0, (sum, item) => sum + item['sales']);

          Map detailsDict = {
            0: {
              // "title": totalUsers.toString(),
              "title": customers.length.toString(),
              "subtitle": "Total Customers",
              "icon": Icons.person,
              "cardColor": const Color.fromARGB(255, 248, 237, 142),
            },
            /* 1: {
              "title": "8000",
              "subtitle": "Total Sales",
              "icon": Icons.shopping_bag,
              "cardColor": const Color.fromARGB(255, 172, 208, 237),
            }, */
            1: {
              "title": products.length.toString(),
              "subtitle": "Total Products",
              "icon": Icons.shopping_cart,
              "cardColor": const Color.fromARGB(255, 237, 172, 172),
            },
            2: {
              "title": orders.length.toString(),
              "subtitle": "Total Orders",
              "icon": Icons.shopping_basket,
              "cardColor": const Color.fromARGB(255, 172, 237, 172),
            },
            // Add more cards here...
          };

          return GridView.builder(
            gridDelegate: (screenSize.width < 550)
                ? SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCountSmall,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: screenSize.width * 0.05,
                  )
                : (screenSize.width > 970)
                    ? SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCountLarge,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: screenSize.width * 0.08,
                      )
                    : SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: screenSize.width * 0.08,
                      ),
            itemCount: cardCount,
            itemBuilder: (context, index) {
              /* if (!detailsDict.containsKey(index)) {
                return Container(); // Return an empty container or a placeholder for missing data
              } */
              return Card(
                elevation: 0,
                color: detailsDict[index]["cardColor"] ?? Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: ListTile(
                    leading: Icon(
                      detailsDict[index]["icon"],
                      size: 30,
                    ),
                    subtitle: Text(
                      detailsDict[index]["title"],
                      style: const TextStyle(fontSize: 20),
                    ),
                    title: Text(
                      detailsDict[index]["subtitle"],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
