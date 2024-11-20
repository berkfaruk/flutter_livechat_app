import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/locator.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/repository/user_repository.dart';
import 'package:flutter_livechat_app/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  UserModel? _user;
  UserModel? get user => _user;
  String? emailErrorMessage;
  String? passwordErrorMessage;

  ViewState get state => _state;
  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserViewModel(){
    currentUser();
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user!;
    } catch (e) {
      debugPrint('ViewModel CurrentUser : ${e.toString()}');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      return _user!;
    } catch (e) {
      debugPrint('ViewModel SignInAnonymously : ${e.toString()}');
      throw UnimplementedError();
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool result = await _userRepository.signOut();
      _user = null;
      return result;
    } catch (e) {
      debugPrint('ViewModel SignOut : ${e.toString()}');
      throw UnimplementedError(e.toString());
    } finally {
      state = ViewState.Idle;
    }
  }
  
  @override
  Future<UserModel?> signInWithGoogle() async{
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      return _user!;
    } catch (e) {
      debugPrint('ViewModel SignInGoogle : ${e.toString()}');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }
  
  @override
  Future<UserModel?> signInWithFacebook() async{
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithFacebook();
      return _user!;
    } catch (e) {
      debugPrint('ViewModel SignInFacebook : ${e.toString()}');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }
  
  @override
  Future<UserModel?> createUserWithEmailAndPassword(String email, String password) async{
    try {
      if(_emailPasswordControl(email, password)){
        state = ViewState.Busy;
      _user = await _userRepository.createUserWithEmailAndPassword(email, password);
      return _user!;
      } else return null;
    } catch (e) {
      debugPrint('ViewModel createUserWirhEmailAndPassword : ${e.toString()}');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }
  
  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async{
    try {
      if(_emailPasswordControl(email, password)){
        state = ViewState.Busy;
      _user = await _userRepository.signInWithEmailAndPassword(email, password);
      return _user!;
      } else return null;
    } catch (e) {
      debugPrint('ViewModel signInWithEmailAndPassword : ${e.toString()}');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailPasswordControl(String email, String password) {
    var result = true;

    if(password.length < 6) {
      passwordErrorMessage = 'Password must be 6 characters';
      result = false;
    } else passwordErrorMessage = null;
    if(!email.contains('@')){
      emailErrorMessage = 'Invalid Email Address';
      result = false;
    } else emailErrorMessage = null;
    return result;
  }

}
