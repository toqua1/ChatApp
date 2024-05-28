import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../Text/custom_textfield.dart';
import 'contact_card.dart';

class ContactsHome extends StatefulWidget {
  const ContactsHome({super.key});

  @override
  State<ContactsHome> createState() => _ContactsHomeState();
}

class _ContactsHomeState extends State<ContactsHome> {
  @override
  bool searched= false ;
  TextEditingController _searchCon =TextEditingController() ;
  TextEditingController _emailController =TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
              context: context,
              builder: (context){
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text("Enter friend name" ,style: Theme.of
                            (context).textTheme.bodyLarge,
                          ),
                          Spacer(),
                          IconButton.filled(
                            onPressed: (){

                            },
                            icon: Icon(Iconsax.scan_barcode),
                          )
                        ],
                      ),
                      custom_FormTextfield(
                        label: "Email",
                        controller: _emailController ,
                        hintText:"Enter your friend email"
                        , name: false ,
                        prefixIcon: const Icon(Iconsax.direct),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(
                              right: 20 ,left: 20
                              ,bottom: 16 ,top: 16),
                          shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer ,
                        ),
                        onPressed: (){

                        },
                        child:const Center(child: Text("Add Contact")),
                      )
                    ],
                  ),
                );
              }
          );
        },
        child: const Icon(Iconsax.user_add),
      ),
      appBar: AppBar(
        title: searched?
            Row(
              children: [
                Expanded(child:TextField(
                 autofocus: true,/*open keyboard automatically*/
                  controller: _searchCon,
                  decoration: InputDecoration(
                    hintText: "Search by name" ,
                    border: InputBorder.none
                  ),
                ))
              ],
            )
            :const Text("Contacts"),
      actions: [
        searched?IconButton(
            onPressed: (){
              setState(() {
                searched=false ;
              });
            },
            icon: Icon(Iconsax.close_circle)
        ):IconButton(onPressed: (){
           setState(() {
             searched=true ;
           });
        }, icon: Icon(Iconsax.search_normal)
        ),
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index){
              return const ContactCard();
            })),
          ],
        ),
      ),
    );
  }
}


