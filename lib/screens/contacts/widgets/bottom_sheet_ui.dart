import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../helper/Text/custom_textfield.dart';
import '../../../services/firebase/fire_database.dart';

class BottomSheetUi extends StatefulWidget {
  const BottomSheetUi({super.key});

  @override
  State<BottomSheetUi> createState() => _BottomSheetUiState();
}

class _BottomSheetUiState extends State<BottomSheetUi> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Enter friend name",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Iconsax.scan_barcode),
              )
            ],
          ),
          CustomFormTextfield(
            label: "Email",
            controller: _emailController,
            hintText: "Enter your friend email",
            name: false,
            prefixIcon: const Icon(Iconsax.direct),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(
                  right: 20, left: 20, bottom: 16, top: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor:
              Theme.of(context).colorScheme.primaryContainer,
            ),
            onPressed: () {
              FireData()
                  .addContact(_emailController.text)
                  .then((value) {
                setState(() {
                  _emailController.text = '';
                });
                Navigator.pop(context);
              });
            },
            child: const Center(child: Text("Add Contact")),
          )
        ],
      ),
    );
  }
}
