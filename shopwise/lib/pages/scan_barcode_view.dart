import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shopwise/pages/mqtt_client_test.dart';
import 'package:shopwise/pages/scan_qrcode_page.dart';
import 'package:shopwise/providers/customer_provider.dart';
import 'package:shopwise/providers/shopping_list_provider.dart';

class ScanBarcode extends ConsumerStatefulWidget {
  ScanBarcode({super.key});
  String _scanBarcodeResult = '';

  bool hasScanned = false;

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
      barcodeScanRes = '-1';
    }
    if (barcodeScanRes != '-1') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      });

      setState(() {
        widget.hasScanned = true;
      });
    }
    // setState(() {
    //   widget._scanBarcodeResult = barcodeScanRes;
    // });
  }

  final snackBar = SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Obtained Card Details',
      message: 'You are good to go!',

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: ContentType.success,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connect with Cart")),
      body: Container(
        height: 800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 40),
                child: Image.asset("assets/images/cart.jpg")),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: OutlinedButton(
                      onPressed: scanBarcode,
                      child: Text(
                        'Scan QR',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: BorderSide(color: Colors.green, width: 3),
                        // foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green, width: 3),
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
            // Text("Barcode Result : ${widget._scanBarcodeResult}",
            //     style: TextStyle(fontSize: 20, color: Colors.black)),
            SizedBox(height: 20),
            Container(
              width: 200,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.hasScanned ? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: widget.hasScanned
                      ? () {
                          // List<int> shoppinListIds = ref.read(shoppingListProvider.notifier).getShoppingListIDS();
                          ref
                              .read(customerNotifierProvider.notifier)
                              .updateHashcode(widget._scanBarcodeResult);
                          ref
                              .read(customerNotifierProvider.notifier)
                              .saveCustomer();
                          Navigator.pushNamed(
                              context, MQTTClientTest.routeName);
                        }
                      : () {
// Remove this part
                          ref
                              .read(customerNotifierProvider.notifier)
                              .updateHashcode(widget._scanBarcodeResult);
                          ref
                              .read(customerNotifierProvider.notifier)
                              .saveCustomer();
                          Navigator.pushNamed(
                              context, MQTTClientTest.routeName);

                          // Fluttertoast.showToast(
                          //     msg: "Please scan the QR code first!",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.red,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0);
                        },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Proceed!",
                      style: TextStyle(fontSize: 17),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
