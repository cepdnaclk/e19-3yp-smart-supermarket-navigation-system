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
              const SizedBox(height: 20),
              TextField(
                controller: _textFieldController2,
                decoration: const InputDecoration(
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

  List<int> barriers = [
    158,
    159,
    147,
    148,
    136,
    137,
    125,
    126,
    114,
    115,
    103,
    104,
    154,
    143,
    132,
    121,
    110,
    99,
    108,
    119,
    130,
    141,
    152,
    163,
    57,
    58,
    59,
    60,
    61,
    62,
    63,
    46,
    47,
    48,
    49,
    50,
    51,
    52,
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    12,
    23,
    20,
    31
  ];

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
}
