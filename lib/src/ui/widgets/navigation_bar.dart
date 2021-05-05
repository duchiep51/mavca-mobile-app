import 'package:flutter/material.dart';

import '../screens/violation/violation_screen.dart';
import '../screens/report/reports_screen.dart';
import '../screens/settings_screen.dart';

class NavigationBar extends StatefulWidget {
  NavigationBar({Key key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  // final FirebaseNotification firebaseNotification = FirebaseNotification();
  // final _navigatorKey = GlobalKey<NavigatorState>();

  int _selectedIndex = 0;
  // NavigatorState get _navigator => _navigatorKey.currentState;

  static List<Widget> _widgetOptions = <Widget>[
    // ReportsScreen(),
    // ViolationScreen(),
    // SettingsScreen(),
  ];

  static List<String> _titles = ['Reports', 'Violations', 'Settings'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: _titles[0],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.control_camera),
            label: _titles[1],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: _titles[2],
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
