import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopper/services/database.dart';
import 'package:shopper/shared/colors.dart';
import 'package:shopper/shared/customDrawer.dart';
import 'package:shopper/shared/custom_bottom_appbar.dart';
import 'package:shopper/shared/widgets.dart';
import 'package:shopper/views/cart.dart';
import 'package:shopper/views/categories.dart';
import 'package:shopper/views/favorite.dart';
import 'package:shopper/views/messages.dart';
import 'package:shopper/views/profile.dart';

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {

  Database database = Database();
  Stream profileStream;

  @override
  void initState() {
    getUserProfileInfo();
    super.initState();
  }

  getUserProfileInfo() async {
    database.getUserProfile().then((value){
      setState(() {
        profileStream = value;
      });
    });
  }

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Categories(),
    Messages(),
    Favorites(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 63.0,
        height: 63.0,
        child: FloatingActionButton(
          child: Icon(Icons.shopping_cart, size: 28,),
          onPressed: (){
            Navigator.push(context, CupertinoPageRoute(
              builder: (context) => Cart()
            ));
          },
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: StyleColors.bigText, size: 30,),
              onPressed: () => CustomDrawer.of(context).open(),
            );
          },
        ),
        actions: [
          StreamBuilder(
            stream: profileStream,
            builder: (context, snapshot) {
              return snapshot.hasData ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(snapshot.data.data()["img"]),
                  backgroundColor: Colors.white54,
                ),
              )
                  :Center(child: CircularProgressIndicator(),);
            }
          )
        ],
      ),
      bottomNavigationBar: FABBottomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconSize: 20,
        onTabSelected: _onItemTapped,
        notchedShape: CircularNotchedRectangle(),
        color: StyleColors.hintText,
        selectedColor: Theme.of(context).accentColor,
        items: [
          FABBottomAppBarItem(iconData1: Icons.content_paste, text: 'Categories'),
          FABBottomAppBarItem(iconData1: Icons.chat_bubble, text: 'Messages'),
          FABBottomAppBarItem(iconData1: Icons.favorite, text: 'Favorite'),
          FABBottomAppBarItem(iconData1: Icons.person, text: 'Profile'),
        ],
      ),
      body:  _widgetOptions.elementAt(_selectedIndex),
    );
  }


}
