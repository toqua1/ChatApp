import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
class QRCode extends StatefulWidget {
  const QRCode({super.key});

  @override
  State<QRCode> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code"),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Card(
             color: Colors.white,
              child: QrImageView(
                data: '1234567890',
                version: 3,
                size: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
