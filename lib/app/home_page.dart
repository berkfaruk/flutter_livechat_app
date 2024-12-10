// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/app/custom_bottom_navi.dart';
import 'package:flutter_livechat_app/app/profile.dart';
import 'package:flutter_livechat_app/app/tab_items.dart';
import 'package:flutter_livechat_app/app/users.dart';
import 'package:flutter_livechat_app/model/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.AllUsers;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.AllUsers: GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allTabPages() {
    return {
      TabItem.AllUsers: UsersPage(),
      TabItem.Profile: ProfilePage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: CustomBottomNavigation(
        pageCreator: allTabPages(),
        currentTab: _currentTab,
        navigatorKeys: navigatorKeys,
        onSelectedTab: (selectedTab) {
          if (selectedTab == _currentTab) {
            navigatorKeys[selectedTab]!
                .currentState!
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = selectedTab;
            });
          }

          print("Choose Tab Item : ${selectedTab.toString()}");
        },
      ),
    );
  }
}
/*
Future<bool> _logOut(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userViewModel.signOut();
    return result;
  }*/

  /*
  onPopInvoked: (didPop) async => !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
  */
