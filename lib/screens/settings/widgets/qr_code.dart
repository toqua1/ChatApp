import 'package:chatapp/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
class QRCode extends StatefulWidget {
  const QRCode({super.key, required this.email});
  final String? email;

  @override
  State<QRCode> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code"),
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }
            ,icon:const Icon(Icons.arrow_back_ios)
        ),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Card(
             color: Colors.white,
              child: QrImageView(
                data: widget.email ?? "",
                version: 5,
                size: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
