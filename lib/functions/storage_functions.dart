import 'dart:io';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageFunctions extends ChangeNotifier {
  FirebaseStorageFunctions();

  static Future<Image?> getImageFromFirebase(
      BuildContext context, String imagePath, BoxFit boxFit) async {
    Image? image;
    await loadData(context, imagePath).then((value) => {
          print("after url $value"),
          value != null
              ? image = Image.network(
                  value.toString(),
                  fit: boxFit,
                )
              : const Icon(
                  Icons.image_not_supported,
                  color: Colors.redAccent,
                )
        });
    return image;
  }

  static Future<String?> loadData(
      BuildContext context, String firebaseStorageDataPath) async {
    String? token = await FirebaseAppCheck.instance.getToken(true);
    print('loadData token $token');
    var ref =
        firebase_storage.FirebaseStorage.instance.ref(firebaseStorageDataPath);
    try {
      print('url ${await ref.getDownloadURL()}');
      return await ref.getDownloadURL();
    } catch (error) {
      return null;
    }
  }

  static Future<void> uploadFile(
      String firebaseStorageDataPath, File file) async {
    String? token = await FirebaseAppCheck.instance.getToken(true);
    print('uploadFile token $token');
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(firebaseStorageDataPath)
        .putFile(file);
  }

  static Future<void> uploadString(
      String firebaseStorageDataPath, String dataUrl) async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(firebaseStorageDataPath)
        .putString(dataUrl, format: firebase_storage.PutStringFormat.dataUrl);
  }

  static Future<firebase_storage.UploadTask> uploadData(
      String firebaseStorageDataPath, XFile file, String imageType) async {
    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(firebaseStorageDataPath);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/$imageType',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(file.path), metadata);
    }

    return Future.value(uploadTask);
  }
}

class LoadImageFromFirebaseStorage extends StatelessWidget {
  final String? imagePath;
  final BoxFit? boxFit;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final String? placeholderImagePath;
  const LoadImageFromFirebaseStorage({
    required this.imagePath,
    this.boxFit = BoxFit.cover,
    this.borderRadius,
    this.height,
    this.width,
    this.placeholderImagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseStorageFunctions.getImageFromFirebase(
          context, imagePath!, boxFit!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: Icon(Icons.image_not_supported, color: Colors.redAccent));
        } else if (snapshot.data == null) {
          return const Center(
              child: Icon(Icons.image_not_supported, color: Colors.redAccent));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          );
        } else {
          return Container(
              height: height ?? MediaQuery.of(context).size.height,
              width: width ?? MediaQuery.of(context).size.width,
              child: ClipRRect(
                  borderRadius: borderRadius ?? BorderRadius.circular(0),
                  child: snapshot.data));
        }
      },
    );
  }
}
