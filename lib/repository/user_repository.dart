import 'dart:io';

import 'package:flutter_livechat_app/locator.dart';
import 'package:flutter_livechat_app/model/message.dart';
import 'package:flutter_livechat_app/model/speech.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/services/auth_base.dart';
import 'package:flutter_livechat_app/services/fake_auth_service.dart';
import 'package:flutter_livechat_app/services/firebase_auth_service.dart';
import 'package:flutter_livechat_app/services/firebase_storage_service.dart';
import 'package:flutter_livechat_app/services/firestore_db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  List<UserModel> allUsersList = [];

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

  Future<bool> updateUserName(String userID, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(userID, newUserName);
    }
  }

  Future<String> uploadFile(
      String userID, String fileType, File uploadFile) async {
    if (appMode == AppMode.DEBUG) {
      return "download_url_link";
    } else {
      var profilePhotoURL = await _firebaseStorageService.uploadFile(
          userID, fileType, uploadFile);
      await _firestoreDBService.updateProfilePhoto(userID, profilePhotoURL);
      return profilePhotoURL;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      allUsersList = await _firestoreDBService.getAllUsers();
      return allUsersList;
    }
  }

  Stream<List<Message>> getMessages(
      String currentUserID, String conversationUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDBService.getMessages(currentUserID, conversationUserID);
    }
  }

  Future<bool> saveMessage(Message toSaveMessage) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDBService.saveMessage(toSaveMessage);
    }
  }

  Future<List<Speech>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _time = await _firestoreDBService.showTime(userID);

      var speechList = await _firestoreDBService.getAllConversations(userID);
      for (var currentSpeech in speechList) {
        var userInUserList = findUserInList(currentSpeech.listener!);
        if (userInUserList != null) {
          currentSpeech.listenerUserName = userInUserList.userName;
          currentSpeech.listenerUserProfileURL = userInUserList.profileURL;
        } else {
          var _userReadFromDatabase =
              await _firestoreDBService.readUser(currentSpeech.listener!);
          currentSpeech.listenerUserName = _userReadFromDatabase.userName;
          currentSpeech.listenerUserProfileURL = _userReadFromDatabase.profileURL;
        }
        calculateTimeAgo(currentSpeech, _time);
      }
      return speechList;
    }
  }

  UserModel? findUserInList(String userID) {
    for (int i = 0; i < allUsersList.length; i++) {
      if (allUsersList[i].userID == userID) {
        return allUsersList[i];
      }
    }
    return null;
  }
  
  void calculateTimeAgo(Speech currentSpeech, DateTime time) {
    currentSpeech.lastReadTime = time;

        var _duration = time.difference(currentSpeech.creationDate!.toDate());
        currentSpeech.timeDifference = timeago.format(time.subtract(_duration));
  }
}
