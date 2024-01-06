import 'package:flutter/material.dart';

class SelectItems extends StatefulWidget {
   SelectItems({super.key});

  final List<String> itemList = <String>["Item1", "item2"];

  @override
  State<SelectItems> createState() => _SelectItemsState();
}

class _SelectItemsState extends State<SelectItems> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}