import 'dart:convert';

import 'package:aldeerh_news/main.dart';
import 'package:aldeerh_news/screens/drawer_pages/edit_news.dart';
import 'package:aldeerh_news/screens/shared_ui/news_details.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class MyNews extends StatefulWidget {
  const MyNews({Key? key, required this.title, required this.type})
      : super(key: key);
  final String title;
  final String type;

  @override
  State<MyNews> createState() => _MyNewsState();
}

class _MyNewsState extends State<MyNews> {
  int? state;
  int _page = 1;

  final Curd curd = Curd();
  bool _isFirstLoadRunning = false;

  bool isConnected = true;

  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  bool isDeleting = false;

  List _news = [];

  late String type;

  late String newsOrAd;

  late ScrollController _controller;

  String userID = sharedPref.getString("usid").toString();

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      if (mounted) {
        setState(() {
          _isLoadMoreRunning = true;
        });
      }
      _page += 1;

      try {
        final res = await http.get(
            Uri.parse("$linkViewMyNews?usid=$userID&type=$type&page=$_page"));

        final List fetchedNews = json.decode(res.body);
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
        if (mounted) {
          setState(() {
            _isLoadMoreRunning = false;
          });
        }
      } catch (e) {
        if (mounted) {
          await AwesomeDialog(
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

          newsRefresh();
        }
      }
    }
  }

  void _firstLoad() async {
    type = widget.type;
    if (mounted) {
      setState(() {
        _isFirstLoadRunning = true;
      });
    }

    try {
      final res = await http.get(
          Uri.parse("$linkViewMyNews?usid=$userID&type=$type&page=$_page"));
      if (mounted) {
        setState(() {
          _news = json.decode(res.body);
        });

        if (mounted) {
          setState(() {
            _isFirstLoadRunning = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        await AwesomeDialog(
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

        newsRefresh();
      }
    }
  }

  Future newsRefresh() async {
    if (mounted) {
      setState(() {
        _page = 1;

        _isFirstLoadRunning = false;

        _hasNextPage = true;

        _isLoadMoreRunning = false;

        _news.clear();
      });
    }
    _firstLoad();
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          _isFirstLoadRunning
              ? const Center(child: CupertinoActivityIndicator())
              : isConnected == false
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
                          'ليس لديك أي أخبار بعد.',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppTheme.appTheme.primaryColor,
                          ),
                        ))
                      : RefreshIndicator(
                          onRefresh: () => newsRefresh(),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: _news.length,
                                        controller: _controller,
                                        itemBuilder: (content, index) =>
                                            buildBodyState(context, index,
                                                _news[index]['ns_img'])),
                                  ),
                                  if (_isLoadMoreRunning == true)
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 40),
                                      child: Center(
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    ),
                                ],
                              ),
                              isDeleting
                                  ? Container(
                                      color: Colors.white38,
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: const Center(
                                          child: CupertinoActivityIndicator()))
                                  : const SizedBox(height: 0),
                            ],
                          ),
                        ),
        ],
      ),
    );
  }

  Widget buildBodyState(BuildContext context, int index, String nsImg) {
    return Container(
      color: const Color.fromRGBO(245, 245, 245, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 4.0, right: 4.0, left: 4.0),
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Stack(
                            children: [
                              const Center(
                                  child:
                                      CupertinoActivityIndicator(radius: 20)),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: FadeInImage.memoryNetwork(
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                  fadeInDuration:
                                      const Duration(milliseconds: 500),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 500),
                                  placeholder: kTransparentImage,
                                  image: linkImageRoot + nsImg,
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                    "assets/AlUyun2.png",
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  placeholderErrorBuilder: (c, o, s) =>
                                      Image.asset(
                                    "assets/AlUyun2.png",
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  // repeat: ImageRepeat.repeat,
                                ),
                              ),
                            ],
                          ),
                          // child: ClipRRect(
                          //   borderRadius: BorderRadius.circular(8.0),
                          //   child: CachedNetworkImage(
                          //     imageUrl: linkImageRoot + nsImg,
                          //     fit: BoxFit.cover,
                          //     placeholder: (context, url) => const Center(
                          //       child: CupertinoActivityIndicator(
                          //         radius: 20,
                          //       ),
                          //     ),
                          //     errorWidget: (context, url, error) =>
                          //         Image.asset('assets/AlUyun.png'),
                          //   ),
                          // ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                            title: Text(
                              _news[index]['ns_title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            subtitle: Text(
                              (() {
                                if (_news[index]['state'] == '2') {
                                  return "قيد المراجعة من قبل الإدارة";
                                } else if (_news[index]['state'] == '1') {
                                  return "تم النشر";
                                }
                                return "محذوف";
                              })(),
                              style: TextStyle(
                                  color: AppTheme.appTheme.primaryColor),
                              overflow: TextOverflow.ellipsis,
                            )),
                      )
                    ],
                  ),
                  Text('تاريخ الرفع: ${_news[index]['ns_da_st']}'),
                  // Text(
                  //     ' ${timeUntil(DateTime.parse(_news[index]["news_date"]))}'),
                  const SizedBox(
                    height: 5,
                  ),
                  _news[index]['state'] == '2'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // IconButton(
                            //   onPressed: () => Get.to(
                            //     () => NewsDetails(
                            //       title: _news[index]['ns_title'],
                            //       nsid: _news[index]['nsid'],
                            //       date: _news[index]['ns_da_st'],
                            //       content: _news[index]['ns_txt'],
                            //       nsImg: _news[index]['ns_img'],
                            //       name: _news[index]['name'],
                            //       type: '1',
                            //       usty: '1',
                            //       usph: _news[index]['usph'].substring(1),
                            //       viewsCount: _news[index]['seen']
                            //           .toString()
                            //           .split(',')
                            //           .length
                            //           .toString(),
                            //       commentsCount: _news[index]['commentsCount'],
                            //     ),
                            //   ),
                            //   icon: Icon(
                            //     Icons.remove_red_eye,
                            //     color: AppTheme.appTheme.primaryColor,
                            //   ),
                            // ),
                            IconButton(
                              onPressed: () => Get.to(
                                () => EditNews(
                                  title: _news[index]['ns_title'],
                                  nsid: _news[index]['nsid'],
                                  content: _news[index]['ns_txt'],
                                  nsImg: _news[index]['ns_img'],
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
                                title: 'تحذير',
                                desc: 'هل أنت متأكد من عملية الحذف',
                                btnOkColor: Colors.red,
                                btnOkText: 'حذف',
                                btnCancelText: 'إلغاء',
                                btnCancelOnPress: () {},
                                btnCancelColor: Colors.blue,
                                btnOkOnPress: () async {
                                  isDeleting = true;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  var response =
                                      await curd.postRequest(linkDeleteNews, {
                                    "nsid": _news[index]['nsid'],
                                    "ns_img": _news[index]['ns_img'],
                                  });
                                  isDeleting = false;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  if (response == 'Error') {
                                    if (mounted) {
                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.TOPSLIDE,
                                        dialogType: DialogType.ERROR,
                                        // dialogColor: AppTheme.appTheme.primaryColor,
                                        title: 'خطأ',
                                        desc: 'تأكد من توفر الإنترنت',
                                        btnOkOnPress: () {
                                          // Get.offAll(() => HomeNews);
                                        },
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
                                        setState(() {
                                          _news.removeAt(index);
                                        });
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.TOPSLIDE,
                                          dialogType: DialogType.SUCCES,
                                          // dialogColor: AppTheme.appTheme.primaryColor,
                                          title: 'نجاح',
                                          desc: 'تمت عملية الحذف بنجاح',
                                          btnCancelOnPress: () {},
                                          btnCancelColor: Colors.blue,
                                          btnCancelText: 'خروج',
                                          // btnCancelOnPress: () {},
                                          // btnCancelColor: AppTheme.appTheme.primaryColor,
                                          // btnCancelText: 'مراسلة الإدارة'
                                        ).show();
                                      }
                                    } else {
                                      if (mounted) {
                                        setState(() {});

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
                              ).show(),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        )
                      : IconButton(
                          onPressed: () => Get.to(
                            () => NewsDetails(
                              title: _news[index]['ns_title'],
                              nsid: _news[index]['nsid'],
                              date: _news[index]['ns_da_st'],
                              content: _news[index]['ns_txt'],
                              nsImg: _news[index]['ns_img'],
                              name: _news[index]['name'],
                              type: '1',
                              usty: '1',
                              usph: _news[index]['usph'].substring(1),
                              viewsCount: _news[index]['con']
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
