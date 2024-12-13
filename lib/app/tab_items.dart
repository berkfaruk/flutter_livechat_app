import 'package:flutter/material.dart';

enum TabItem {
  AllUsers, Chats, Profile
}

class TabItemData{
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.AllUsers : TabItemData('Users', Icons.supervised_user_circle),
    TabItem.Chats : TabItemData('Chats', Icons.chat),
    TabItem.Profile : TabItemData('Profile', Icons.person),
  };
}