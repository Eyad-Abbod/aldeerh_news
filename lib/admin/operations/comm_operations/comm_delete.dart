import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentsDelete extends StatefulWidget {
  const CommentsDelete({Key? key}) : super(key: key);

  @override
  State<CommentsDelete> createState() => _CommentsDeleteState();
}

class _CommentsDeleteState extends State<CommentsDelete> {
  final homeBucketGlobal = PageStorageBucket();

  final Curd curd = Curd();

  DateTime timeNow = DateTime.now();

  int _page = 1;

  bool _isConnected = true;

  bool _isFirstLoadRunning = false;

  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List comments = [];

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
        final res = await http
            .get(Uri.parse("$linkGetAllComments?page=$_page&state=3"));
        final List fetchedNews = json.decode(res.body);

        if (res.statusCode == 200) {
          if (fetchedNews.isNotEmpty) {
            if (mounted) {
              setState(() {
                comments.addAll(fetchedNews);
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
          debugPrint("Something went wrong4 ${res.statusCode}");
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
      final res =
          await http.get(Uri.parse("$linkGetAllComments?page=$_page&state=3"));
      if (mounted) {
        setState(() {
          comments = json.decode(res.body);
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

        comments.clear();
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
            : comments.isEmpty
                ? Center(
                    child: Text(
                    'ليس هناك أي تعليقات محذوفة ',
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
                            itemCount: comments.length,
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

                                          const SizedBox(height: 5),
                                          // buildBodyState(context, index, curd)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      ),
    );
  }

  buildHeder(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Center(
              child: Text(
                comments[index]['ns_title'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            subtitle: Column(
              children: [
                ListTile(
                  // tileColor: Colors.grey.shade200,

                  title: Row(children: [
                    comments[index]['usty'] == '1'
                        ? const Icon(Icons.person, size: 20)
                        : const Icon(
                            Icons.verified,
                            size: 20,
                            color: Colors.blue,
                          ),
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            onOpen(comments[index]['usph'].substring(1)),
                        child: Text(
                          " ${comments[index]['name']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ]),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      comments[index]['message'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  trailing: Text(
                      ' ${timeUntil(DateTime.parse(comments[index]['date']))}',
                      style: const TextStyle(fontSize: 13)),
                  // trailing: Text(data[i]["date"], style: TextStyle(fontSize: 10)),
                ),
                IconButton(
                  onPressed: () async {
                    await AwesomeDialog(
                      context: context,
                      animType: AnimType.TOPSLIDE,
                      dialogType: DialogType.INFO,
                      // dialogColor: AppTheme.appTheme.primaryColor,
                      title: 'إعادة',
                      desc: 'هل تريد إعادة التعليق',
                      btnOkOnPress: () async {
                        var response =
                            await curd.postRequest(linkCommentsState, {
                          "id": comments[index]['id'],
                          "state": '2',
                        });
                        if (response == 'Error') {
                          if (mounted) {
                            setState(() {});

                            AwesomeDialog(
                              context: context,
                              animType: AnimType.TOPSLIDE,
                              dialogType: DialogType.ERROR,
                              title: 'خطأ',
                              desc: 'تأكد من توفر الإنترنت',
                              btnOkOnPress: () {},
                              btnOkColor: Colors.blue,
                              btnOkText: 'خروج',
                            ).show();
                          }
                        } else {
                          if (mounted) {
                            if (response['status'] == 'success') {
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.TOPSLIDE,
                                dialogType: DialogType.SUCCES,
                                title: 'نجاح',
                                desc: 'تمت إعادة التعليق بنجاح',
                                btnOkOnPress: () {},
                                btnOkColor: Colors.blue,
                                btnOkText: 'خروج',
                              ).show();
                              setState(() {
                                comments.removeAt(index);
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
                      btnOkColor: Colors.green,
                      btnOkText: 'إعادة',
                      btnCancelOnPress: () {},
                      btnCancelColor: Colors.blue,
                      btnCancelText: 'تراجع',
                    ).show();
                  },
                  icon: const Icon(Icons.settings),
                )
              ],
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
