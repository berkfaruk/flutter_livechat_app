import 'dart:io';

import 'package:flutter_livechat_app/locator.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/services/auth_base.dart';
import 'package:flutter_livechat_app/services/fake_auth_service.dart';
import 'package:flutter_livechat_app/services/firebase_auth_service.dart';
import 'package:flutter_livechat_app/services/firebase_storage_service.dart';
import 'package:flutter_livechat_app/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserModel? _user = await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_user!.userID);
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      UserModel? _user = await _firebaseAuthService.signInWithGoogle();
      bool _result = await _firestoreDBService.saveUser(_user!);
      if (_result) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithFacebook();
    } else {
      UserModel? _user = await _firebaseAuthService.signInWithFacebook();
      bool _result = await _firestoreDBService.saveUser(_user!);
      if (_result) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithEmailAndPassword(
          email, password);
    } else {
      UserModel? _user = await _firebaseAuthService
          .createUserWithEmailAndPassword(email, password);
      bool _result = await _firestoreDBService.saveUser(_user!);
      if (_result) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailAndPassword(email, password);
    } else {
      UserModel? _user = await _firebaseAuthService.signInWithEmailAndPassword(
          email, password);
      return await _firestoreDBService.readUser(_user!.userID);
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async{
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(userID, newUserName);
    }
  }

  Future<String> uploadFile(String userID, String fileType, File uploadFile) async{
    if (appMode == AppMode.DEBUG) {
      return "download_url_link";
    } else {
      var profilePhotoURL = await _firebaseStorageService.uploadFile(userID, fileType, uploadFile);
      await _firestoreDBService.updateProfilePhoto(userID, profilePhotoURL);
      return profilePhotoURL;
    }
  }
}
