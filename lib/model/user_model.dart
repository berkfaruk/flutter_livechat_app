import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  final String userID;
  String email;
  String? userName;
  String? profileURL;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? level;


  UserModel({required this.userID, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID' : userID,
      'email' : email,
      'userName' : userName ?? email.substring(0, email.indexOf('@')) + randomNumberGenerate(),
      'profileURL' : profileURL ?? 'https://i.pinimg.com/736x/cb/45/72/cb4572f19ab7505d552206ed5dfb3739.jpg',
      'createdAt' : createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt' : updatedAt ?? FieldValue.serverTimestamp(),
      'level' : level ?? 1,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map): 
    userID = map['userID'],
    email = map['email'],
    userName = map['userName'],
    profileURL = map['profileURL'],
    createdAt = (map['createdAt'] as Timestamp).toDate(),
    updatedAt = (map['updatedAt'] as Timestamp).toDate(),
    level = map['level'];

    @override
  String toString() {
    return 'UserModel{userID: $userID, email: $email, userName: $userName, profileURL: $profileURL, createdAt: $createdAt, updatedAt: $updatedAt, level: $level}';
  }

  String randomNumberGenerate() {
    int randomNum = Random().nextInt(999999);
    return randomNum.toString();
  }

}