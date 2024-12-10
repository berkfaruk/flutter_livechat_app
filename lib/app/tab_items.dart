import 'package:flutter/material.dart';

enum TabItem {
  AllUsers, Profile
}

class TabItemData{
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.AllUsers : TabItemData('Users', Icons.supervised_user_circle),
    TabItem.Profile : TabItemData('Profile', Icons.person),
  };
}