import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  
  String userID = "1234test1234";

  @override
  Future<UserModel> currentUser() async{
    return await Future.value(UserModel(userID: userID));
  }

  

  @override
  Future<UserModel> signInAnonymously() async{
    return await Future.delayed(Duration(seconds: 2), ()=>UserModel(userID: userID));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }
  
  @override
  Future<UserModel?> signInWithGoogle() async{
    return await Future.delayed(Duration(seconds: 2), ()=>UserModel(userID: 'google_user_id_12341234'));
  }
  
  @override
  Future<UserModel?> signInWithFacebook() async{
    return await Future.delayed(Duration(seconds: 2), ()=>UserModel(userID: 'facebook_user_id_12341234'));
  }
  
  @override
  Future<UserModel?> createUserWithEmailAndPassword(String email, String password) async{
    return await Future.delayed(Duration(seconds: 2), ()=>UserModel(userID: 'created_user_id_12341234'));
  }
  
  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async{
    return await Future.delayed(Duration(seconds: 2), ()=>UserModel(userID: 'signIn_user_id_12341234'));
  }
}
