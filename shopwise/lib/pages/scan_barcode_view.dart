import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shopwise/pages/mqtt_client_test.dart';
import 'package:shopwise/pages/scan_qrcode_page.dart';
import 'package:shopwise/providers/customer_provider.dart';
import 'package:shopwise/providers/shopping_list_provider.dart';

class ScanBarcode extends ConsumerStatefulWidget {
  ScanBarcode({super.key});
  String _scanBarcodeResult = '';

  @override
  ConsumerState<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends ConsumerState<ScanBarcode> {
  void scanBarcode() async {
    String barcodeScanRes;
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
                      child: Text(
                        'Scan QR',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
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
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("Barcode Result : ${widget._scanBarcodeResult}",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // List<int> shoppinListIds = ref.read(shoppingListProvider.notifier).getShoppingListIDS();
                  ref
                      .read(customerNotifierProvider.notifier)
                      .updateHashcode(widget._scanBarcodeResult);
                  ref.read(customerNotifierProvider.notifier).saveCustomer();
                  Navigator.pushNamed(context, MQTTClientTest.routeName);
                },
                child: Text("Proceed")),
          ],
        ),
      ),
    );
  }
}
