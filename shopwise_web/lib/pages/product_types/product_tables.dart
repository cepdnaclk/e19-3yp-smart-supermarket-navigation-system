import 'package:flutter/material.dart';


class ProduceTable extends StatefulWidget {
  final int index;

  const ProduceTable({super.key, required this.index});

  @override
  State<ProduceTable> createState() => _ProduceTableState();
}

class _ProduceTableState extends State<ProduceTable> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          DataTable(
            columns: [
              DataColumn(
                  label: Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: const Text(
                      "Product Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  numeric: true),
              DataColumn(
                  label: Container(
                      width: 200,
                      alignment: Alignment.center,
                      child: const Text(
                        "Category",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  numeric: true),
              DataColumn(
                label: Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: const Text(
                    "Barcode",
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
                        "Quantity",
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
            rows: ProductsTableDataSource().getRows(widget.index),
            columnSpacing: 20,
            horizontalMargin: 20,
            showBottomBorder: true,
            dataRowColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 220, 240, 223)),
            dividerThickness: 2,
            headingRowHeight: 50,
            headingRowColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 220, 240, 223)),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          ),
        ],
      ),
    );
  }
}

class ProductsTableDataSource extends DataTableSource {
  List<Product> products = [];

  final List<Product> produces = [
    Product(1, "Apple", "12345", 100, 100.00),
    Product(2, "Banana", "12346", 100, 100.00),
    Product(3, "Orange", "12347", 100, 100.00),
    Product(4, "Grapes", "12348", 100, 100.00),
  ];

  final List<Product> meats = [
    Product(5, "Beef", "12349", 100, 100.00),
    Product(6, "Chicken", "12350", 100, 100.00),
    Product(7, "Pork", "12351", 100, 100.00),
    Product(8, "Lamb", "12352", 100, 100.00),
  ];

  List<DataRow> getRows(int index) {
    switch (index) {
    case 0:
      products.addAll(produces);
      break;
    case 1:
      products.addAll(meats);
      break;
    default:
      products.addAll(produces);
      break;
    }


    return products.map((product) {
      return DataRow(cells: [
        DataCell(Container(
            alignment: Alignment.center,
            width: 200,
            child: Text(product.itemId.toString()))),
        DataCell(Container(
            alignment: Alignment.center,
            width: 200,
            child: Text(product.itemName))),
        DataCell(Container(
            alignment: Alignment.center,
            width: 200,
            child: Text(product.barcode))),
        DataCell(Container(
            alignment: Alignment.center,
            width: 200,
            child: Text(product.quantity.toString()))),
        DataCell(Container(
            alignment: Alignment.center,
            width: 200,
            child: Text(product.unitPrice.toString()))),
      ]);
    }).toList();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= rowCount) {
      return null; // Return null if the index is out of range
    }
    final product = products[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(product.itemId.toString())),
        DataCell(Text(product.itemName)),
        DataCell(Text(product.barcode)),
        DataCell(Text(product.quantity.toString())),
        DataCell(Text(product.unitPrice.toString())),
      ],
    );
  }


  
  @override
  int get rowCount => products.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

class Product {
  int itemId;
  String itemName;
  String barcode;
  int quantity;
  double unitPrice;

  Product(
    this.itemId,
    this.itemName,
    this.barcode,
    this.quantity,
    this.unitPrice,
  );
}
