import 'package:flutter/material.dart';

class AddProductPopup extends StatefulWidget {
  final int index;

  const AddProductPopup({super.key, 
    required this.index,
  });


  @override
  _AddProductPopupState createState() => _AddProductPopupState();
}

class _AddProductPopupState extends State<AddProductPopup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 213, 224, 213),
      title: const Text('Add Product', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
          ),
          TextField(
            controller: barcodeController,
            decoration: const InputDecoration(
              hintText: 'Barcode',
            ),
          ),
          TextField(
            controller: quantityController,
            decoration: const InputDecoration(
              hintText: 'Quantity',
            ),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(
              hintText: 'Price',
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Call the callback function to update the list with the input values
            onAddProduct(
              widget.index,
              nameController.text,
              barcodeController.text,
              int.parse(quantityController.text),
              double.parse(priceController.text),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Add', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  void onAddProduct(int index, String name, String barcode, int quantity, double price) {
    // Add logic to update the database with the input values
    print('Name: $name');
    print('Barcode: $barcode');
    print('Quantity: $quantity');
    print('Price: $price');
  }

  @override
  void dispose() {
    nameController.dispose();
    barcodeController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
