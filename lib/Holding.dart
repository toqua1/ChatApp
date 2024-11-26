import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/provider/provider.dart';
import 'package:chatapp/screens/chats/screens/chat_home.dart';
import 'package:chatapp/screens/contacts/screens/contacts_home.dart';
import 'package:chatapp/screens/groups/screens/groups_home.dart';
import 'package:chatapp/screens/settings/screens/settings2_home.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class Holding extends StatefulWidget {
  const Holding({super.key});

  @override
  _HoldingState createState() => _HoldingState();
}

class _HoldingState extends State<Holding> {
  // int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
PageController pageController=PageController() ;
@override
  void initState() {
  Provider.of<ProviderApp>(context, listen: false).getUserDetails();
    super.initState();
  }
@override
  Widget build(BuildContext context) {
ChatUser? me=Provider.of<ProviderApp>(context).me;
    return Scaffold(
      body:me == null?
       const Center(child: CircularProgressIndicator(),)
      :PageView(
        onPageChanged: (value){
          setState(() {
            // _page=value ;
            _bottomNavigationKey.currentState?.setPage(value);
          });
        },
        controller:pageController ,
        children: const [
          // _buildPage(_page),
          chats(),
          GroupsHome(),
          ContactsHome(),
          SettingScreen(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Iconsax.message,color: Colors.white,),
            label: 'Chats',
              labelStyle: TextStyle(color: Colors.white,)

          ),
          CurvedNavigationBarItem(
            child: Icon(Iconsax.people,color: Colors.white,),
            label: 'Groups',
              labelStyle: TextStyle(color: Colors.white,)

          ),
          CurvedNavigationBarItem(
            child: Icon(Iconsax.user,color: Colors.white,),
            label: 'Contacts',
              labelStyle: TextStyle(color: Colors.white,)

          ),
          // CurvedNavigationBarItem(
          //   child: Icon(Icons.newspaper),
          //   label: 'Feed',
          // ),
          CurvedNavigationBarItem(
            child: Icon(Iconsax.setting,color: Colors.white,),
            label: 'Setting',
            labelStyle: TextStyle(color: Colors.white,)
          ),
        ],
          color: Colors.deepPurple,
          buttonBackgroundColor: Colors.blue ,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 550),
        onTap: (index) {
          setState(() {
            // _page = index;
            // _buildPage(_page);
            pageController.jumpToPage(index);
          });
        },
        // letIndexChange: (index) => true,
      ),
    );
  }

}