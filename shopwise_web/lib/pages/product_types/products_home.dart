import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopwise_web/pages/product_types/additem_popup.dart';
import 'package:shopwise_web/pages/product_types/product_tables.dart';

class ProductsHome extends StatefulWidget {
  const ProductsHome({super.key});

  @override
  State<ProductsHome> createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  int tableIndex = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String>? categories = [
    'Produce',
    'Meat',
    'Beverages',
    'Bakery',
    'Diary',
    'snacks',
    'frozen',
  ];

  Future<List<Map<String, dynamic>>> getProducts() async {
    QuerySnapshot querySnapshot = await firestore.collection('products').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Center(
                    child: Column(
                      children: [
                        DataTable(
                          columns: [
                            DataColumn(
                                label: Container(
                                  width: 200,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Product Id",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                numeric: true),
                            DataColumn(
                                label: Container(
                                    width: 200,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Name",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )),
                                numeric: true),
                            DataColumn(
                              label: Container(
                                width: 200,
                                alignment: Alignment.center,
                                child: const Text(
                                  "Placed Cell",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              numeric: true,
                            ),
                            DataColumn(
                                label: Container(
                                    width: 200,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Promotion cell",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )),
                                numeric: true),
                            DataColumn(
                              label: Container(
                                  width: 200,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Price",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              numeric: true,
                            )
                          ],
                          rows: snapshot.data!.map((product) {
                            return DataRow(cells: [
                              DataCell(Container(alignment: Alignment.center,width: 200, child: Text(product['id'].toString()))),
                              DataCell(Container(alignment: Alignment.center,width: 200, child: Text(product['title']))),
                              DataCell(Container(alignment: Alignment.center,width: 200, child: Text(product['cell']))),
                              DataCell(Container(alignment: Alignment.center,width: 200, child: Text(product['promotion'].toString()))),
                              DataCell(Container(alignment: Alignment.center,width: 200, child: Text(product['price'].toString()))),
                            ]);
                          }).toList(),
                          columnSpacing: 20,
                          horizontalMargin: 20,
                          showBottomBorder: true,
                          dataRowColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 220, 240, 223)),
                          dividerThickness: 2,
                          headingRowHeight: 50,
                          headingRowColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 220, 240, 223)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
