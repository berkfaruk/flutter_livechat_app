import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/common_widget/home_page.dart';
import 'package:flutter_livechat_app/common_widget/sign_in_page.dart';
import 'package:flutter_livechat_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);

    if (_userViewModel.state == ViewState.Idle) {
      if (_userViewModel.user == null) {
        return SignInPage();
      } else {
        return HomePage(user: _userViewModel.user!);
      }
    } else {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
