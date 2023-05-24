import 'package:aldeerh_news/admin/operations/comm_operations/comm_allow.dart';
import 'package:aldeerh_news/admin/operations/comm_operations/comm_delete.dart';
import 'package:aldeerh_news/admin/operations/comm_operations/comm_no_shered.dart';
import 'package:aldeerh_news/screens/search.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:flutter/material.dart';

class CommentsAdmin extends StatefulWidget {
  const CommentsAdmin({Key? key}) : super(key: key);

  @override
  State<CommentsAdmin> createState() => _CommentsAdminState();
}

class _CommentsAdminState extends State<CommentsAdmin> {
  int index = 0;

  final screens = [
    const CommentsNoShared(),
    const CommentsAllow(),
    const CommentsDelete(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text("التعليقات"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchUser());
            },
            icon: const Icon(Icons.search_sharp),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          indicatorColor: Colors.white,
          // labelTextStyle: MaterialStateProperty.all(
          //   TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          // ),
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
              selectedIcon: Icon(
                Icons.newspaper_outlined,
                color: Colors.blue,
                size: 30,
              ),
              icon: Icon(
                Icons.newspaper_sharp,
                color: Colors.grey,
              ),
              label: 'تعليقات جديدة',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.newspaper_outlined,
                color: Colors.blue,
                size: 30,
              ),
              icon: Icon(
                Icons.newspaper_sharp,
                color: Colors.grey,
              ),
              label: 'التعليقات',
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
              label: 'التعليقات المحذوفة',
            ),
          ],
        ),
      ),
    );
  }
}
