import 'package:flutter/material.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shopwise/pages/mqtt_client_test.dart';

class ScanBarcode extends StatefulWidget {
  ScanBarcode({super.key});
  String _scanBarcodeResult = '-1';

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  void scanBarcode() async {
    String barcodeScanRes = '-1';
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on Exception {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      widget._scanBarcodeResult = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connect with Cart")),
      body: Container(
        height: 800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                      child: Text('Scan', style: TextStyle(fontSize: 25),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 20),
                  // SizedBox(
                  //   width: 120,
                  //   height: 120,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     child: Text('Finish Shopping'),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.green,
                  //       foregroundColor: Colors.white,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Text("QR result : ${widget._scanBarcodeResult != "-1" ? "Success" : "failure"}",
            //     style: TextStyle(fontSize: 20, color: widget._scanBarcodeResult != -1 ? Colors.green : Colors.red)),
            Text("QR: ",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: widget._scanBarcodeResult != -1 ?  () {

                  Navigator.pushNamed(context, MQTTClientTest.routeName);
                } : null,
                child: Text("Proceed")),
          ],
        ),
      ),
    );
  }
}
