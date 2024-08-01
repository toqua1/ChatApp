import 'package:chatapp/cubits/search_cubit/get_search_text_cubit.dart';
import 'package:chatapp/screens/contacts/widgets/bottom_sheet_ui.dart';
import 'package:chatapp/screens/contacts/widgets/contacts_list_view.dart';
import 'package:chatapp/screens/contacts/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class ContactsHome extends StatelessWidget {
  const ContactsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showBottomSheet(
                context: context,
                builder: (context) {
                  return const BottomSheetUi();
                });
          },
          child: const Icon(Iconsax.user_add),
        ),
        appBar: const CustomAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          /*column because of existence of padding */
          child: ContactsListView(),
        ),
      ),
    );
  }
}
