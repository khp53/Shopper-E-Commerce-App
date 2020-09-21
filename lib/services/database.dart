import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database{
  Future uploadUserInfo(userMap) async{
    return await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid).set(userMap);
  }
}