import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapGrid extends StatefulWidget {
  const MapGrid({Key? key}) : super(key: key);

  @override
  _MapGridState createState() => _MapGridState();
}

class GridCell {
  int row;
  int column;
  late String id;

  GridCell(this.row, this.column) {
    id = '$row-$column';
  }
}

class _MapGridState extends State<MapGrid> {
  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();

  Map<String, bool> tappedCells = {};

  void _showPopupBox(GridCell cell) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 196, 218, 200),
          title: Text(
            'Cell ${cell.id}',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Add your text fields or any other content here
              TextField(
                controller: _textFieldController1,
                decoration: InputDecoration(
                  labelText: 'Item Id',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textFieldController2,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  tappedCells[cell.id] = true; //if submitted then set to true
                });
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
          crossAxisCount: 10, // Number of cells in each row
        ),
        itemCount: 10 * 10, // Total number of cells in the grid
        itemBuilder: (context, index) {
          final cell = GridCell(index ~/ 10,
              index % 10); // Create a GridCell object for each cell
          tappedCells[cell.id] = false; //set cells false initially

          return GestureDetector(
            onTap: () {
              _showPopupBox(cell);
              // Handle the tap event of the cell
              print('Cell ${cell.id} tapped');
            },
            child: Container(
              decoration: BoxDecoration(
                color: tappedCells[cell.id] == true ? Colors.green : Colors.white.withAlpha(0),
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
}
