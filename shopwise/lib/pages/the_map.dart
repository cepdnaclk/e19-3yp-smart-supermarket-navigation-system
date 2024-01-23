import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

import 'package:shopwise/pages/pixel.dart';
import 'package:shopwise/pages/player.dart';
import 'package:shopwise/pages/product.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class TheMap extends StatefulWidget {
  final Stream<String> directionStream;

  TheMap({Key? key, required this.directionStream}) : super(key: key);

  @override
  _TheMapState createState() => _TheMapState();
}

class _TheMapState extends State<TheMap> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 19;

  //palyer position
  int player = 168;

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
    104
  ];

  List<int> products = [147, 115];

  List<int> promotions = [125];

  String _scanBarcodeResult = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.directionStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          // Update the class-level player variable directly
          player = int.parse(snapshot.data ?? '0');
          // You can call movePlayer here if you need additional logic
        }

        return Expanded(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInRow,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (player == index) {
                      if (promotions.contains(index - 1) ||
                          promotions.contains(index + 1)) {
                        print("Hi");
                        final snackBar = SnackBar(
                          /// need to set following properties for best effect of awesome_snackbar_content
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Promotion Alert!',
                            message: '25% off',

                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                            contentType: ContentType.success,
                          ),
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      }
                      return Container(
                        color: Colors
                            .grey, // Replace with your desired background color
                        child: MyPlayer(),
                      );
                    } else if (products.contains(index)) {
                      //listing the shopping list numbers
                      return MyPixel(
                        color: Colors.green,
                        child: Text((products.indexOf(index) + 1).toString()),
                      );
                    } else if (barriers.contains(index)) {
                      return MyPixel(
                        color: Colors.blue[700],
                        child: Text(index.toString()),
                      );
                    } else {
                      return MyPixel(
                        color: Colors.grey,
                        child: Text(index.toString()),
                      );
                    }
                  },
                ),
              ),

              /////////////////////////Mapping ends here!/////////////////////////

               Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: ElevatedButton(
                                  onPressed: scanBarcode,
                                  child: Text('Scan Item'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Finish Shopping'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text("Barcode Result : $_scanBarcodeResult",
                            style: TextStyle(fontSize: 20, color: Colors.black)),
                      ],
                    ),
                  ),
                ), 
            ],
          ),
        );
      },
    );
  }

  void scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on Exception {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      _scanBarcodeResult = barcodeScanRes;
    });
  }
}
