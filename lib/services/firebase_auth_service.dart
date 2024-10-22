import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/services/auth_base.dart';

class FirebaseAuthService implements AuthBase{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel> currentUser() async{
    try {
      User user = await _firebaseAuth.currentUser!;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      throw UnimplementedError();
    }
  }

  UserModel _userFromFirebase(User user) {
    return UserModel(userID: user.uid);
  }

  @override
  Future<UserModel> signInAnonymously() async{
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(result.user!);
    } catch (e) {
      print(e.toString());
      throw UnimplementedError();
    }
  }

  @override
  Future<bool> signOut() async{
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}