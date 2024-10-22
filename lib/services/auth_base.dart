import 'package:flutter_livechat_app/model/user_model.dart';

abstract class AuthBase {

  Future<UserModel?> currentUser();

  Future<UserModel?> signInAnonymously();

  Future<bool> signOut();

  Future<UserModel?> signInWithGoogle();

}