import 'dart:convert';

import 'package:aldeerh_news/auth/login.dart';
import 'package:aldeerh_news/main.dart';
import 'package:aldeerh_news/screens/home_screen.dart';
import 'package:aldeerh_news/screens/shared_ui/comments_test.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';

import 'package:aldeerh_news/utilities/valid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Comments extends StatefulWidget {
  const Comments({super.key, required this.nsid, required this.title});
  final String nsid;
  final String title;
  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  // List<NewsCommentModel> newsComments = <NewsCommentModel>[];

  // var splitted;

  int _page = 1;

  String userId = '0';

  bool isConnected = true;

  bool _isFirstLoadRunning = false;

  bool hasNextPage = true;

  bool isLoadMoreRunning = false;

  List _news = [];
  String newsId = '';
  bool isLoading = false;
  bool isUpdateing = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  var isDeviceConnected = false;
  bool isAlertSet = false;
  bool canSendNews = true;

  @override
  void dispose() {
    // streamSubscription.cancel();
    super.dispose();
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  final Curd curd = Curd();

  void firstLoad() async {
    if (mounted) {
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    if (sharedPref.getString("usid") != null) {
      userId = sharedPref.getString("usid")!;
    }
    try {
      final res = await http.get(Uri.parse(
          "$linkGetNewsComments?nsid=$newsId&page=$_page&userid=$userId"));
      if (mounted) {
        setState(() {
          _news = json.decode(res.body);
        });
      }
    } catch (e) {
      isConnected = false;
      if (mounted) {
        showDilogBox();
      }
      debugPrint("Something went wrong1");
    }
    if (mounted) {
      setState(() {
        _isFirstLoadRunning = false;
      });
    }
  }

  void secondLoad() async {
    _news.clear();
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    if (sharedPref.getString("usid") != null) {
      userId = sharedPref.getString("usid")!;
    }
    try {
      final res = await http.get(Uri.parse(
          "$linkGetNewsComments?nsid=$newsId&page=$_page&userid=$userId"));
      if (mounted) {
        setState(() {
          _news = json.decode(res.body);
        });
      }
    } catch (e) {
      isConnected = false;
      if (mounted) {
        showDilogBox();
      }
      debugPrint("Something went wrong1");
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future newsRefresh() async {
    if (mounted) {
      setState(() {
        _page = 1;

        isConnected = true;

        isLoading = false;

        hasNextPage = true;

        isLoadMoreRunning = false;

        _news.clear();
      });
    }
    secondLoad();
  }

  @override
  void initState() {
    super.initState();

    newsId = widget.nsid;
    firstLoad();
  }

  // List filedata = [
  //   {
  //     'name': 'أحمد السبيعي',
  //     'pic': 'https://picsum.photos/300/30',
  //     'message': 'ألف مبارك عليكم الزواج وإنشاء الله منك المال ومنها العيال',
  //     'date': '2021-01-01 12:00:00'
  //   },
  //   {
  //     'name': 'أنور بجاش العودي',
  //     'pic': 'https://www.adeleyeayodeji.com/img/IMG_20200522_121756_834_2.jpg',
  //     'message': 'فين بتكون التخزينة',
  //     'date': '2021-01-01 12:00:00'
  //   },
  //   {
  //     'name': 'لؤي',
  //     'pic': 'assets/home.png',
  //     'message': 'ممتاز الله يوفقك',
  //     'date': '2021-01-01 12:00:00'
  //   },
  //   {
  //     'name': 'صلاح الحاج',
  //     'pic': 'https://picsum.photos/300/30',
  //     'message': 'هههههههههههههههههه',
  //     'date': '2021-01-01 12:00:00'
  //   },
  // ];

  addComment() async {
    FocusScope.of(context).unfocus();
    if (sharedPref.getString("name") == null) {
      AwesomeDialog(
        context: context,
        animType: AnimType.TOPSLIDE,
        dialogType: DialogType.INFO,
        // dialogColor: AppTheme.appTheme.primaryColor,
        title: 'خطأ',
        desc: 'لابد من تسجيل الدخول',
        btnOkOnPress: () => Get.to(() => const Login()),
        btnOkColor: Colors.green,
        btnOkText: 'الانتقال لصفحة تسجيل الدخول',
        // btnCancelOnPress: () {},
        // btnCancelColor: AppTheme.appTheme.primaryColor,
        // btnCancelText: 'مراسلة الإدارة'
      ).show();
    } else {
      if (canSendNews == true) {
        canSendNews = false;

        isLoading = true;
        if (mounted) {
          setState(() {});
        }

        var response = await curd.postRequest(
          linkAddComments,
          {
            'nsid': widget.nsid,
            'usid': sharedPref.getString('usid'),
            'message': commentController.text,
            'state': '2',
          },
        );
        if (mounted) {
          setState(() {});
        }

        if (response == 'Error') {
          canSendNews = true;
          isLoading = false;
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
          canSendNews = false;
        } else {
          if (response['status'] == 'success') {
            commentController.clear();
            canSendNews = true;
            secondLoad();
          } else if (response['status'] == 'cannot') {
            canSendNews = true;
            isLoading = false;
            if (mounted) {
              setState(() {});

              AwesomeDialog(
                context: context,
                animType: AnimType.TOPSLIDE,
                dialogType: DialogType.INFO,
                // dialogColor: AppTheme.appTheme.primaryColor,
                title: 'خطأ',
                desc: 'ليس لديك صلاحية التعليق راسل الإدارة',
                btnOkOnPress: () {},
                btnOkColor: Colors.blue,
                btnOkText: 'خروج',
                // btnCancelOnPress: () {},
                // btnCancelColor: AppTheme.appTheme.primaryColor,
                // btnCancelText: 'مراسلة الإدارة'
              ).show();
            }
          } else {
            canSendNews = true;
            isLoading = false;
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
          }
        }
      }
    }
  }

  Widget commentChild(data) {
    if (isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    } else {
      return _news.isEmpty
          ? RefreshIndicator(
              onRefresh: () => newsRefresh(),
              child: Center(
                  child: Text(
                'كن أول من يعلق على الخبر',
                style: TextStyle(
                  fontSize: 20,
                  color: AppTheme.appTheme.primaryColor,
                ),
              )),
            )
          : RefreshIndicator(
              onRefresh: () => newsRefresh(),
              child: ListView.builder(
                  itemCount: _news.length,
                  itemBuilder: (content, i) => Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                        child: InkWell(
                          onLongPress: () async {
                            if (sharedPref.getString("usid") != null) {
                              var response = await curd.postRequest(
                                  linkCheckAdmin,
                                  {'usid': sharedPref.getString("usid")});
                              if (response == 'Error') {
                              } else {
                                if (response['status'] == 'success') {
                                  if (response['data']['usty'] == '2' ||
                                      response['data']['usty'] == '3') {
                                    if (mounted) {
                                      await AwesomeDialog(
                                        context: context,
                                        animType: AnimType.TOPSLIDE,
                                        dialogType: DialogType.SUCCES,
                                        // dialogColor: AppTheme.appTheme.primaryColor,
                                        title: 'Dashbord',
                                        desc: 'هل تريد حذف التعليق',
                                        btnOkOnPress: () async {
                                          var response = await curd
                                              .postRequest(linkCommentsState, {
                                            "id": _news[i]['id'],
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
                                            if (response['status'] ==
                                                'success') {
                                              if (mounted) {
                                                AwesomeDialog(
                                                  context: context,
                                                  animType: AnimType.TOPSLIDE,
                                                  dialogType: DialogType.SUCCES,
                                                  // dialogColor: AppTheme.appTheme.primaryColor,
                                                  title: 'نجاح',
                                                  desc:
                                                      'تمت عملية حذف التعليق بنجاح',
                                                  btnOkOnPress: () {},
                                                  btnOkColor: Colors.blue,
                                                  btnOkText: 'خروج',
                                                ).show();
                                                setState(() {
                                                  _news.removeAt(i);
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
                                        btnCancelOnPress: () {},
                                        btnCancelColor: Colors.blue,
                                        btnCancelText: 'تراجع',
                                      ).show();
                                    }
                                  }

                                  // Get.offAll(() => DashboardScreen());
                                }
                              }
                            }
                          },
                          child: Column(
                            children: [
                              ListTile(
                                // tileColor: Colors.grey.shade200,
                                leading: GestureDetector(
                                  onTap: () async {
                                    // Display the image in large form.
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: CircleAvatar(
                                      radius: 50,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: FadeInImage.memoryNetwork(
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 100,
                                          fadeInDuration:
                                              const Duration(milliseconds: 500),
                                          fadeOutDuration:
                                              const Duration(milliseconds: 500),
                                          placeholder: kTransparentImage,
                                          image: linkUserImageRoot +
                                              _news[i]['uspho'],
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
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
                                    ),
                                  ),
                                ),
                                title: Row(children: [
                                  _news[i]['usty'] == '1'
                                      ? const Icon(Icons.person, size: 20)
                                      : const Icon(
                                          Icons.verified,
                                          size: 20,
                                          color: Colors.blue,
                                        ),
                                  Expanded(
                                    child: Text(
                                      " ${_news[i]['name']}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ]),
                                subtitle: Text(
                                  _news[i]['message'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                trailing: Text(
                                    ' ${timeUntil(DateTime.parse(_news[i]['date']))}',
                                    style: const TextStyle(fontSize: 13)),
                                // trailing: Text(data[i]["date"], style: TextStyle(fontSize: 10)),
                              ),
                              const Divider(
                                height: 1,
                                color: Colors.black54,
                              )
                            ],
                          ),
                        ),
                      )),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
      ),
      body: _isFirstLoadRunning
          ? const Center(child: CupertinoActivityIndicator())
          : SizedBox(
              child: CommentBox(
              userImage: sharedPref.getString("uspho") != ''
                  ? linkUserImageRoot +
                      sharedPref.getString("uspho")!.toString()
                  // : linkImageRoot + sharedPref.getString("uspho")!,
                  : '${linkImageRoot}AlUyun.png',
              labelText: 'اكتب تعليقك...',
              errorText: 'التعليق لا يمكن أن يكون فارغ',
              sendButtonMethod: () {
                if (formKey.currentState!.validate()) {
                  addComment();
                  // setState(() {
                  //   var value = {
                  //     'name': 'New User',
                  //     'pic':
                  //         'https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400',
                  //     'message': commentController.text,
                  //     'date': '2022-11-24 22:00:00'
                  //   };
                  //   filedata.insert(0, value);
                  // });

                  FocusScope.of(context).unfocus();
                } else {}
              },
              formKey: formKey,
              commentController: commentController,
              backgroundColor: AppTheme.appTheme.primaryColor,
              textColor: Colors.white,
              sendWidget:
                  const Icon(Icons.send_sharp, size: 30, color: Colors.white),
              child: commentChild(_news),
            )),
    );
  }

  void checkIsAdmin() async {
    if (sharedPref.getString("usid") != null) {
      var response = await curd
          .postRequest(linkCheckAdmin, {'usid': sharedPref.getString("usid")});
      if (response == 'Error') {
      } else {
        if (response['status'] == 'success') {
          if (response['data']['usty'] == '2' ||
              response['data']['usty'] == '3') {
            if (mounted) {
              await AwesomeDialog(
                context: context,
                animType: AnimType.TOPSLIDE,
                dialogType: DialogType.SUCCES,
                // dialogColor: AppTheme.appTheme.primaryColor,
                title: 'Dashbord',
                desc: 'هل تريد الانتقال إلى لوحة التحكم',
                btnOkOnPress: () => Get.back(),
                btnOkColor: Colors.red,
                btnOkText: 'خروج',
                btnCancelOnPress: () {},
                btnCancelColor: Colors.blue,
                btnCancelText: 'دخول',
              ).show();
            }

            // Get.offAll(() => DashboardScreen());
          } else {}
        }
      }
    }
  }

  showDilogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('لا يتوفر إتصال بالإنترنت'),
          content: const Text('أعد الإتصال بالإنترنت'),
          actions: [
            TextButton(
              onPressed: () async {
                Get.offAll(() => const HomeScreen());
                // Navigator.pop(context, 'Cancel');
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
