import 'package:flutter_livechat_app/model/user_model.dart';

abstract class DBBase {
  
  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updateProfilePhoto(String userID, String profilePhotoURL);

}