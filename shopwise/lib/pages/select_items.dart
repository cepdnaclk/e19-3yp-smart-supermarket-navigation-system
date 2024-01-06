import 'package:flutter/material.dart';

class SelectItems extends StatefulWidget {
  static const String routeName = '/selectItem';
  SelectItems({super.key});

  final List<String> itemList = <String>["Item1", "item2"];

  @override
  State<SelectItems> createState() => _SelectItemsState();
}

class _SelectItemsState extends State<SelectItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Items'),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.itemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () => Navigator.pop(
                          context, widget.itemList[index].toString()),
                      title: Text(widget.itemList[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
