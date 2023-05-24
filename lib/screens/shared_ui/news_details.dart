import 'dart:convert';

import 'package:aldeerh_news/admin/operations/edit_admin_dir.dart';
import 'package:aldeerh_news/main.dart';
import 'package:aldeerh_news/screens/shared_ui/comments.dart';
import 'package:aldeerh_news/screens/shared_ui/photo_news_img.dart';
import 'package:aldeerh_news/screens/shared_ui/photo_views.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_redirect/store_redirect.dart';

class NewsDetails extends StatefulWidget {
  const NewsDetails(
      {Key? key,
        required this.type,
        required this.title,
        required this.content,
        required this.nsImg,
        required this.name,
        required this.date,
        required this.nsid,
        required this.usty,
        required this.usph,
        required this.viewsCount,
        required this.commentsCount})
      : super(key: key);

  final String type;
  final String title;
  final String name;
  final String date;
  final String content;
  final String nsImg;
  final String nsid;
  final String usty;
  final String usph;
  final String viewsCount;
  final String commentsCount;

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  final List images = [];
  final Curd curd = Curd();
  late DateTime dateFormat;
  bool isLoading = false;
  bool isImagesLoading = true;
  bool needUpdate = false;
  void firstLoad() async {
    try {
      var a = widget.nsid;

      final res = await http.get(Uri.parse("$linkImagesNews?nsid=$a"));
      if (mounted) {
        setState(() {
          isImagesLoading = false;
          images.add({'img_url': widget.nsImg});
          images.addAll(json.decode(res.body));
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
          // desc: 'تأكد من توفر الإنترنت',
          desc: 'لم يتم التحقق من توفر الصور الإضافية تحقق من توفر الإنترنت',
          btnOkOnPress: () {},
          btnOkColor: Colors.blue,
          btnOkText: 'تحقق من توفر الإنترنت',
          // btnCancelOnPress: () {},
          // btnCancelColor: AppTheme.appTheme.primaryColor,
          // btnCancelText: 'مراسلة الإدارة'
        ).show();
        firstLoad();
        isImagesLoading = true;
      }
    }
  }

  checkUpdate() async {
    try {
      var response =
      await http.get(Uri.parse('$linkCheckUpdate?vir_cod=2.0.1'));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);

        // print(responsebody['data'][0]);

        if (responsebody['data'][0]['app_type'] == '1' &&
            responsebody['data'][0]['state'] == '2') {
          if (mounted) {
            await AwesomeDialog(
                context: context,
                animType: AnimType.TOPSLIDE,
                dialogType: DialogType.INFO,
                // dialogColor: AppTheme.appTheme.primaryColor,
                title: 'تحديث',
                // desc: 'تأكد من توفر الإنترنت',
                desc: 'يتوفر تحديث جديد للتطبيق',
                btnOkOnPress: () {},
                btnOkColor: Colors.red,
                btnOkText: 'تجاهل',
                btnCancelOnPress: () {
                  StoreRedirect.redirect(
                      androidAppId: "com.dreamsoft.byahmed.eyone",
                      iOSAppId: "1546555989");
                },
                btnCancelColor: Colors.blue,
                btnCancelText: 'تحديث')
                .show();
          }
        } else if (responsebody['data'][0]['app_type'] == '1' &&
            responsebody['data'][0]['state'] == '3') {
          if (mounted) {
            setState(() {
              needUpdate = true;
            });
            // await AwesomeDialog(
            //   context: context,
            //   animType: AnimType.TOPSLIDE,
            //   dialogType: DialogType.INFO,
            //   // dialogColor: AppTheme.appTheme.primaryColor,
            //   title: 'تحديث',
            //   // desc: 'تأكد من توفر الإنترنت',
            //   desc: 'يتوفر تحديث جديد للتطبيق',
            //   btnOkOnPress: () {
            //     StoreRedirect.redirect(
            //         androidAppId: "com.dreamsoft.byahmed.eyone",
            //         iOSAppId: "1546555989");
            //   },
            //   btnOkColor: Colors.blue,
            //   btnOkText: 'تحديث',
            // ).show();
            // StoreRedirect.redirect(
            //     androidAppId: "com.dreamsoft.byahmed.eyone",
            //     iOSAppId: "1546555989");
          }
        }
      }
    } catch (e) {
      if (mounted) {
        debugPrint('Failed to pick image: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    seenNews();
    checkUpdate();
    firstLoad();
    dateFormat = DateTime.parse(widget.date);
  }

  seenNews() async {
    if (sharedPref.getString("usid") == null) {
      curd.postRequests(
        linkVisitNewsToDay,
        {
          'userId': sharedPref.getString('shared_ID'),
          'newsId': widget.nsid,
        },
      );

      // if (response['status'] == 'success') {
      //   print('Add Shared_Id');
      // } else {
      //   print('No Shared_Id');
      // }
    } else {
      curd.postRequests(
        linkVisitNewsToDay,
        {
          'userId': sharedPref.getString('usid'),
          'newsId': widget.nsid,
        },
      );

      // if (response['status'] == 'success') {
      //   print('Add Shared_Id');
      // } else {
      //   print('No Shared_Id');
      // }
    }
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
                btnCancelOnPress: () => Get.to(() => NewsForAdminDirectly(
                  newsID: int.parse(widget.nsid),
                  title: widget.title,
                )),
                btnCancelColor: Colors.blue,
                btnCancelText: 'دخول',
              ).show();
            }

            // Get.offAll(() => DashboardScreen());
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<News> news_details = Get.arguments;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppTheme.appTheme.primaryColor,
      //   title: Text(widget.title),
      // ),
      // Image.asset('assets/AlUyun.png')

      floatingActionButton: FloatingActionButton.extended(
        heroTag: "btn1",
        icon: const Icon(Icons.share),
        backgroundColor: AppTheme.appTheme.primaryColor,
        label: const Text('مشاركة الخبر'),
        onPressed: () => Share.share(
            '${widget.title} - تطبيق "علوم الديرة"  \n\n\n حمل التطبيق لتصلك أخبار أهالي مدينة العيون \n\n\n حمله الآن من الرابط التالي \n  -> http://onelink.to/kd9y2b',
            subject: '',
            sharePositionOrigin:
            Rect.fromCenter(center: Offset.zero, width: 2, height: 2)),
      ),
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appTheme.primaryColor,
          centerTitle: true,
          title: const Text('تفاصيل الخبر'),
        ),
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    // foregroundColor: Colors.red,

                    backgroundColor: Colors.green,
                    expandedHeight: 300.0,
                    automaticallyImplyLeading: false,

                    flexibleSpace: InkWell(
                      onTap: () {
                        Get.to(() => const PhotoNewsImg(), arguments: [
                          widget.nsImg,
                          0,
                          widget.title,
                        ]);
                      },
                      child: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(
                                children: [
                                  const Center(
                                      child: CupertinoActivityIndicator(
                                        color: Colors.white,
                                      )),
                                  Center(
                                    child: FadeInImage.memoryNetwork(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.width,
                                      fit: widget.type == '1'
                                          ? BoxFit.cover
                                          : BoxFit.fill,
                                      fadeInDuration:
                                      const Duration(milliseconds: 500),
                                      fadeOutDuration:
                                      const Duration(milliseconds: 500),
                                      placeholder: kTransparentImage,
                                      image: linkImageRoot + widget.nsImg,
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(
                                            "assets/AlUyun2.png",
                                            fit: BoxFit.cover,
                                            width:
                                            MediaQuery.of(context).size.width,
                                          ),
                                      placeholderErrorBuilder: (c, o, s) =>
                                          Image.asset(
                                            "assets/AlUyun2.png",
                                            width:
                                            MediaQuery.of(context).size.width,
                                            fit: BoxFit.cover,
                                          ),
                                      repeat: ImageRepeat.repeat,
                                    ),
                                  ),
                                ],
                              ),
                              // child: CachedNetworkImage(
                              //     imageUrl: linkImageRoot + widget.nsImg,
                              //     fit: widget.type == '1'
                              //         ? BoxFit.cover
                              //         : BoxFit.fill,
                              //     placeholder: (context, url) => const Center(
                              //           child: CupertinoActivityIndicator(
                              //             color: Colors.white,
                              //           ),
                              //         ),
                              //     errorWidget: (context, url, error) =>
                              //         Image.asset('assets/AlUyun2.png')),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3)
                                  ],
                                  begin: Alignment.topCenter,
                                  stops: const [0.6, 1],
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                              padding:
                              const EdgeInsets.only(top: 30, bottom: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10.0),
                                  )
                                ],
                              ),
                            ),
                            // SafeArea(
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Container(
                            //       height: 40,
                            //       width: 40,
                            //       decoration: BoxDecoration(
                            //         color: Colors.black,
                            //         borderRadius: BorderRadius.circular(50),
                            //       ),
                            //       child: Center(
                            //           child: IconButton(
                            //         icon: Icon(Icons.arrow_back),
                            //         onPressed: () {},
                            //       )),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  )
                ];
              },
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 20, right: 25, left: 25, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () async {
                                  if (widget.usph != '') {
                                    if (sharedPref.getString("usid") != null) {
                                      var response = await curd.postRequest(
                                          linkCheckAdmin, {
                                        'usid': sharedPref.getString("usid")
                                      });
                                      if (response == 'Error') {
                                      } else {
                                        if (response['status'] == 'success') {
                                          if (response['data']['usty'] == '2' ||
                                              response['data']['usty'] == '3') {
                                            if (mounted) {
                                              onOpen(widget.usph);
                                            }

                                            // Get.offAll(() => DashboardScreen());
                                          } else {
                                            debugPrint('You Are Not Admin');
                                          }
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Row(
                                  children: [
                                    widget.usty == '1'
                                        ? Icon(
                                      Icons.person,
                                      size: 22,
                                      color:
                                      AppTheme.appTheme.primaryColor,
                                    )
                                        : const Icon(
                                      Icons.verified,
                                      size: 22,
                                      color: Colors.blue,
                                    ),
                                    Flexible(
                                      child: Text(
                                        ' ${widget.name}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.date_range_outlined,
                                    size: 22,
                                    color: AppTheme.appTheme.primaryColor),
                                Text(
                                    ' ${dateFormat.year.toString()}-${dateFormat.month.toString()}-${dateFormat.day.toString()}')
                                // Text(' ' +
                                //     dateFormat.year.toString() +
                                //     '-' +
                                //     dateFormat.month.toString() +
                                //     "-" +
                                //     dateFormat.day.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onLongPress: () => checkIsAdmin(),
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.appTheme.primaryColor,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const Divider(color: Colors.green),
                      const SizedBox(
                        height: 20,
                      ),

                      // RichText(
                      //   text: const TextSpan(
                      //     text: '', // emoji characters
                      //     style: TextStyle(
                      //       fontFamily: 'EmojiOne',
                      //     ),
                      //   ),
                      // ),
                      Linkify(
                        onOpen: onOpenlink,
                        text: widget.content,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        linkStyle: const TextStyle(color: Colors.red),
                      ),

                      // SelectableLinkify(
                      //   onOpen: onOpen,
                      //   text: widget.content,
                      //   textAlign: TextAlign.center,
                      //   style: const TextStyle(
                      //     fontWeight: FontWeight.w700,
                      //     fontSize: 16,
                      //   ),
                      //   linkStyle: const TextStyle(color: Colors.red),
                      // ),
                      // Text(
                      //   widget.content,
                      //   textAlign: TextAlign.center,
                      //   style: const TextStyle(
                      //     fontWeight: FontWeight.w700,
                      //     fontSize: 16,
                      //   ),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isImagesLoading
                          ? const Center(
                          child: CupertinoActivityIndicator(
                              color: Colors.black))
                          : images.length > 1
                          ? Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                'مرر لمشاهدة بقية الصور ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  AppTheme.appTheme.primaryColor,
                                ),
                              ),
                              const Text(
                                '>',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height:
                            MediaQuery.of(context).size.height *
                                0.24,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: images.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, i) =>
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const PhotoViews(),
                                          arguments: [
                                            images,
                                            i,
                                            widget.title,
                                          ]);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.45,
                                      // height: 100.0,
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        // child: CachedNetworkImage(
                                        //   imageUrl:
                                        //       linkImageRoot + images[i]['img_url'],
                                        //   fit: BoxFit.cover,
                                        //   placeholder: (context, url) => const Center(
                                        //     child: CupertinoActivityIndicator(),
                                        //   ),
                                        //   errorWidget: (context, url, error) =>
                                        //       Image.asset('assets/AlUyun2.png'),
                                        // ),

                                        child: Stack(
                                          children: [
                                            const Center(
                                                child:
                                                CupertinoActivityIndicator(
                                                  color: Colors.black,
                                                )),
                                            Center(
                                              child: FadeInImage
                                                  .memoryNetwork(
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                fit: widget.type == '1'
                                                    ? BoxFit.cover
                                                    : BoxFit.fill,
                                                fadeInDuration:
                                                const Duration(
                                                    milliseconds:
                                                    500),
                                                fadeOutDuration:
                                                const Duration(
                                                    milliseconds:
                                                    500),
                                                placeholder:
                                                kTransparentImage,
                                                image: linkImageRoot +
                                                    images[i]['img_url'],
                                                imageErrorBuilder:
                                                    (c, o, s) =>
                                                    Image.asset(
                                                      "assets/AlUyun2.png",
                                                      fit: BoxFit.cover,
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width,
                                                    ),
                                                placeholderErrorBuilder:
                                                    (c, o, s) =>
                                                    Image.asset(
                                                      "assets/AlUyun2.png",
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width,
                                                      fit: BoxFit.cover,
                                                    ),
                                                repeat:
                                                ImageRepeat.repeat,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      )
                          : const Text(''),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10.0))),
                        height: 70,
                        // color: Colors.green,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () => Get.to(() => Comments(
                                  nsid: widget.nsid,
                                  title: widget.title,
                                )),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'التعليقات ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.insert_comment_outlined,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          ' ${widget.commentsCount}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'المشاهدات ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Colors.white,
                                      ),
                                      Text(" ${widget.viewsCount}",
                                          style: const TextStyle(
                                              color: Colors.white))
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
            needUpdate == true
                ? GestureDetector(
              onTap: () => StoreRedirect.redirect(
                  androidAppId: "com.dreamsoft.byahmed.eyone",
                  iOSAppId: "1546555989"),
              child: Container(
                  color: Colors.white60,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 80),
                          Text(
                            'لابد من تحديث التطبيق',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.appTheme.primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.extended(
                              heroTag: "btn2",
                              label: const Text('تحديث التطبيق'), // <-- Text
                              backgroundColor: AppTheme.appTheme.primaryColor,
                              icon: const Icon(
                                // <-- Icon
                                Icons.download,
                                size: 24.0,
                              ),
                              onPressed: () => StoreRedirect.redirect(
                                  androidAppId: "com.dreamsoft.byahmed.eyone",
                                  iOSAppId: "1546555989"),
                            ),
                          ),
                        ],
                      ))),
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> onOpenlink(LinkableElement link) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      Uri.parse(link.url),
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        Uri.parse(link.url),
        mode: LaunchMode.inAppWebView,
      );
    }
  }
}
