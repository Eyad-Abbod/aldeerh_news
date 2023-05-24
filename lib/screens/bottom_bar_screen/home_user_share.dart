import 'dart:convert';
import 'package:aldeerh_news/auth/login.dart';
import 'package:aldeerh_news/main.dart';
import 'package:aldeerh_news/screens/drawer_pages/add_from_bottmo_screen.dart';
import 'package:aldeerh_news/screens/shared_ui/card_news.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeUserShare extends StatefulWidget {
  const HomeUserShare({Key? key}) : super(key: key);

  @override
  State<HomeUserShare> createState() => _HomeUserShareState();
}

class _HomeUserShareState extends State<HomeUserShare> {
  int _page = 1;

  bool _isConnected = true;

  bool _isFirstLoadRunning = false;

  String userId = '0';

  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List _news = [];

  void _loadMore() async {
    // checkStatus();
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _isConnected == true &&
        _controller.position.extentAfter < 300) {
      if (mounted) {
        setState(() {
          _isLoadMoreRunning = true;
        });
      }
      _page += 1;

      if (sharedPref.getString("usid") != null) {
        userId = sharedPref.getString("usid")!;
      }
      try {
        final res = await http.get(
            Uri.parse("$linkViewPersons?page=$_page&type=4&userid=$userId"));

        final List fetchedNews = json.decode(res.body);

        if (res.statusCode == 200) {
          if (fetchedNews.isNotEmpty) {
            if (mounted) {
              setState(() {
                _news.addAll(fetchedNews);
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _hasNextPage = false;
              });
            }
          }
        } else {
          _hasNextPage = false;
          _isConnected = false;
          if (mounted) {
            setState(() {});
          }
          debugPrint("Something went wrong4 ${res.statusCode}");
        }
      } catch (e) {
        _isConnected = false;
        if (mounted) {
          setState(() {});
        }
        debugPrint("Something went wrong2");
      }
      if (mounted) {
        setState(() {
          _isLoadMoreRunning = false;
        });
      }
    }
  }

  void _firstLoad() async {
    if (mounted) {
      setState(() {
        _isFirstLoadRunning = true;
      });
    }

    if (sharedPref.getString("usid") != null) {
      userId = sharedPref.getString("usid")!;
    }
    try {
      final res = await http
          .get(Uri.parse("$linkViewPersons?page=$_page&type=4&userid=$userId"));
      if (mounted) {
        setState(() {
          _news = json.decode(res.body);
        });
      }
    } catch (e) {
      _isConnected = false;
      if (mounted) {
        setState(() {});
      }
      if (kDebugMode) {
        print("Something went wrong1");
      }
    }
    if (mounted) {
      setState(() {
        _isFirstLoadRunning = false;
      });
    }
  }

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();

    _controller = ScrollController()..addListener(_loadMore);

    // DateTime now = DateTime.now();
    // DateTime formatter =  DateFormat('yyyy-MM-dd');
    // formattedDate = now;
    // print(formattedDate);
    // _controller = ScrollController()..addListener(_loadMore);
  }

  Future newsRefresh() async {
    if (mounted) {
      setState(() {
        _page = 1;

        _isConnected = true;

        _isFirstLoadRunning = false;

        _hasNextPage = true;

        _isLoadMoreRunning = false;

        _news.clear();
      });
    }
    _firstLoad();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: '2',
        backgroundColor: AppTheme.appTheme.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () => sharedPref.getString("name") == null
            ? Get.to(() => const Login())
            : Get.to(() =>
                const AddFromBottomScreen(title: 'خواطر ومشاركات', type: '4')),
      ),
      body: _isFirstLoadRunning
          ? const Center(child: CupertinoActivityIndicator())
          : _isConnected == false
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off,
                        color: AppTheme.appTheme.primaryColor, size: 44),
                    Text(
                      'لا يوجد اتصال بالإنترنت',
                      style: TextStyle(
                        fontSize: 22,
                        color: AppTheme.appTheme.primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton.extended(
                        label: const Text('اعادة تحميل'), // <-- Text
                        backgroundColor: AppTheme.appTheme.primaryColor,
                        icon: const Icon(
                          // <-- Icon
                          Icons.refresh,
                          size: 24.0,
                        ),
                        onPressed: () => newsRefresh(),
                      ),
                    ),
                  ],
                ))
              : _news.isEmpty
                  ? Center(
                      child: Text(
                        'ليس هناك أي مقالات حالياً',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: AppTheme.appTheme.primaryColor,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => newsRefresh(),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: _news.length,
                              controller: _controller,
                              itemBuilder: (content, index) =>
                                  // formattedDate.isBefore('2020-2-2')
                                  //     ? SizedBox(height: 0)
                                  //     :
                                  CardNews(
                                      ontap: () {
                                        // Get.to(NewsDetails(
                                        //   title: _news[index]['ns_title'],
                                        //   content: _news[index]['ns_txt'],
                                        //   date: _news[index]['ns_da_st'],
                                        //   id: _news[index]['usid'],
                                        //   nsImg: _news[index]['ns_img'],
                                        // ));
                                      },
                                      title: _news[index]['ns_title'],
                                      nsTxt: _news[index]['ns_txt'],
                                      dateAndTime:
                                          _news[index]['news_date'].toString(),
                                      date: _news[index]['ns_da_st'],
                                      usid: _news[index]['usid'],
                                      con: _news[index]['seen'].toString(),
                                      nsImg: _news[index]['ns_img'],
                                      name: _news[index]['name'],
                                      nsid: _news[index]['nsid'],
                                      usty: _news[index]['usty'],
                                      usph: _news[index]['usph'],
                                      imagesCount: _news[index]['imagesCount']
                                          .toString(),
                                      commentsCount: _news[index]
                                              ['commentsCount']
                                          .toString(),
                                      newsState: _news[index]['state']),
                            ),
                          ),
                          if (_isLoadMoreRunning == true)
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                        ],
                      ),
                    ),
    );
  }

  // showDilogBox() => showCupertinoDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) => CupertinoAlertDialog(
  //         title: const Text('لا يتوفر إتصال بالإنترنت'),
  //         content: const Text('أعد الإتصال بالإنترنت'),
  //         actions: [
  //           TextButton(
  //               onPressed: () async {
  //                 Navigator.pop(context, 'Cancel');
  //                 newsRefresh();
  //               },
  //               child: Text(
  //                 'OK',
  //                 style: TextStyle(color: AppTheme.appTheme.primaryColor),
  //               ))
  //         ],
  //       ),
  //     );
}
