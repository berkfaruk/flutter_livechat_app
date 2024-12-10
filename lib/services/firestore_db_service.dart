import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/services/db_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {

    await _firebaseDB.collection("users").doc(user.userID).set(user.toMap());

    DocumentSnapshot _readUser = await _firebaseDB.collection('users').doc(user.userID).get();
    Map<String, dynamic> _readUserInfoMap = _readUser.data() as Map<String, dynamic>;
    UserModel _readUserInfo = UserModel.fromMap(_readUserInfoMap);
    print('Okunan User Bilgileri: ${_readUserInfo.toString()}');
    
    return true;
  }
  
  @override
  Future<UserModel> readUser(String userID) async{
    DocumentSnapshot _readUser = await _firebaseDB.collection('users').doc(userID).get();
    Map<String, dynamic> _readUserMapInfo = _readUser.data() as Map<String, dynamic>;

    UserModel _readUserObject = UserModel.fromMap(_readUserMapInfo);
    print('Okunan User Nesnesi' + _readUserObject.toString());
    return _readUserObject;
  }
  
  @override
  Future<bool> updateUserName(String userID, String newUserName) async{
    var users = await _firebaseDB.collection('users').where('userName', isEqualTo: newUserName).get();
    if(users.docs.length>=1){
      return false;
    } else {
      await _firebaseDB.collection('users').doc(userID).update({'userName':newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userID,String profilePhotoURL) async{
      await _firebaseDB.collection('users').doc(userID).update({'profileURL':profilePhotoURL});
      return true;
    
  }

}
