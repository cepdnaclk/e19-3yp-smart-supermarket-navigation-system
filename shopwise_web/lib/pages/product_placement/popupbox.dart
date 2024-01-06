import 'package:flutter/material.dart';

class PopUpBox extends StatefulWidget {
  @override
  _PopUpBoxState createState() => _PopUpBoxState();
}

class _PopUpBoxState extends State<PopUpBox> {
  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();

  void _showPopupBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Popup Box'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _textFieldController1,
                decoration: InputDecoration(
                  labelText: 'Field 1',
                ),
              ),
              TextField(
                controller: _textFieldController2,
                decoration: InputDecoration(
                  labelText: 'Field 2',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform any desired actions with the text field values
                String fieldValue1 = _textFieldController1.text;
                String fieldValue2 = _textFieldController2.text;
                print('Field 1: $fieldValue1');
                print('Field 2: $fieldValue2');

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Center(
        child: ElevatedButton(
          onPressed: _showPopupBox,
          child: Text('Open Popup Box'),
        ),
      ),
    );
  }
}