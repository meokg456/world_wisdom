import 'package:flutter/material.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/screen/account_management/profile/profile_screen.dart';
import 'package:world_wisdom/screen/account_management/setting/setting_screen.dart';
import 'package:world_wisdom/screen/course/course_detail/course_detail_screen.dart';
import 'package:world_wisdom/screen/course/course_list/course_list_screen.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/browse_tab/browse_tab.dart';
import 'package:world_wisdom/screen/main_screen/download_tab/download_tab.dart';
import 'package:world_wisdom/screen/main_screen/home_tab/home_tab.dart';
import 'package:world_wisdom/screen/main_screen/search_tab/search_tab.dart';
import 'package:provider/provider.dart';
import 'package:world_wisdom/screen/screen_mode/app_mode.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

enum MenuItem { setting, feedback, support, profile }

class TabData {
  String tabName = "";
  IconData iconData;
  Widget tab;

  TabData(this.tabName, this.iconData, this.tab);
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<TabData> tabs = [];

  void selectedTab(int selectedItem) {
    setState(() {
      _selectedIndex = selectedItem;
      FocusScope.of(context).unfocus();
      Keys.mainNavigatorKey.currentState
          .popUntil((route) => route.settings.name == "/");
    });
  }

  Future<bool> onPop() async {
    if (Keys.mainNavigatorKey.currentState.canPop()) {
      Keys.mainNavigatorKey.currentState.maybePop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    tabs.clear();
    tabs.addAll([
      TabData(S.of(context).home, Icons.home_outlined, HomeTab()),
      TabData(S.of(context).download, Icons.arrow_circle_down_outlined,
          DownloadTab()),
      TabData(S.of(context).browse, Icons.apps, BrowseTab()),
      TabData(S.of(context).search, Icons.search, SearchTab())
    ]);
    bool isFullScreen =
        context.select((AppMode mode) => mode.isWatchingExpandedVideo);
    return WillPopScope(
      onWillPop: onPop,
      child: Scaffold(
        body: Navigator(
          key: Keys.mainNavigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            // Manage your route names here
            switch (settings.name) {
              case '/':
                builder = (BuildContext context) => tabs[_selectedIndex].tab;
                break;
              case '/setting':
                builder = (BuildContext context) => SettingScreen();
                break;
              case '/feedback':
                builder = (BuildContext context) => SettingScreen();
                break;
              case '/support':
                builder = (BuildContext context) => SettingScreen();
                break;
              case '/profile':
                builder = (BuildContext context) => ProfileScreen();
                break;
              case '/course-list':
                builder = (BuildContext context) => CourseListScreen();
                break;
              case '/course-detail':
                builder = (BuildContext context) => CourseDetailScreen();
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
            // You can also return a PageRouteBuilder and
            // define custom transitions between pages
            return MaterialPageRoute(
              builder: builder,
              settings: settings,
            );
          },
        ),
        bottomNavigationBar: isFullScreen
            ? null
            : BottomNavigationBar(
                key: Keys.bottomNavigationBarKey,
                items: List<BottomNavigationBarItem>.generate(
                    4,
                    (index) => BottomNavigationBarItem(
                        icon: Icon(tabs[index].iconData),
                        label: tabs[index].tabName)),
                showUnselectedLabels: true,
                onTap: selectedTab,
                currentIndex: _selectedIndex,
                type: BottomNavigationBarType.fixed,
              ),
      ),
    );
  }
}
