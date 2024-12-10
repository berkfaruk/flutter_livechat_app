import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_livechat_app/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String> uploadFile(String userID, String fileType, File uploadFile) async{
    try {
      Reference storageReference =
          _firebaseStorage.ref().child(userID).child(fileType).child('profile_photo');

      UploadTask uploadTask = storageReference.putFile(uploadFile);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print("File upload error: $e");
      throw Exception("An error occurred while uploading the file");
    }
  
  }

}