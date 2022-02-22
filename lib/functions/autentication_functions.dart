import 'dart:async';

import 'package:connected/Variables/variables.dart';
import 'package:connected/functions/database_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vrouter/vrouter.dart';

class FirebaseEmailAndPasswordAuth {
  void emailAndPasswordSignin(
      BuildContext context, String emailId, String password) async {
    FirebaseAuth.instance.userChanges().listen((User? user) async {
      if (user == null) {
        _emailAndPasswordLogin(context, emailId, password);
      } else {
        print('User is already signed in');
        Map<String, dynamic>? userData =
            await LocalUserDataController.getLocalUserData();
        String? publicId = userData!['public_id'];
        if (publicId != null) {
          context.vRouter.to('/user/profile/$publicId');
          Variables.bottomNavbarActive = false;
          Variables.navbarActive = false;
        } else {
          print("public id not found");
          LocalUserDataController.addUserData(context);
        }
      }
    });
  }

  Future<void> _emailAndPasswordLogin(
      BuildContext context, String emailId, String password) async {
    try {
      await checkUserExistance().then((isUserExist) async {
        if (isUserExist) {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: emailId, password: password);
          String? publicId = await LocalUserDataController.addUserData(context);
          if (publicId != null) context.vRouter.to('/user/profile/$publicId');
          print('User Login Successfully $publicId');
        } else {
          context.vRouter.to('/welcome-new');
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        _emailAndPasswordSignup(
            context, "userName", "fullName", emailId, "age", password);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> _emailAndPasswordSignup(BuildContext context, String userName,
      String fullName, String emailId, String age, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailId, password: password);
      String userId = userCredential.user!.uid;
      print("User Added Successfully $userId");
      context.vRouter.to('/welcome-new');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}

class FirebaseGoogleAuth {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await _signInWithGoogleMobile().then((value) async {
        if (value.additionalUserInfo!.isNewUser) {
          context.vRouter.to('/welcome-new');
        } else {
          await checkUserExistance().then((isUserExist) async {
            if (isUserExist) {
              String? publicId =
                  await LocalUserDataController.addUserData(context);
              if (publicId != null) {
                context.vRouter.to('/user/profile/$publicId');
              }
              print('Successfully signin using google $publicId');
            } else {
              context.vRouter.to('/welcome-new');
            }
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        print('Failed with error code: ${e.code} ${e.message}');
      }
    } on PlatformException catch (e) {
      print('Platform exception: ${e.code}');
    } on FirebaseException catch (e) {
      print('Firebase exception: ${e.code}');
    }
  }

  Future<UserCredential> _signInWithGoogleWeb() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  Future<UserCredential> _signInWithGoogleMobile() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    // Once signed in, return the UserCredential
    return userCredential;
  }
}

class FirebaseAuthSignout {
  static Future<void> firebaseSignout(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      if (FirebaseAuth.instance.currentUser == null) {
        print('Succesfully to signout');
        context.vRouter.to('/signin');
      } else {
        print('Faild to signout');
        //context.vRouter.to('/user/profile/${user.uid}');
      }
    });
  }

  void signOutWithGoogle(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }
}
