import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardGridView extends StatelessWidget {
  final int cardCount = 4;
  final int crossAxisCountLarge = 4;
  final int crossAxisCountSmall = 2;
  final double width = 50;
  final double height = 50;

  CardGridView({super.key});

  Map detailsDict = {
    0: {
      "title": "100",
      "subtitle": "Total Users",
      "icon": Icons.person,
      "cardColor": Color.fromARGB(255, 248, 237, 142),
    },
    1: {
      "title": "8000",
      "subtitle": "Total Sales",
      "icon": Icons.shopping_bag,
      "cardColor": Color.fromARGB(255, 172, 208, 237),
    },
    2: {
      "title": "100",
      "subtitle": "Total Products",
      "icon": Icons.production_quantity_limits,
      "cardColor": Color.fromARGB(255, 246, 186, 182),
    },
    3: {
      "title": "100",
      "subtitle": "Total Categories",
      "icon": Icons.category,
      "cardColor": Color.fromARGB(255, 152, 239, 155),
    },
  };

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print(screenSize.width);

    return GridView.builder(
      gridDelegate: (screenSize.width < 550)
      ? SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCountSmall,
          childAspectRatio: 5 / 3,
          crossAxisSpacing: screenSize.width * 0.05,
        )
      : (screenSize.width > 970)
          ? SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCountLarge,
              childAspectRatio: 5 / 3,
              crossAxisSpacing: screenSize.width * 0.08,
            )
          : SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 5 / 3,
              crossAxisSpacing: screenSize.width * 0.08,
            ),
      itemCount: cardCount,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: detailsDict[index]["cardColor"] ?? Colors.white,
          shape: RoundedRectangleBorder(   
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: ListTile(
              leading: Icon(detailsDict[index]["icon"],size: 30,),
              subtitle: Text(detailsDict[index]["title"],style: TextStyle(fontSize: 20),),
              title: Text(detailsDict[index]["subtitle"],style: TextStyle(fontSize: 15),),
            ),
          ),
        );
      },
    );
  }
}
