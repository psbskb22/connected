import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connected/functions/storage_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vrouter/vrouter.dart';

Future<bool> checkUserNameUniqueness(String userName) async {
  return await FirebaseFirestore.instance
      .collection('users')
      .doc("accessible")
      .collection('personal_details')
      .get()
      .then((QuerySnapshot querySnapshot) async {
    if (querySnapshot.size > 0) {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc("accessible")
          .collection('personal_details')
          .where('user_name', isNotEqualTo: userName)
          .get()
          .then((QuerySnapshot querySnapshot) {
        return true;
      });
    } else {
      return true;
    }
  });
}

Future<bool> checkUserExistance() async {
  if (FirebaseAuth.instance.currentUser != null) {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc("accessible")
        .collection('personal_details')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.exists;
    });
  } else {
    return false;
  }
}

class AddUser {
  final String publicId;
  final String userName;
  final String fullName;
  final int age;
  final String occupation;

  AddUser({
    required this.publicId,
    required this.userName,
    required this.fullName,
    required this.age,
    required this.occupation,
  });
  Future<void> addUser() async {
    FirebaseAuth.instance.userChanges().listen((User? user) async {
      if (user != null) {
        await _addFirebaseUser(user.uid, user.email!);
      } else {}
    });
  }

  Future<void> _addFirebaseUser(String userId, String emailId) async {
    DocumentReference users = FirebaseFirestore.instance
        .collection('users')
        .doc("accessible")
        .collection('personal_details')
        .doc(userId);
    // Call the user's CollectionReference to add a new user
    return users.set({
      'public_id': publicId,
      'email_id': emailId,
      'klustack_score': 0,
      'user_name': userName,
      'full_name': fullName,
      'occupation': occupation, //Student
      'age': age
    }).then((value) async {
      print("User Added");
      await FirebaseFirestore.instance
          .collection('users')
          .doc("accessible")
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        int number = 0;
        if (documentSnapshot.exists) {
          number = documentSnapshot['global_users_count'];
          number++;
        }
        FirebaseFirestore.instance
            .collection('users')
            .doc("accessible")
            .set({'global_users_count': number});
      });
    }).catchError((error) {
      print("Failed to add user: $error");
    });
  }
}

class AddPersonalDetails {
  final String? userName;
  final String? fullName;
  final String? occupation;
  final String? age;

  AddPersonalDetails({this.userName, this.fullName, this.occupation, this.age});

  void addPersonalDetails() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        _addFirebasePersonalDetails(user.uid);
        //_addLocalPersonalDetails(user.uid);
      } else {}
    });
  }

  Future<void> _addFirebasePersonalDetails(String userId) {
    DocumentReference users = FirebaseFirestore.instance
        .collection('users')
        .doc("accessible")
        .collection('personal_details')
        .doc(userId);
    // Call the user's CollectionReference to add a new user
    return users
        .update({
          if (userName != null && userName != "") 'user_name': userName,
          if (fullName != null && fullName != "")
            'full_name': fullName, // John Doe
          if (occupation != null && occupation != "")
            'occupation': occupation, //Student
          if (age != null && age != "") 'age': age // 42
        })
        .then((value) => print("User Firebase Data Updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

class LocalUserDataController {
  static Future<String?> addUserData(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser != null) {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc('accessible')
          .collection('personal_details')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          //print('Document data: ${documentSnapshot['public_id']}');
          Map<String, dynamic>? data = await getLocalUserData();
          if (data == null) {
            _setLocalUserPersonalData(documentSnapshot).then((value) {
              print("User added ${documentSnapshot['public_id']}");
              return documentSnapshot['public_id'];
              //customSnackBar(context, "User Added");
            }).catchError((error) {
              print("Failed to add user: $error");
              //customSnackBar(context, "Failed to add user: $error");
            });
          } else {
            print('user data: ${data['public_id']}');
            return data['public_id'];
            //customSnackBar(context, 'user data: $data');
          }
        } else {
          print('Document does not exist on the database');
          //customSnackBar(context, 'Document does not exist on the database');
        }
      });
    } else {
      //customSnackBar(context, "user not found");
      print('user not found');
    }
  }

  static Future<void> _setLocalUserPersonalData(
      DocumentSnapshot documentSnapshot) async {
    var box = await Hive.openBox('user');
    box.put('personal_data', {
      'public_id': documentSnapshot['public_id'],
      'user_name': documentSnapshot['user_name'],
      'full_name': documentSnapshot['full_name'],
      'age': documentSnapshot['age'],
      'email_id': documentSnapshot['email_id'],
      'occupation': documentSnapshot['occupation']
    });
  }

  static Future<void> removeUserData() async {
    var box = await Hive.openBox('user');
    box.delete('personal_data');
  }

  static Future<Map<String, dynamic>?> getLocalUserData() async {
    var box = await Hive.openBox('user');
    return box.get('personal_data');
  }
}

class DeleteAccount {
  final BuildContext? context;
  //final String? chatroomId;

  DeleteAccount({
    required this.context,
    //required this.chatroomId,
  });
  Future<void> deleteAccount() async {
    Map<String, dynamic>? userData =
        await LocalUserDataController.getLocalUserData();
    if (userData != null) {
      FirebaseAuth.instance.userChanges().listen((User? user) async {
        if (user != null) {
          print('publicId ${userData['public_id']}');
          await _removeUserDataFromFirestore(user.uid);
          await _deleteAccount();
        } else {}
      });
    }
  }

  Future<void> _removeUserDataFromFirestore(String userId) async {
    await _removePersonalDataFromFirestore(userId);
  }

  Future<void> _removePersonalDataFromFirestore(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("accessible")
        .collection('personal_details')
        .doc(userId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> _deleteAccount() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }
}

class SubmitGameData {
  final String? gameId;
  final String? gameName;
  final String? gameCategory;
  final String? shortDescription;
  final String? longDescription;
  final Future<XFile>? gameIconPath;
  final Future<XFile>? coverImagePath;
  final Future<XFile>? imageGalleryPath;

  String gameDataPath = "/games/published/action/";

  SubmitGameData(
      {required this.gameId,
      required this.gameName,
      required this.gameCategory,
      required this.shortDescription,
      required this.longDescription,
      required this.gameIconPath,
      required this.coverImagePath,
      required this.imageGalleryPath});

  Future<void> addGameData(String userId) {
    String _gameIconStoragePath =
        gameDataPath + "${gameId!}/icon/${DateTime.now().toString()}";
    String _coverImageStoragePath =
        gameDataPath + "${gameId!}/cover-image/${DateTime.now().toString()}";
    String _imageGalleryStoragePath =
        gameDataPath + "${gameId!}/image-gallery/${DateTime.now().toString()}";

    if (gameIconPath != null) {
      gameIconPath!
          .then((value) => FirebaseStorageFunctions.uploadData(
              _gameIconStoragePath, value, 'png'))
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => print(error));
    }
    if (coverImagePath != null) {
      coverImagePath!
          .then((value) => FirebaseStorageFunctions.uploadData(
              _coverImageStoragePath, value, 'jpg'))
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => print(error));
    }
    if (imageGalleryPath != null) {
      imageGalleryPath!
          .then((value) => FirebaseStorageFunctions.uploadData(
              _imageGalleryStoragePath, value, 'jpg'))
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => print(error));
    }

    DocumentReference users = FirebaseFirestore.instance
        .collection('games')
        .doc('published')
        .collection('action')
        .doc(gameId!);
    // Call the user's CollectionReference to add a new user
    return users
        .set({
          'id': gameId,
          'name': gameName, // John Doe
          'game-category': gameCategory,
          'short-description': shortDescription,
          'long-description': longDescription,
          'game-icon-path': _gameIconStoragePath,
          'cover-image-path': _coverImageStoragePath,
          'image-gallery-path': _imageGalleryStoragePath,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

// void customSnackBar(BuildContext context, String text) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     content: Row(
//       children: [
//         const Icon(Icons.warning, color: Colors.yellow),
//         const SizedBox(
//           width: 20,
//         ),
//         Text(text),
//       ],
//     ),
//     backgroundColor: Colors.orange[400],
//     shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15), topRight: Radius.circular(15))),
//   ));
// }
