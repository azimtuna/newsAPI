import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme/flutterService.dart';
import 'package:deneme/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AuthService{
  final userCollection =FirebaseFirestore.instance.collection("users");
  final firebaseAuth=FirebaseAuth.instance;
  static  String uid=" ";
  Future<void> signIn(BuildContext context,{required String email,required String password}) async{
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user!=null){
         var user = firebaseAuth.currentUser;
        Fluttertoast.showToast(msg: "Signed In",toastLength: Toast.LENGTH_SHORT);
        uid=user!.uid;
        Navigator.of(context).
        pushNamedAndRemoveUntil('/homepage', (Route<dynamic> route) => false,arguments: uid);
      }
    }on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signUp(BuildContext context, {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        uid = userCredential.user!.uid;
        await _registerUser(email: email, password: password,uid: uid);
        await firebaseService().createtoFirestore(uid);
        Fluttertoast.showToast(msg: "CREATED", toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> _registerUser({required String email,required String password,required String uid}) async{
    await userCollection.doc().set({
      "email":email,
      "password":password,
      "uid":uid
    });
  }

}







