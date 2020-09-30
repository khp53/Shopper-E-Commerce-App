import 'package:flutter/material.dart';
import 'package:shopper/services/database.dart';
import 'package:shopper/shared/widgets.dart';

import 'customDrawer.dart';
import 'loading.dart';

class FloatAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  _FloatAppBarState createState() => _FloatAppBarState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _FloatAppBarState extends State<FloatAppBar> {
  TextEditingController searchController = TextEditingController();

  Stream profileStream;

  @override
  void initState() {
    getUserProfileInfo();
    super.initState();
  }

  getUserProfileInfo() async {
    Database().getUserProfile().then((value) {
      setState(() {
        profileStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 10,
            right: 15,
            left: 15,
            child: Container(
              decoration: neumorphicSearch(),
              child: Row(
                children: <Widget>[
                  Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      splashColor: Colors.grey,
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        CustomDrawer.of(context).open();
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      style: normalStyle(13),
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      validator: (val) {
                        return searchController.text.isNotEmpty
                            ? null
                            : "Enter something to find product!";
                      },
                      decoration: InputDecoration(
                        suffix: StreamBuilder(
                            stream: profileStream,
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 13),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundImage: NetworkImage(
                                            snapshot.data.data()["img"]),
                                        backgroundColor: Colors.white54,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: spinKit),
                                    );
                            }),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// AppBar(
// elevation: 0,
// title: Container(
// decoration: neumorphicSearch(),
// child: Padding(
// padding: const EdgeInsets.only(left: 15),
// child: Theme(
// data: Theme.of(context)
// .copyWith(primaryColor: StyleColors.buttonColor),
// child: TextFormField(
// textAlignVertical: TextAlignVertical.center,
// style: normalStyle(13),
// textInputAction: TextInputAction.search,
// validator: (val) {
// return searchController.text.isNotEmpty
// ? null
//     : "Enter something to find product!";
// },
// controller: searchController,
// decoration: InputDecoration(
// suffix: StreamBuilder(
// stream: profileStream,
// builder: (context, snapshot) {
// return snapshot.hasData
// ? Container(
// // padding: const EdgeInsets.symmetric(
// //     horizontal: 15, vertical: 13),
// child: CircleAvatar(
// // radius: 15,
// backgroundImage:
// NetworkImage(snapshot.data.data()["img"]),
// backgroundColor: Colors.white54,
// ),
// )
//     : Padding(
// padding: const EdgeInsets.only(right: 20),
// child: SizedBox(
// width: 15, height: 15, child: spinKit),
// );
// }),
// border: InputBorder.none,
// hintText: "Find Product",
// hintStyle: inputBoxStyle(12),
// prefix: Builder(
// // builder: (context) {
// // return IconButton(
// // icon: Icon(
// // Icons.menu,
// // color: StyleColors.bigText,
// // ),
// // onPressed: () => CustomDrawer.of(context).open(),
// // );
// // },
// ),
// ),
// ),
// ),
// ),
// ),
// ),
