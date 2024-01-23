import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrCodePage extends StatelessWidget {
  static const String routeName = '/scan_barcode_page';
  const ScanQrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isRead = false;
    return Scaffold(
      appBar: AppBar(title: Text("Connect with Cart")),
      body: MobileScanner(
        fit: BoxFit.contain,
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          // facing: CameraFacing.back,
          // torchEnabled: false,
          returnImage: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;

          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            Navigator.pop(context, barcode.rawValue);

            isRead = true;
          }
          if (image != null) {
            showDialog(
              context: context,
              builder: (context) => Image(image: MemoryImage(image)),
            );
            Future.delayed(const Duration(seconds: 5), () {
              Navigator.pop(context);
            });
          }
        },
      ),
    );
  }
}
