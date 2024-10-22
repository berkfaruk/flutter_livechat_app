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
  Future<UserModel> signInWithGoogle() {
    
    throw UnimplementedError();
  }
}
