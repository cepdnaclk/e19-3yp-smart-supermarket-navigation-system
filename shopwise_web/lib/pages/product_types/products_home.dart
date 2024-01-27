import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/product_types/additem_popup.dart';
import 'package:shopwise_web/pages/product_types/product_tables.dart';

class ProductsHome extends StatefulWidget {
  const ProductsHome({super.key});

  @override
  State<ProductsHome> createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  int tableIndex = 0;

  List<String>? categories = [
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
              child: createCategoryButtons(categories!),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection:Axis.horizontal,
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
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: (){
              //open popup box to add new product
              showDialog(context: context, builder: (context) => AddProductPopup(index: tableIndex));
            }, child: const Text('Add New Product',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold))),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget createCategoryButtons(List<String>? categories) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount:  categories!=null? categories.length:0,
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
              
            }, // Pass the onPressed callback to the TextButton
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(204, 149, 211, 160),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              categories != null ? categories[index]:"",
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
        return const ProduceTable(key: Key('produce_table_0'),index : 0);
      case 1:
        return const ProduceTable(key: Key('produce_table_1'),index : 1);
      case 2:
        return const ProduceTable(key: Key('produce_table_2'),index : 2);
      default:
        return const ProduceTable(key: Key('produce_table_0'),index: 0);
    }
  }
}
