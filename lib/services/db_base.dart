import 'package:flutter_livechat_app/model/message.dart';
import 'package:flutter_livechat_app/model/speech.dart';
import 'package:flutter_livechat_app/model/user_model.dart';

abstract class DBBase {
  
  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updateProfilePhoto(String userID, String profilePhotoURL);
  Future<List<UserModel>> getUserWithPagination(UserModel lastFetchedUser, int getNumberOfUsers);
  Future<List<Speech>> getAllConversations(String userID);
  Stream<List<Message>> getMessages(String currentUserID, String conversationUserID);
  Future<bool> saveMessage(Message toSaveMessage);
  Future<DateTime> showTime(String userID);
}