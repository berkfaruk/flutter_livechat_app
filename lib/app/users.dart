import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/app/chat_page.dart';
import 'package:flutter_livechat_app/viewmodel/all_users_viewmodel.dart';
import 'package:flutter_livechat_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Consumer<AllUsersViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUsersViewState.Busy) {
            return Center(child: CircularProgressIndicator());
          } else if (model.state == AllUsersViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: model.refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (model.usersList.length == 1) {
                    return _noUserUI();
                  } else if (model.hasMoreLoading &&
                      index == model.usersList.length) {
                    return _loadingNewElementsIndicator();
                  } else {
                    return _createUserListElement(index);
                  }
                },
                itemCount: model.hasMoreLoading
                    ? model.usersList.length + 1
                    : model.usersList.length,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _noUserUI() {
    final _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
    return RefreshIndicator(
      onRefresh: _allUsersViewModel.refresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.supervised_user_circle,
                  color: Theme.of(context).primaryColor,
                  size: 100,
                ),
                Text(
                  'There are no registered users here',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createUserListElement(int index) {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final _allUsersViewModel =
        Provider.of<AllUsersViewModel>(context, listen: false);
    var _currentUser = _allUsersViewModel.usersList[index];
    if (_currentUser.userID == _userViewModel.user!.userID) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => ChatPage(
              currentUser: _userViewModel.user!,
              conversationUser: _currentUser),
        ));
      },
      child: Card(
        child: ListTile(
          title: Text(_currentUser.userName!),
          subtitle: Text(_currentUser.email!),
          leading: CircleAvatar(
            backgroundColor: Colors.grey.withAlpha(40),
            backgroundImage: NetworkImage(_currentUser.profileURL!),
          ),
        ),
      ),
    );
  }

  _loadingNewElementsIndicator() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _listScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      getMoreUsers();
    }
  }

  void getMoreUsers() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _allUsersViewModel =
          Provider.of<AllUsersViewModel>(context, listen: false);
      await _allUsersViewModel.getMoreUsers();
      _isLoading = false;
    }
  }
}
