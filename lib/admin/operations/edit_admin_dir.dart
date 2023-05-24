import 'dart:convert';

import 'package:aldeerh_news/admin/operations/edit_news_admin.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class NewsForAdminDirectly extends StatefulWidget {
  final int newsID;
  final String title;
  const NewsForAdminDirectly(
      {super.key, required this.newsID, required this.title});

  @override
  State<NewsForAdminDirectly> createState() => _NewsForAdminDirectlyState();
}

class _NewsForAdminDirectlyState extends State<NewsForAdminDirectly> {
  List news = [];
  bool isLoadRunning = true;
  bool isConnected = true;

  @override
  void initState() {
    firstLoad();
    super.initState();
  }

  void firstLoad() async {
    try {
      final res = await http
          .get(Uri.parse("$linkNewsFromNotifications?nsid=${widget.newsID}"));
      if (mounted) {
        setState(() {
          news = json.decode(res.body);
        });
      }
      if (mounted) {
        setState(() {
          isLoadRunning = false;
        });
      }
    } catch (e) {
      isConnected = false;
      if (mounted) {
        showDilogBox();
      }
      debugPrint("Something went wrong1");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppTheme.appTheme.primaryColor,
      //   title: Text(widget.title),
      //   centerTitle: true,
      // ),
      body: isLoadRunning == true
          ? Container(
              color: Colors.white,
              child: Center(
                  child: CupertinoActivityIndicator(
                color: AppTheme.appTheme.primaryColor,
              )))
          : EditNewsAdmin(
              content: news[0]['ns_txt'],
              nsImg: news[0]['ns_img'],
              nsid: news[0]['nsid'],
              screenType: int.parse(news[0]['ns_ty']),
              title: news[0]['ns_title'],
              name: news[0]['name'],
              type: int.parse(news[0]['ns_ty']),
              typeOf: int.parse(news[0]['ns_pos']),
              usty: news[0]['usty'],
              dateEnd: DateTime.parse(news[0]['ns_da_en']),
              usph: news[0]['usph'],
              direct: true,
              newsState: int.parse(news[0]['state']),
            ),
    );
  }

  showDilogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('لا يتوفر إتصال بالإنترنت'),
          content: const Text('أعد الإتصال بالإنترنت'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                // newsRefresh();
              },
              child: Text(
                'OK',
                style: TextStyle(color: AppTheme.appTheme.primaryColor),
              ),
            )
          ],
        ),
      );
}
