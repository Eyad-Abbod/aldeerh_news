import 'dart:convert';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/cong_model.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCongrats extends StatefulWidget {
  const AddCongrats({super.key});

  @override
  State<AddCongrats> createState() => _ChangeUserState();
}

class _ChangeUserState extends State<AddCongrats> {
  bool isLoading = false;
  bool isUpdateing = false;
  List<CongModel> congrats = <CongModel>[];

  final Curd curd = Curd();
  Future fetchs() async {
    try {
      var response = await http.get(Uri.parse(linkViewAllCong));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print(data[1]);
        for (var item in data) {
          congrats.add(CongModel.fromJson(item));
        }
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
      } else {
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
        }

        fetchs();
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        debugPrint("Something went wrong");
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
        }
        fetchs();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    congrats.clear();
  }

  @override
  void initState() {
    super.initState();
    fetchs();
  }

  Future newsRefresh() async {
    if (mounted) {
      setState(() {
        isLoading = true;

        congrats.clear();
      });
    }
    fetchs();
  }

  //  List<CongModel> display_list = await List.from(fetchs);
  // editNewsImage(String nsImg) async {
  //   // return Iterable<ImageFile>

  //   isUpdateing = true;
  //   if (mounted) {
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   }
  //   dynamic response;

  //   response = await curd.postRequest(linkChangeImage, {});

  //   isUpdateing = false;
  //   if (mounted) {
  //     if (mounted) {
  //       setState(() {});
  //     }
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
  //       if (mounted) {
  //         Navigator.pop(context, nsImg);
  //       }
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
        title: const Text('رسائل عامة'),

      ),
      body: isLoading == false
          ? const Center(
        child: CupertinoActivityIndicator(),
      )
          : congrats.isEmpty
          ? Center(
          child: Text(
            'ليس هناك أي تهنئة سابقة ',
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
                itemCount: congrats.length,
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
                            borderRadius: BorderRadius.circular(5.0),
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
          ],
        ),
      ),
    );
  }

  buildHeder(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text(
              congrats[index].congTitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            subtitle: Column(
              children: [
                Text(
                  congrats[index].congText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(

                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                IconButton(
                  onPressed: () async {
                    await AwesomeDialog(
                      context: context,
                      animType: AnimType.TOPSLIDE,
                      dialogType: DialogType.INFO,
                      // dialogColor: AppTheme.appTheme.primaryColor,
                      title: 'نشر',
                      desc: 'هل تريد نشر التهنئة',
                      btnOkOnPress: () {
                        curd.postRequestNotifications(
                            congrats[index].congTitle!,
                            congrats[index].congText!,
                            '1');
                      },
                      btnOkColor: Colors.green,
                      btnOkText: 'نشر',
                      btnCancelOnPress: () {},
                      btnCancelColor: Colors.red,
                      btnCancelText: 'إلغاء',
                    ).show();
                  },
                  icon: const Icon(Icons.settings),
                )
              ],
            ),
            // Column(
            //   children: [
            //     ListTile(
            //       // tileColor: Colors.grey.shade200,

            //       title: Row(children: [
            //         Expanded(
            //           child: Text(
            //              congrats[index].congText!,
            //             style: const TextStyle(fontWeight: FontWeight.bold),
            //             maxLines: 1,
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //         )
            //       ]),
            //       subtitle: Padding(
            //         padding: const EdgeInsets.only(right: 8.0),
            //         child: Text(
            //           congrats[index].congText!,
            //           textAlign: TextAlign.center,
            //           style: const TextStyle(color: Colors.black),
            //         ),
            //       ),
            //     ),
            //     IconButton(
            //       onPressed: () async {
            //         await AwesomeDialog(
            //           context: context,
            //           animType: AnimType.TOPSLIDE,
            //           dialogType: DialogType.INFO,
            //           // dialogColor: AppTheme.appTheme.primaryColor,
            //           title: 'نشر',
            //           desc: 'هل تريد نشر التعليق',
            //           btnOkOnPress: () async {
            //             var response =
            //                 await curd.postRequest(linkCommentsState, {
            //               // "id": comments[index]['id'],
            //               "state": '1',
            //             });
            //             if (response == 'Error') {
            //               if (mounted) {
            //                 setState(() {});

            //                 AwesomeDialog(
            //                   context: context,
            //                   animType: AnimType.TOPSLIDE,
            //                   dialogType: DialogType.ERROR,
            //                   title: 'خطأ',
            //                   desc: 'تأكد من توفر الإنترنت',
            //                   btnOkOnPress: () {},
            //                   btnOkColor: Colors.blue,
            //                   btnOkText: 'خروج',
            //                 ).show();
            //               }
            //             } else {
            //               if (mounted) {
            //                 if (response['status'] == 'success') {
            //                   AwesomeDialog(
            //                     context: context,
            //                     animType: AnimType.TOPSLIDE,
            //                     dialogType: DialogType.SUCCES,
            //                     title: 'نجاح',
            //                     desc: 'تمت عملية نشر التعليق بنجاح',
            //                     btnOkOnPress: () {},
            //                     btnOkColor: Colors.blue,
            //                     btnOkText: 'خروج',
            //                   ).show();
            //                   setState(() {
            //                     congrats.removeAt(index);
            //                   });
            //                 }
            //               } else {
            //                 if (mounted) {
            //                   AwesomeDialog(
            //                     context: context,
            //                     animType: AnimType.TOPSLIDE,
            //                     dialogType: DialogType.ERROR,
            //                     title: 'خطأ',
            //                     desc: 'تأكد من توفر الإنترنت',
            //                   ).show();
            //                 }
            //               }
            //             }
            //           },
            //           btnOkColor: Colors.green,
            //           btnOkText: 'نشر',
            //           btnCancelOnPress: () async {
            //             var response =
            //                 await curd.postRequest(linkCommentsState, {
            //               // "id": comments[index]['id'],
            //               "state": '3',
            //             });
            //             if (response == 'Error') {
            //               if (mounted) {
            //                 setState(() {});

            //                 AwesomeDialog(
            //                   context: context,
            //                   animType: AnimType.TOPSLIDE,
            //                   dialogType: DialogType.ERROR,
            //                   title: 'خطأ',
            //                   desc: 'تأكد من توفر الإنترنت',
            //                   btnOkOnPress: () {},
            //                   btnOkColor: Colors.blue,
            //                   btnOkText: 'خروج',
            //                 ).show();
            //               }
            //             } else {
            //               if (mounted) {
            //                 if (response['status'] == 'success') {
            //                   AwesomeDialog(
            //                     context: context,
            //                     animType: AnimType.TOPSLIDE,
            //                     dialogType: DialogType.SUCCES,
            //                     title: 'نجاح',
            //                     desc: 'تمت عملية حذف التعليق بنجاح',
            //                     btnOkOnPress: () {},
            //                     btnOkColor: Colors.blue,
            //                     btnOkText: 'خروج',
            //                   ).show();
            //                   setState(() {
            //                     // comments.removeAt(index);
            //                   });
            //                 }
            //               } else {
            //                 if (mounted) {
            //                   AwesomeDialog(
            //                     context: context,
            //                     animType: AnimType.TOPSLIDE,
            //                     dialogType: DialogType.ERROR,
            //                     title: 'خطأ',
            //                     desc: 'تأكد من توفر الإنترنت',
            //                   ).show();
            //                 }
            //               }
            //             }
            //           },
            //           btnCancelColor: Colors.red,
            //           btnCancelText: 'حذف',
            //         ).show();
            //       },
            //       icon: const Icon(Icons.settings),
            //     )
            //   ],
            // ),
          ),
        )
      ],
    );
  }
}
