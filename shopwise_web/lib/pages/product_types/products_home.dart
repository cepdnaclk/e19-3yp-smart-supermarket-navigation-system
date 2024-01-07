import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/product_types/product_tables.dart';

class ProductsHome extends StatefulWidget {
  const ProductsHome({super.key});

  @override
  State<ProductsHome> createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  int tableIndex = 0;

  List<String> categories = [
    'Produce',
    'Meat',
    'Beverages',
    'Bakery',
    'Diary',
    'snacks',
    'frozen',
    'Health and Beauty',
    'Cleaning',
    'Household',
    'Baby Care',
    'other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              height: 50, // Set a fixed height for the container
              child: createCategoryButtons(categories),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                child: loadTable(
                    tableIndex), //this should load according to the state of the button
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createCategoryButtons(List<String> categories) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: 200,
          height: 60,
          child: TextButton(
            onPressed: () {
              // Handle button press
              setState(() {
                tableIndex = index;
              });
              print('Button pressed for category: ${categories[index]}');
            }, // Pass the onPressed callback to the TextButton
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(204, 149, 211, 160),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              categories[index],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loadTable(int index) {
    switch (index) {
      case 0:
        return const ProduceTable(index : 0);
      case 1:
        return const ProduceTable(index : 1);
      case 2:
        // Perform loading logic for Beverages table
        return const ProduceTable(index : 2);
      default:
        // Handle invalid index
        return const ProduceTable(index: 0);
    }
  }
}

