import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/app/tab_items.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation(
      {super.key, required this.currentTab, required this.onSelectedTab, required this.pageCreator, required this.navigatorKeys});

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageCreator;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _createNavItem(TabItem.AllUsers),
          _createNavItem(TabItem.Chats),
          _createNavItem(TabItem.Profile),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final showItem = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[showItem],
          builder: (context) {
            return pageCreator[showItem] ?? const Center(child: Text('Page Not Found'),);
          }
        );
      },
    );
  }

  BottomNavigationBarItem _createNavItem(TabItem tabItem) {
    final createTab = TabItemData.allTabs[tabItem];

    return BottomNavigationBarItem(
        icon: Icon(createTab!.icon), label: createTab.title);
  }
}
