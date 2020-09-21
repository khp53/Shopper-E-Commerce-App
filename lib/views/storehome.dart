import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopper/main.dart';
import 'package:shopper/services/auth.dart';
import 'package:shopper/shared/colors.dart';
import 'package:shopper/shared/customDrawer.dart';

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          IconButton(
            onPressed: () async{
              await AuthMethods().signOut();
              Navigator.pushReplacement(
                  context, CupertinoPageRoute(builder: (context) => MyApp()));
            },
            icon: SvgPicture.asset('assets/signout.svg', color: StyleColors.bigText,),
          )
        ],
      ),
    );
  }
}
