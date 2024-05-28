import 'package:chatapp/screens/chats/chat_home.dart';
import 'package:chatapp/screens/contacts/contacts_home.dart';
import 'package:chatapp/screens/groups/widgets/groups_home.dart';
import 'package:chatapp/screens/settings/settings2_home.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
  Widget build(BuildContext context) {

    return Scaffold(
      body:PageView(
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
            child: Icon(Iconsax.message),
            label: 'Chats',
          ),
          CurvedNavigationBarItem(
            child: Icon(Iconsax.people),
            label: 'Groups',
          ),
          CurvedNavigationBarItem(
            child: Icon(Iconsax.user),
            label: 'Contacts',
          ),
          // CurvedNavigationBarItem(
          //   child: Icon(Icons.newspaper),
          //   label: 'Feed',
          // ),
          CurvedNavigationBarItem(
            child: Icon(Iconsax.setting),
            label: 'Setting',
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