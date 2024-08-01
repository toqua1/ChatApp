import 'package:chatapp/cubits/search_cubit/get_search_text_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/userModel.dart';
import 'contact_card.dart';

class ContactsListView extends StatelessWidget {
  ContactsListView({super.key});

  List myContacts = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, String>(
      builder: (context, searchText) {
        return Column(
          children: [
            Expanded(
                child: StreamBuilder(
                  /*we make it to return updates immediatly if we
                  add contact and update screen in the same second*/
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        myContacts = snapshot.data!.data()!['my_users'] ?? [];
                        /* we make this ?? [] as if field isnot created yet
                        (user doesnot have contacts) return empty list as
                        there isont exist null list */
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where('id',
                                whereIn:
                                myContacts.isEmpty ? [''] : myContacts)
                                .snapshots(),

                            /*we make this as it return error as list is
                  empty because stream builder faster than async await in
                  myContacts so in this case return list of empty string */
                            /*bring from users => ones' id that are in List of myContacts*/

                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final List<ChatUser> items = snapshot.data!.docs
                                    .map((e) => ChatUser.fromJson(e.data()))
                                    .toList();

                                final List<ChatUser> filteredItems = items.where((user) {
                                  return user.name!.toLowerCase().contains
                                    (searchText.toLowerCase());
                                }).toList()..sort(
                                    (a,b) => a.name!.compareTo(b.name!),
                                );
                                if (kDebugMode) {
                                  print(filteredItems);
                                }

                                return ListView.builder(
                                    itemCount: filteredItems.length,
                                    itemBuilder: (context, index) {
                                      return ContactCard(user: filteredItems[index]);
                                    });
                              } else {
                                return Container();
                              }
                            });
                      } else {
                        return Container();
                      }
                    })),
          ],
        );
      },
    );
  }
}
// getMyContact() async {
//   final contact = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .get()
//       .then((value) =>
//           myContacts = value.data()!['my_users']); /*key my_users of data*/
// }