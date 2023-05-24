import 'dart:convert';
import 'package:aldeerh_news/main.dart';
import 'package:aldeerh_news/screens/shared_ui/card_news.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:aldeerh_news/utilities/news_search_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchNews extends StatefulWidget {
  final int isAdmin;
  const SearchNews({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<SearchNews> createState() => _ChangeUserState();
}

class _ChangeUserState extends State<SearchNews> {
  String userId = '0';

  bool isLoading = false;
  bool isUpdateing = false;
  List<Serach> news = <Serach>[];
  List<Serach> userList = <Serach>[];

  final Curd curd = Curd();
  Future fetchs() async {
    news.clear();
    userList.clear();
    // final url = Uri.parse('http://s.aldeerahnews.com/public/api/news_and_ad');

    if (sharedPref.getString("usid") != null) {
      userId = sharedPref.getString("usid")!;
    }
    try {
      var response = await http.get(Uri.parse(
          "$linkSearchNews?isAdmin=${widget.isAdmin}&userid=$userId"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print(data[1]);
        for (var item in data) {
          userList.add(Serach.fromJson(item));
        }
        if (mounted) {
          setState(() {
            news = userList;
            isLoading = true;
          });
        }
      } else {}
    } catch (e) {
      if (mounted) {
        debugPrint("Something went wrong");
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

        fetchs();
      }
    }
  }

  void updateList(String value) {
    if (mounted) {
      setState(() {
        news = userList
            .where((element) =>
                element.nsTitle!.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchs();
  }

  //  List<SearchNews> display_list = await List.from(fetchs);
  // editNewsUser(String userId, String name) async {
  //   // return Iterable<ImageFile>

  //   isUpdateing = true;
  //   if (mounted) {
  //     if (mounted) {
  //   setState(() {});
  // }
  //   }
  //   dynamic response;

  //   response = await curd.postRequest(linkChangeUser, {
  //     // 'nsid': widget.nsid.toString(),
  //     'usid': userId.toString(),
  //   });

  //   isUpdateing = false;
  //   if (mounted) {
  //     if (mounted) {
  //   setState(() {});
  // }
  //   }
  //   if (response['status'] == 'exist') {
  //     if (mounted) {
  //       AwesomeDialog(
  //         context: context,
  //         animType: AnimType.TOPSLIDE,
  //         dialogType: DialogType.WARNING,
  //         // dialogColor: AppTheme.appTheme.primaryColor,
  //         title: 'عذراً',
  //         desc: 'لم تقم بتعديل أي بيانات',
  //         btnOkOnPress: () {},
  //         btnOkColor: Colors.blue,
  //         btnOkText: 'خروج',
  //       ).show();
  //     }
  //   } else {
  //     if (response['status'] == 'success') {
  //       if (mounted) {
  //         await AwesomeDialog(
  //           context: context,
  //           animType: AnimType.TOPSLIDE,
  //           dialogType: DialogType.SUCCES,
  //           title: 'نجاح',
  //           desc: 'تم التعديل بنجاح',
  //           btnOkOnPress: () {},
  //           btnOkColor: Colors.blue,
  //           btnOkText: 'خروج',
  //         ).show();
  //       }
  //       Navigator.pop(context, name);
  //       // Get.offAll(HomeScreen());
  //     } else {
  //       if (mounted) {
  //         await AwesomeDialog(
  //           context: context,
  //           animType: AnimType.TOPSLIDE,
  //           dialogType: DialogType.ERROR,
  //           title: 'خطأ',
  //           desc: 'تأكد من توفر الإنترنت',
  //           btnOkOnPress: () {},
  //           btnOkColor: Colors.blue,
  //           btnOkText: 'Ok',
  //         ).show();
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text('البحث'),
      ),
      body: isLoading == false
          ? const Center(
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            )
          : Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'إبحث عن المستخدم المطلوب',
                    //   style: TextStyle(
                    //     color: Colors.redAccent,
                    //     fontSize: 22.0,
                    //   ),
                    // ),
                    // SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        onChanged: (value) => updateList(value),
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueGrey,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none),
                          hintText: " ابحث بعنوان الخبر",
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.white),
                          prefixIconColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    Expanded(
                      child: ListView.builder(
                          itemCount: news.length,
                          itemBuilder: (context, index) => news[index]
                                      .seen
                                      .toString() ==
                                  'null'
                              ? CardNews(
                                  ontap: () {},
                                  title: news[index].nsTitle!,
                                  nsTxt: news[index].nsTxt!,
                                  date: news[index].nsDaSt!,
                                  dateAndTime: news[index].newsDate.toString(),
                                  usid: news[index].nsid!,
                                  con: '0',
                                  nsImg: news[index].nsImg!,
                                  name: news[index].name!,
                                  nsid: news[index].nsid!,
                                  usty: news[index].usty!,
                                  usph: news[index].usph!,
                                  imagesCount: news[index].imagesCount!,
                                  commentsCount: news[index].imagesCount!,
                                  newsState: news[index].state!,
                                )
                              : CardNews(
                                  ontap: () {},
                                  title: news[index].nsTitle!,
                                  nsTxt: news[index].nsTxt!,
                                  date: news[index].nsDaSt!,
                                  dateAndTime: news[index].newsDate.toString(),
                                  usid: news[index].nsid!,
                                  con: news[index].seen!,
                                  nsImg: news[index].nsImg!,
                                  name: news[index].name!,
                                  nsid: news[index].nsid!,
                                  usty: news[index].usty!,
                                  usph: news[index].usph!,
                                  imagesCount: news[index].imagesCount!,
                                  commentsCount: news[index].commentsCount!,
                                  newsState: news[index].state!,
                                )),
                    ),
                  ],
                ),
                isUpdateing == true
                    ? Container(
                        color: Colors.white12,
                        width: double.infinity,
                        height: double.infinity,
                        child:
                            const Center(child: CupertinoActivityIndicator()))
                    : const SizedBox(height: 0),
              ],
            ),
    );
  }
}
