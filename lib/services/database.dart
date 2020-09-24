import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Database{
  Future uploadUserInfo(userMap) async{
    return await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid).set(userMap);
  }

  getUserProfile () async{
    return FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots();
  }

  getElectronicsProducts () async{
  return FirebaseFirestore.instance.collection("products")
      .doc("categories").collection("electronics")
      .snapshots();
  }

  Future<void> updateProfile(Map data) async {
    return FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update(data);
  }

  uploadUserImage(File img) async{
    return await FirebaseStorage.instance.ref().child("user_image")
        .child(FirebaseAuth.instance.currentUser.email + '.jpg')
        .putFile(img).onComplete;
  }
}