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
    if (_user != null) print("Sign In User ID : " + _user.userID.toString());
  }

  void _facebookLogin(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel? _user = await _userViewModel.signInWithFacebook();
    if (_user != null) print("Sign In User ID : " + _user.userID.toString());
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
      backgroundColor: Colors.blue,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.message_outlined, color: Colors.white, size: 120),
            const Text(
              'Live Chat',
              style: TextStyle(
                  fontSize: 46,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SocialLogInButton(
              buttonColor: Colors.deepOrange.shade700,
              textColor: Colors.white,
              buttonText: 'Sign In with Email',
              onPressed: () => _emailPasswordLogin(context),
              buttonIcon: const Icon(Icons.email, color: Colors.white),
            ),
            SocialLogInButton(
              buttonColor: Colors.grey.shade300,
              textColor: Colors.black,
              buttonText: 'Sign In with Google',
              onPressed: () => _googleLogin(context),
              buttonIcon: Image.asset('images/google-logo.png'),
            ),
            SocialLogInButton(
              buttonColor: const Color(0xFF334D92),
              textColor: Colors.white,
              buttonText: 'Sign In with Facebook',
              buttonIcon: Image.asset('images/facebook-logo.png'),
              onPressed: () => _facebookLogin(context),
            ),
          ],
        ),
      ),
    );
  }
}
