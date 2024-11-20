import 'package:flutter_livechat_app/model/user_model.dart';

abstract class AuthBase {

  Future<UserModel?> currentUser();

  Future<UserModel?> signInAnonymously();

  Future<bool> signOut();

  Future<UserModel?> signInWithGoogle();

  Future<UserModel?> signInWithFacebook();

  Future<UserModel?> signInWithEmailAndPassword(String email, String password);

  Future<UserModel?> createUserWithEmailAndPassword(String email, String password);

}