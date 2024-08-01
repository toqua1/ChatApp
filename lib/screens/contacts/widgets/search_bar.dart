import 'package:flutter/material.dart';
import '../../../cubits/search_cubit/get_search_text_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchCon = TextEditingController();

    return Row(
      children: [
        Expanded(
            child: TextField(
              autofocus: true,
              /*open keyboard automatically*/
              controller: searchCon,
              decoration: const InputDecoration(
                  hintText: "Search by name",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none
              ),
              onChanged: (text) {
                context.read<SearchCubit>().updateSearchText(text);
              },
            ))
      ],
    );
  }
}
