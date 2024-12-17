import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/locator.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/repository/user_repository.dart';

enum AllUsersViewState {Idle, Loaded, Busy}

class AllUsersViewModel with ChangeNotifier{
  
  AllUsersViewState _state = AllUsersViewState.Idle;
  late List<UserModel> _allUsers;
  UserModel? _lastFetchedUser;
  static final postsPerPage = 15;
  UserRepository _userRepository = locator<UserRepository>();
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  List<UserModel> get usersList => _allUsers;
  AllUsersViewState get state => _state;

  set state(AllUsersViewState value){
    _state = value;
    notifyListeners();
  }

  AllUsersViewModel(){
    _allUsers = [];
    _lastFetchedUser = null;
    getUserWithPagination(_lastFetchedUser, false);
  }
  
  //refresh and pagination getNewElements -> true
  //first opening getNewElements -> false
  getUserWithPagination(UserModel? lastFetchedUser, bool getNewElements) async{

    if(_allUsers.isNotEmpty){
      _lastFetchedUser = _allUsers.last;
    }

    if(getNewElements){
      
    } else {
      state = AllUsersViewState.Busy;
    }

    var newList = await _userRepository.getUserWithPagination(_lastFetchedUser, postsPerPage);

    if(newList.length < postsPerPage){
      _hasMore = false;
    }
    _allUsers.addAll(newList);
    state = AllUsersViewState.Loaded;
  }

  Future<void> getMoreUsers() async{
    if(_hasMore)
    getUserWithPagination(_lastFetchedUser, true);
    await Future.delayed(Duration(seconds: 1));
  }

  Future<Null> refresh() async{
    _hasMore = true;
    _lastFetchedUser = null;
    _allUsers = [];
    getUserWithPagination(_lastFetchedUser, true);
  }
}