import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopper/services/database.dart';
import 'package:shopper/shared/colors.dart';
import 'package:shopper/shared/loading.dart';
import 'package:shopper/shared/widgets.dart';

import 'cart.dart';

class ProductPage extends StatefulWidget {
  final String pName;
  final String desc;
  final int price;
  final bool fav;
  final String img;

  const ProductPage(
      {Key key, this.pName, this.desc, this.price, this.fav, this.img})
      : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Stream profileStream;
  Database database = Database();

  final _formKey = GlobalKey<FormState>();
  final List<int> quantity = [1, 2, 3, 4, 5, 6, 7, 8];
  int _currentQuantity = 1;
  String _currentSize = 'NA';
  String _currentColor = '#FFFFFF';

  bool isLoading = false;

  @override
  void initState() {
    getUserProfileInfo();
    super.initState();
  }

  getUserProfileInfo() async {
    database.getUserProfile().then((value) {
      setState(() {
        profileStream = value;
      });
    });
  }

  addToCart(){
    if (_formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> cartMap = {
        "pname": widget.pName,
        "price": _currentQuantity*widget.price,
        "size": _currentSize,
        "color": _currentColor,
        "quantity" : _currentQuantity,
        "img" : widget.img
      };
      Database().addItemToUserCart(cartMap);
    }else {
      setState(() {
        isLoading = false;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Oops!",
                  style: normalStyle(23),
                ),
                content: Text(
                  "Something went wrong, please try again!",
                  style: normalStyle(17),
                ),
                actions: [
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
        child: Center(child: spinKit)
    ) : Scaffold(
      appBar: AppBar(elevation: 0, actions: [
        StreamBuilder(
            stream: profileStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 13),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            NetworkImage(snapshot.data.data()["img"]),
                        backgroundColor: Colors.white54,
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            })
      ]),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width / 3),
                          child: RichText(
                            softWrap: true,
                            text: TextSpan(
                              text: '${widget.pName}\n',
                              style: normalStyle(22),
                              children: [
                                  TextSpan(
                                    text: 'Shop Name',
                                    style: TextStyle(
                                        fontFamily: "ProductSans",
                                        color: StyleColors.hintText,
                                        fontSize: 15,
                                    ),
                                  ),
                              ]
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "\$",
                                      style: TextStyle(
                                          fontFamily: "ProductSans",
                                          color: Colors.deepOrange,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: widget.price.toString(),
                                      style: priceStyle(25, context))
                                ]),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2, right: 15),
                                child: Icon(
                                  Icons.favorite,
                                  color: StyleColors.hintText,
                                  size: 28,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Stack(
                                  children: [
                                    Positioned(
                                      left: 20,
                                      top: 10,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: Container(
                                          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width),
                                          width: MediaQuery.of(context).size.width / 2,
                                          height: MediaQuery.of(context).size.height / 4,
                                          color: Colors.deepOrange[100].withOpacity(.5),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 35, right: 0, bottom: 50, top: 30),
                                        child: Image.network(
                                          widget.img,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Color(0xff000000).withOpacity(.06),
                        offset: Offset(
                          0,
                          -1,
                        ),
                      )
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Description",
                            style: normalStyle(23),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Text(
                              widget.desc,
                              style: TextStyle(
                                color: StyleColors.hintText,
                                fontFamily: "ProductSans",
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "Size",
                                            style: TextStyle(
                                              color: StyleColors.bigText,
                                              fontFamily: "ProductSans",
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "Color",
                                            style: TextStyle(
                                              color: StyleColors.bigText,
                                              fontFamily: "ProductSans",
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "Quantity",
                                            style: TextStyle(
                                              color: StyleColors.bigText,
                                              fontFamily: "ProductSans",
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                            "NA",
                                            style: priceStyle(18, context)
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                            "NA",
                                            style: priceStyle(18, context)
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none
                                        ),
                                        value: _currentQuantity,
                                        onChanged: (value) {
                                          _currentQuantity = value;
                                        },
                                        selectedItemBuilder: (BuildContext context) {
                                          return quantity.map<Widget>((int q) {
                                            return Container(
                                                alignment: Alignment.centerRight,
                                                width: MediaQuery.of(context).size.width / 6,
                                                child: Text(q.toString(), style: priceStyle(18, context), textAlign: TextAlign.center)
                                            );
                                          }).toList();
                                        },
                                        items: quantity.map((q) {
                                          return DropdownMenuItem(
                                            value: q,
                                            child: Center(child: Text(q.toString(), style: priceStyle(18, context))),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    splashColor: Colors.blue,
                                    onTap: () {
                                      Navigator.push(context, CupertinoPageRoute(
                                          builder: (context) => Cart()
                                      ));
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: neumorphicBag(context),
                                        child: Icon(
                                          Icons.shopping_basket,
                                          color: Colors.white,
                                          size: 15,
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    onTap: (){
                                      addToCart();
                                      setState(() {
                                        isLoading = false;
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Added To Cart!",
                                                style: normalStyle(23),
                                              ),
                                              content: Text(
                                                "Your chosen item has been added to the cart!",
                                                style: normalStyle(17),
                                              ),
                                              actions: [
                                                FlatButton(
                                                  child: Text("Go to cart!"),
                                                  onPressed: () {
                                                    Navigator.push(context, CupertinoPageRoute(
                                                        builder: (context) => Cart()
                                                    ));
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text("Keep shopping!"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: neumorphicButton(),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Add To Cart",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "ProductSans",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Icon(
                                            Icons.shopping_cart,
                                            color: Colors.white,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
