import 'package:flutter/material.dart';
import 'package:shopwise/widgets/product_item.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Products List"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [ProductListItem()],
              ),
            )
          ],
        ));
  }
}
