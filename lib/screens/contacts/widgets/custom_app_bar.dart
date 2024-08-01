import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/search_cubit/get_search_text_cubit.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool searched = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: searched
          ? const SearchBar()
          : const Text("Contacts"),
      actions: [
        searched
            ? IconButton(
            onPressed: () {
              setState(() {
                searched = false;
                context.read<SearchCubit>().updateSearchText('');
              });
            },
            icon: const Icon(Iconsax.close_circle))
            : IconButton(
            onPressed: () {
              setState(() {
                searched = true;
              });
            },
            icon: const Icon(Iconsax.search_normal)),
      ],
    );
  }
}
