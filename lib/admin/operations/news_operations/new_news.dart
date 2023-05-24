import 'package:aldeerh_news/admin/operations/edit_news_admin.dart';
import 'package:aldeerh_news/screens/shared_ui/news_details.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class NewNewsOperations extends StatefulWidget {
  final int newsType;
  const NewNewsOperations({Key? key, required this.newsType}) : super(key: key);

  @override
  State<NewNewsOperations> createState() => _NewNewsOperationsState();
}

class _NewNewsOperationsState extends State<NewNewsOperations> {
  final homeBucketGlobal = PageStorageBucket();

  final Curd curd = Curd();

  DateTime timeNow = DateTime.now();

  int _page = 1;

  bool _isConnected = true;

  bool _isFirstLoadRunning = false;

  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List _news = [];

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _isConnected == true &&
        _controller.position.extentAfter < 220) {
      if (mounted) {
        setState(() => _isLoadMoreRunning = true);
      }

      _page += 1;

      try {
        final res = await http.get(Uri.parse(
            "$linkNewsOperations?page=$_page&newsState=2&newsType=${widget.newsType}"));

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
            showDilogBox();
          }
        }
      } catch (e) {
        _isConnected = false;
        if (mounted) {
          showDilogBox();
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

    try {
      final res = await http.get(Uri.parse(
          "$linkNewsOperations?page=$_page&newsState=2&newsType=${widget.newsType}"));
      if (mounted) {
        setState(() {
          _news = json.decode(res.body);
        });
      }
    } catch (e) {
      _isConnected = false;
      if (mounted) {
        showDilogBox();
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
    return Scaffold(
      body: PageStorage(
        bucket: homeBucketGlobal,
        child: _isFirstLoadRunning
            ? const Center(child: CupertinoActivityIndicator())
            : _news.isEmpty
                ? Center(
                    child: Text(
                    'ليس هناك أي أخبار جديدة حالياً',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppTheme.appTheme.primaryColor,
                    ),
                  ))
                : RefreshIndicator(
                    onRefresh: () => newsRefresh(),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _news.length,
                            controller: _controller,
                            itemBuilder: (content, index) => Container(
                              color: const Color.fromRGBO(245, 245, 245, 1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, right: 4.0, left: 4.0),
                                    child: Card(
                                      elevation: 3.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 5),
                                          buildHeder(context, index),
                                          Text(
                                            'تاريخ الرفع: ${_news[index]["ns_da_st"]}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                          DateTime.parse(
                                                      _news[index]["ns_da_en"])
                                                  .isAfter(timeNow)
                                              ? Text(
                                                  'انتهاء العرض: ${_news[index]["ns_da_en"]}',
                                                  style: const TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 16),
                                                )
                                              : Text(
                                                  'انتهاء العرض: ${_news[index]["ns_da_en"]}',
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16),
                                                ),
                                          // Text(
                                          //     'تاريخ الرفع: ${_news[index]["ns_da_st"]}'),
                                          const SizedBox(height: 5),
                                          buildBodyState(context, index, curd)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // itemBuilder: (content, index) => NewsOperation(
                          //   ontap: () {
                          //     _news.remove(index);
                          //   },
                          //   title: _news[index]['ns_title'],
                          //   content: _news[index]['ns_txt'],
                          //   date: _news[index]['ns_da_st'],
                          //   id: _news[index]['usid'],
                          //   nsid: _news[index]['nsid'],
                          //   newsOrAd: '1',
                          //   nsImg: _news[index]['ns_img'],
                          //   name: _news[index]['name'],
                          //   state: _news[index]['state'],
                          //   typeOfNews: '1',
                          // )),
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
      ),
    );
  }

  buildBodyState(BuildContext context, int index, crud) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => Get.to(
                () => NewsDetails(
                  title: _news[index]['ns_title'],
                  nsid: _news[index]['nsid'],
                  date: _news[index]['ns_da_st'],
                  content: _news[index]['ns_txt'],
                  nsImg: _news[index]['ns_img'],
                  name: _news[index]['name'],
                  type: _news[index]['ns_ty'],
                  usty: _news[index]['usty'],
                  usph: _news[index]['usph'].substring(1),
                  viewsCount: _news[index]['seen']
                      .toString()
                      .split(',')
                      .length
                      .toString(),
                  commentsCount: _news[index]['commentsCount'],
                ),
              ),
              icon: Icon(
                Icons.remove_red_eye,
                color: AppTheme.appTheme.primaryColor,
              ),
            ),
            IconButton(
              onPressed: () => Get.to(
                () => EditNewsAdmin(
                  screenType: widget.newsType,
                  title: _news[index]['ns_title'],
                  nsid: _news[index]['nsid'],
                  content: _news[index]['ns_txt'],
                  nsImg: _news[index]['ns_img'],
                  name: _news[index]['name'],
                  type: int.parse(_news[index]['ns_ty']),
                  typeOf: int.parse(_news[index]['ns_pos']),
                  usty: _news[index]['usty'],
                  dateEnd: DateTime.parse(_news[index]['ns_da_en']),
                  usph: _news[index]['usph'].substring(1),
                  direct: false,
                  newsState: int.parse(_news[index]['state']),
                ),
              ),
              icon: const Icon(
                Icons.mode_edit_outline,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () => AwesomeDialog(
                context: context,
                animType: AnimType.TOPSLIDE,
                dialogType: DialogType.INFO,
                // dialogColor: AppTheme.appTheme.primaryColor,
                title: 'نشر أو حذف',
                desc: 'هل تريد نشر المنشور أو حذفه؟',
                btnOkOnPress: () async {
                  var response = await crud.postRequest(linkNewsState, {
                    "nsid": _news[index]['nsid'],
                    "state": '3',
                  });
                  if (response == 'Error') {
                    if (mounted) {
                      setState(() {});

                      AwesomeDialog(
                        context: context,
                        animType: AnimType.TOPSLIDE,
                        dialogType: DialogType.ERROR,
                        // dialogColor: AppTheme.appTheme.primaryColor,
                        title: 'خطأ',
                        desc: 'تأكد من توفر الإنترنت',
                        btnOkOnPress: () {},
                        btnOkColor: Colors.blue,
                        btnOkText: 'خروج',
                        // btnCancelOnPress: () {},
                        // btnCancelColor: AppTheme.appTheme.primaryColor,
                        // btnCancelText: 'مراسلة الإدارة'
                      ).show();
                    }
                  } else {
                    if (response['status'] == 'success') {
                      if (mounted) {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.TOPSLIDE,
                          dialogType: DialogType.SUCCES,
                          // dialogColor: AppTheme.appTheme.primaryColor,
                          title: 'نجاح',
                          desc: 'تمت عملية الحذف بنجاح',
                          btnOkOnPress: () {
                            // Get.back();
                            // Get.to(() => MyNews(title: newsOrAd, type: typeOfNews));
                          },
                          btnOkColor: Colors.blue,
                          btnOkText: 'خروج',
                        ).show();
                        setState(() {
                          _news.removeAt(index);
                        });
                      }
                    } else {
                      if (mounted) {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.TOPSLIDE,
                          dialogType: DialogType.ERROR,
                          title: 'خطأ',
                          desc: 'تأكد من توفر الإنترنت',
                        ).show();
                      }
                    }
                  }
                },

                btnOkColor: Colors.red,
                btnOkText: 'حذف',
                btnCancelText: 'نشر',
                btnCancelOnPress: () async {
                  var response = await crud.postRequest(linkNewsState, {
                    "nsid": _news[index]['nsid'],
                    "state": '1',
                  });
                  if (response == 'Error') {
                    if (mounted) {
                      setState(() {});

                      AwesomeDialog(
                        context: context,
                        animType: AnimType.TOPSLIDE,
                        dialogType: DialogType.ERROR,
                        // dialogColor: AppTheme.appTheme.primaryColor,
                        title: 'خطأ',
                        desc: 'تأكد من توفر الإنترنت',
                        btnOkOnPress: () {},
                        btnOkColor: Colors.blue,
                        btnOkText: 'خروج',
                        // btnCancelOnPress: () {},
                        // btnCancelColor: AppTheme.appTheme.primaryColor,
                        // btnCancelText: 'مراسلة الإدارة'
                      ).show();
                    }
                  } else {
                    if (response['status'] == 'success') {
                      if (widget.newsType.toString() == '1' ||
                          widget.newsType.toString() == '2' ||
                          widget.newsType.toString() == '3') {
                        curd.postRequestNotifications(
                          _news[index]['ns_title'],
                          _news[index]['name'],
                          _news[index]['nsid'],
                        );
                      }
                      if (mounted) {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.TOPSLIDE,
                          dialogType: DialogType.SUCCES,
                          // dialogColor: AppTheme.appTheme.primaryColor,
                          title: 'نجاح',
                          desc: 'تمت عملية النشر بنجاح',
                          btnOkOnPress: () {},
                          btnOkColor: Colors.blue,
                          btnOkText: 'خروج',
                        ).show();
                        setState(() {
                          _news.removeAt(index);
                        });
                      }
                    } else {
                      if (mounted) {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.TOPSLIDE,
                          dialogType: DialogType.ERROR,
                          title: 'خطأ',
                          desc: 'تأكد من توفر الإنترنت',
                        ).show();
                      }
                    }
                  }
                },
                btnCancelColor: Colors.blue,
              ).show(),
              icon: const Icon(
                Icons.settings,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildHeder(BuildContext context, int index) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 100.0,
            height: 100.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                height: 100,
                width: 100,
                fadeInDuration: const Duration(milliseconds: 500),
                fadeOutDuration: const Duration(milliseconds: 500),
                placeholder: kTransparentImage,
                image: linkImageRoot + _news[index]['ns_img'],
                imageErrorBuilder: (c, o, s) => Image.asset(
                  "assets/AlUyun2.png",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                placeholderErrorBuilder: (c, o, s) => Image.asset(
                  "assets/AlUyun2.png",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                // repeat: ImageRepeat.repeat,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(
              _news[index]['ns_title'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            subtitle: InkWell(
              onTap: () => onOpen(_news[index]['usph'].substring(1)),
              child: Row(
                children: [
                  _news[index]['usty'] == '1'
                      ? Icon(
                          Icons.person,
                          size: 22,
                          color: AppTheme.appTheme.primaryColor,
                        )
                      : const Icon(
                          Icons.verified,
                          size: 22,
                          color: Colors.blue,
                        ),
                  Flexible(
                    child: Text(
                      ' ${_news[index]['name']}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
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
                newsRefresh();
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
