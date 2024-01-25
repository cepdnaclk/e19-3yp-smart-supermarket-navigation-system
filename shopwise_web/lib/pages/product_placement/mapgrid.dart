import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MapGrid extends StatefulWidget {
  const MapGrid({super.key});

  @override
  _MapGridState createState() => _MapGridState();
}

class GridCell {
  int row;
  int column;
  late String id;

  GridCell(this.row, this.column) {
    id = '${11 * row + column}';
  }
}

class _MapGridState extends State<MapGrid> {
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();

  Map<String, bool> tappedCells = {};

  void _showPopupBox(GridCell cell) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 196, 218, 200),
          title: Text(
            'Cell ${cell.id}',
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Add your text fields or any other content here
              TextField(
                controller: _textFieldController1,
                decoration: const InputDecoration(
                  labelText: 'Item Id',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                String productId = _textFieldController1.text;

                setState(() {
                  tappedCells[cell.id] = true; //if submitted then set to true
                });
                updateCell(productId, cell.id);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  List<int> barriers = [176,165,154,143,132,121,110,99,100,111,122,133,144,155,166,177,179,168,157,146,135,124,113,102,103,114,125,136,147,158,169,180,182,171,160,149,138,127,116,105,106,117,128,139,150,161,172,183,185,174,163,152,141,130,119,108,109,120,131,142,153,164,175,186,77,66,55,44,33,22,11,12,23,34,45,56,67,78,80,69,58,47,36,25,14,15,26,37,48,59,70,81,83,72,61,50,39,28,17,18,29,40,51,62,73,84,86,75,64,53,42,31,20,21,32,43,54,65,76,87];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black12,
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 11, // Number of cells in each row
        ),
        itemCount: 11 * 19, // Total number of cells in the grid
        itemBuilder: (context, index) {
          final cell = GridCell(index ~/ 11,
              index % 11); // Create a GridCell object for each cell

          if (barriers.contains(index)) {}

          tappedCells[cell.id] = false; //set cells false initially

          return GestureDetector(
            onTap: () {
              _showPopupBox(cell);
              // Handle the tap event of the cell
              print('Cell ${cell.id} tapped');
            },
            child: Container(
              decoration: BoxDecoration(
                color: barriers.contains(index)
                    ? Colors.blue
                    : (tappedCells[cell.id] == true
                        ? Colors.green
                        : Colors.white.withAlpha(0)),
                border:
                    Border.all(color: Colors.grey), // Border color of each cell
              ),
              child: Center(
                child: Text(
                  cell.id, // Display the cell's unique identifier
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void updateCell(String productId, String cellNumber) {
    FirebaseFirestore.instance.collection('products').doc(productId).update({
      'cell': cellNumber,
    });
  }
}
