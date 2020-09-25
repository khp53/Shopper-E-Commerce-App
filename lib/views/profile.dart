import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopper/services/database.dart';
import 'package:shopper/shared/widgets.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  final String name;
  final String email;

  const Profile({Key key, this.name, this.email}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  Widget profileList(){
    return StreamBuilder(
        stream: profileStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ProfileTiles(
            name: snapshot.data.data()["fullName"],
            email: snapshot.data.data()["email"],
            img: snapshot.data.data()["img"],
            username: snapshot.data.data()["userName"],
          ) : Center(child: CircularProgressIndicator());
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: profileList()
    );
  }
}

class ProfileTiles extends StatelessWidget {
  final String name;
  final String email;
  final String img;
  final String username;
  const ProfileTiles({Key key, this.name, this.email, this.img, this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          brightness: Brightness.light,
          toolbarHeight: 40,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            "User Profile",
            style: normalStyle(28),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                      tag: 'pic',
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[900],
                        backgroundImage: NetworkImage('$img'),
                        radius: 60,
                      )
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Name: $name",
                    textAlign: TextAlign.left,
                    style: normalStyle(20),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "User Name: $username",
                    textAlign: TextAlign.left,
                    style: normalStyle(20),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Email:  $email",
                    textAlign: TextAlign.left,
                    style: normalStyle(20),
                  ),
                  SizedBox(height: 30,),
                  Hero(
                    tag: 'edit',
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: neumorphicButton(),
                      child: FlatButton.icon(
                        onPressed: (){
                          Navigator.push(context, CupertinoPageRoute(
                              builder: (context) => EditProfile()
                          ));
                        },
                        icon: Icon(Icons.edit, color: Colors.white, size: 20,),
                        label: Text("Edit Profile" ,style: menuStyle(15),),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}