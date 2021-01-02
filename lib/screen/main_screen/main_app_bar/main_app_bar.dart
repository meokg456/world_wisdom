import 'package:flutter/material.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_screen.dart';

class MainTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;

  MainTabAppBar(this.name);

  void selectMenuItem(MenuItem item) {
    switch (item) {
      case MenuItem.setting:
        Keys.mainNavigatorKey.currentState.pushNamed("/setting");
        break;
      case MenuItem.profile:
        Keys.mainNavigatorKey.currentState.pushNamed("/profile");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        name,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.account_circle,
            color: Colors.blue,
          ),
          onPressed: () {
            selectMenuItem(MenuItem.profile);
          },
        ),
        PopupMenuButton<MenuItem>(
          onSelected: selectMenuItem,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
            const PopupMenuItem<MenuItem>(
              value: MenuItem.setting,
              child: Text('Settings'),
            ),
            const PopupMenuItem<MenuItem>(
              value: MenuItem.feedback,
              child: Text('Send feedback'),
            ),
            const PopupMenuItem<MenuItem>(
              value: MenuItem.support,
              child: Text('Contact support'),
            ),
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
