import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/app/chat_page.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    _userViewModel.getAllUsers();
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _userViewModel.getAllUsers(),
        builder: (context, usersList) {
          if (usersList.hasData) {
            var allUsers = usersList.data;

            if (allUsers!.length - 1 > 0) {
              return RefreshIndicator(
                onRefresh: _refreshUserList,
                child: ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (context, index) {
                    var currentUser = usersList.data![index];
                    if (currentUser.userID != _userViewModel.user!.userID) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                              currentUser: _userViewModel.user!,
                              conversationUser: currentUser,
                            ),
                          ));
                        },
                        child: ListTile(
                          title: Text(currentUser.userName!),
                          subtitle: Text(currentUser.email!),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(currentUser.profileURL!),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshUserList,
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
                            size: 120,
                          ),
                          Text(
                            'There are no registered users here',
                            style: TextStyle(fontSize: 36),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<Null> _refreshUserList() async {
    setState(() {});
    return null;
  }
}
