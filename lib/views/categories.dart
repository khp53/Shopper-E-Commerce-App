import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopper/services/database.dart';
import 'package:shopper/shared/colors.dart';
import 'package:shopper/shared/cupertinoicon.dart';
import 'package:shopper/shared/widgets.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  TextEditingController searchController = TextEditingController();
  Database _database = Database();
  Stream electronicsStream;

  @override
  void initState() {
    getElectronicsProducts();
    super.initState();
  }

  getElectronicsProducts() async {
    _database.getElectronicsProducts().then((value){
      setState(() {
        electronicsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: ListView(
        children: [ Column(
          children: [
            Container(
              decoration: neumorphicTextInput(),
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: StyleColors.buttonColor),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    style: normalStyle(13),
                    textInputAction: TextInputAction.search,
                    validator: (val) {
                      return searchController.text.isNotEmpty
                          ? null : "Enter something to find product!";
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(search),
                        border: InputBorder.none,
                        hintText: "Find Product",
                        hintStyle: inputBoxStyle()
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 30),
              child: Text(
                "Categories",
                style: normalStyle(30),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 22),
                child: _tabSection(context)
            )
          ],
        ),
      ],
      ),
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
                labelPadding: EdgeInsets.only(right: 5),
                indicatorColor: Colors.transparent,
                labelStyle: normalStyle(14),
                labelColor: StyleColors.bigText,
                unselectedLabelColor: StyleColors.hintText,
                tabs: [
                  Tab(text: "Electronics"),
                  Tab(text: "Shoes"),
                  Tab(text: "Household"),
                  Tab(child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Groceries",
                    ),
                  ),),
                ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1.68,
            child: TabBarView(children: [
              Container(
                child: StreamBuilder(
                  stream: electronicsStream,
                  builder: (context, snapshot){
                    return snapshot.hasData ? GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index){
                          return Container(
                            margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                            padding: EdgeInsets.all(7),
                            decoration: neumorphicGrid(),
                            child: GridTile(
                              header: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(text: "\$ ", style: priceStyle(18, context)),
                                        TextSpan(text: snapshot.data.docs[index].data()['price'], style: normalStyle(18))
                                      ]
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    child: Icon(
                                      Icons.favorite,
                                      color: StyleColors.hintText,
                                    ),
                                    onTap: (){},
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20, bottom: 50, top: 30),
                                child: Image.network(
                                    snapshot.data.docs[index].data()['img'],
                                  fit: BoxFit.contain,
                                ),
                              ),
                              footer: Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                                child: Text(
                                    snapshot.data.docs[index].data()['pname'],
                                    style: normalStyle(13),
                                ),
                              ),
                            ),
                          );
                        },
                    ) : Center(child: Text("Loading Products...", style: normalStyle(15),));
                  },
                )
              ),
              Container(
                child: Center(child: Text("Articles Body")),
              ),
              Container(
                child: Center(child: Text("User Body")),
              ),
              Container(
                child: Center(child: Text("User Body")),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
