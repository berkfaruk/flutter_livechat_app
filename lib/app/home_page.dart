// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final UserModel user;
  HomePage({super.key, required this.user});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: ()=> _logOut(context),
              child: Text(
                'Çıkış Yap',
                style: TextStyle(color: Colors.black),
              ))
        ],
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome ${user.userID}'),
      ),
    );
  }
  
  Future<bool> _logOut(BuildContext context) async{
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userViewModel.signOut();
    return result;
  }
}
