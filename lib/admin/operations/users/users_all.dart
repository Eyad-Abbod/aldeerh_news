import 'package:aldeerh_news/admin/operations/users/users_allow.dart';
import 'package:aldeerh_news/admin/operations/users/users_stop.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  int index = 0;

  final screens = [
    const AllowUsers(),
    const StopedUsers(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text("المستخدمين"),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          indicatorColor: Colors.white,
        ),
        child: NavigationBar(
          height: 60,
          // animationDuration: Duration(seconds: 1),
          backgroundColor: Colors.white30,
          // backgroundColor: AppTheme.appTheme.primaryColor,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.newspaper_sharp,
                color: Colors.grey,
              ),
              selectedIcon: Icon(
                Icons.newspaper,
                color: Color.fromARGB(255, 20, 192, 29),
                size: 30,
              ),
              label: 'المستخدمين',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              selectedIcon: Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
              ),
              label: 'المحضورين',
            ),
          ],
        ),
      ),
    );
  }
}
