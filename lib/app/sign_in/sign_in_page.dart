// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/app/sign_in/email_password_login_register.dart';
import 'package:flutter_livechat_app/common_widget/social_log_in_button.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  void _googleLogin(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel? _user = await _userViewModel.signInWithGoogle();
    if (_user != null)
      print("Oturum açan User ID : " + _user.userID.toString());
  }

  void _facebookLogin(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel? _user = await _userViewModel.signInWithFacebook();
    if (_user != null)
      print("Oturum açan User ID : " + _user.userID.toString());
  }

  void _emailPasswordLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailPasswordLoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Oturum Açın',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(height: 8),
            SocialLogInButton(
              textColor: Colors.black,
              buttonText: 'Email ile Oturum Aç',
              onPressed: () => _emailPasswordLogin(context),
              buttonIcon: Icon(Icons.email, color: Colors.black),
            ),
            SocialLogInButton(
              textColor: Colors.black,
              buttonText: 'Google ile Oturum Aç',
              onPressed: () => _googleLogin(context),
              buttonIcon: Image.asset('images/google-logo.png'),
            ),
            SocialLogInButton(
              buttonColor: Color(0xFF334D92),
              textColor: Colors.white,
              buttonText: 'Facebook ile Oturum Aç',
              buttonIcon: Image.asset('images/facebook-logo.png'),
              onPressed: () => _facebookLogin(context),
            ),
          ],
        ),
      ),
    );
  }
}
