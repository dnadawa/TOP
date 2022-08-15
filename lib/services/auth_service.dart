import 'package:flutter/material.dart';
import 'package:top/models/user_model.dart';
import 'package:top/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  User? _userFromFirebase(auth.User? user){
    if (user == null){
      return null;
    }

    return User(user.uid, user.email);
  }

  Future<User?> get currentUser async {
    try{
      await _auth.currentUser?.reload();
    }
    catch (e) {
      ToastBar(text: e.toString(), color: Colors.red).show();
      signOut();
    }

    await _auth.currentUser?.reload();
    return _userFromFirebase(_auth.currentUser);
  }

  Future<User?>? signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      return _userFromFirebase(credential.user);

    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ToastBar(text: 'No user found for that email.', color: Colors.red).show();
      } else if (e.code == 'wrong-password') {
        ToastBar(text: 'Wrong password provided for that user.', color: Colors.red).show();
      } else if (e.code == 'invalid-email') {
        ToastBar(text: 'Email is invalid.', color: Colors.red).show();
      }
    }
    catch (e){
      ToastBar(text: e.toString(), color: Colors.red).show();
    }

    return null;
  }

  Future<User?>? signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _userFromFirebase(credential.user);

    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ToastBar(text: 'The password provided is too weak.', color: Colors.red).show();
      } else if (e.code == 'email-already-in-use') {
        ToastBar(text: 'The account already exists for that email.', color: Colors.red).show();
      } else if (e.code == 'invalid-email') {
        ToastBar(text: 'Email is invalid.', color: Colors.red).show();
      }
    } catch (e) {
      ToastBar(text: e.toString(), color: Colors.red).show();
    }
    return null;
  }

  Future<bool> signOut() async {
    try{
      await _auth.signOut();
      return true;
    }
    catch(e){
      ToastBar(text: e.toString(), color: Colors.red).show();
      return false;
    }
  }

  // deleteUser(BuildContext context) async {
  //   try{
  //     await _auth.currentUser?.delete();
  //     return true;
  //   }
  //   on auth.FirebaseException catch(e){
  //     if (e.code == 'requires-recent-login'){
  //       ToastBar(text: 'Please log in again to delete the account!', color: Colors.red).show();
  //       signOut();
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           CupertinoPageRoute(builder: (context) => Login()),
  //               (Route<dynamic> route) => false);
  //       return false;
  //     }
  //   }
  //   catch(e){
  //     return false;
  //   }
  // }
  //
  Future<bool> forgetPassword(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    }
    on auth.FirebaseException catch(e){
      if (e.code == 'invalid-email'){
        ToastBar(text: 'Invalid Email!', color: Colors.red).show();
        return false;
      }
      else if(e.code == 'user-not-found'){
        ToastBar(text: 'User not found!', color: Colors.red).show();
        return false;
      }

      return false;
    }
    catch(e){
      ToastBar(text: 'Something went wrong!', color: Colors.red).show();
      return false;
    }
  }
}