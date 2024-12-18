// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/app/chats_page.dart';
import 'package:flutter_livechat_app/app/custom_bottom_navi.dart';
import 'package:flutter_livechat_app/app/profile.dart';
import 'package:flutter_livechat_app/app/tab_items.dart';
import 'package:flutter_livechat_app/app/users.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/viewmodel/all_users_view_model.dart';
import 'package:provider/provider.dart';

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
    TabItem.Chats: GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allTabPages() {
    return {
      TabItem.AllUsers: ChangeNotifierProvider(
        create: (context) => AllUsersViewModel(),
        child: UsersPage(),
      ),
      TabItem.Chats: ChatsPage(),
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
        },
      ),
    );
  }
}
