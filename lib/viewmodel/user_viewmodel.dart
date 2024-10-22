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

  ViewState get state => _state;
  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserViewModel(){
    currentUser();
  }

  @override
  Future<UserModel> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user!;
    } catch (e) {
      debugPrint('ViewModel CurrentUser : ${e.toString()}');
      throw UnimplementedError(e.toString());
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
}
