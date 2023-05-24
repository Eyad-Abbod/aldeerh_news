import 'dart:convert';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';

import 'package:aldeerh_news/utilities/user_change_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangeUser extends StatefulWidget {
  const ChangeUser({super.key, required this.nsid});
  final String nsid;

  @override
  State<ChangeUser> createState() => _ChangeUserState();
}

class _ChangeUserState extends State<ChangeUser> {
  bool isLoading = false;
  bool isUpdateing = false;
  List<UserNewsChange> users = <UserNewsChange>[];
  List<UserNewsChange> userList = <UserNewsChange>[];
  final Curd curd = Curd();
  Future fetchs({String? query}) async {
    // final url = Uri.parse('http://s.aldeerahnews.com/public/api/news_and_ad');
    try {
      var response =
          await http.get(Uri.parse('$linkSearchAndChangeUser?state=1'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print(data[1]);
        for (var item in data) {
          userList.add(UserNewsChange.fromJson(item));
        }
        if (mounted) {
          setState(() {
            users = userList;
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
        users = userList
            .where((element) =>
                element.name!.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchs(query: '');
  }

  //  List<UserNewsChange> display_list = await List.from(fetchs);
  editNewsUser(String userId, String name) async {
    // return Iterable<ImageFile>

    isUpdateing = true;
    if (mounted) {
      if (mounted) {
        setState(() {});
      }
    }
    dynamic response;

    response = await curd.postRequest(linkChangeUser, {
      'nsid': widget.nsid.toString(),
      'usid': userId.toString(),
    });

    isUpdateing = false;
    if (mounted) {
      if (mounted) {
        setState(() {});
      }
    }
    if (response['status'] == 'exist') {
      if (mounted) {
        AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.WARNING,
          // dialogColor: AppTheme.appTheme.primaryColor,
          title: 'عذراً',
          desc: 'لم تقم بتعديل أي بيانات',
          btnOkOnPress: () {},
          btnOkColor: Colors.blue,
          btnOkText: 'خروج',
        ).show();
      }
    } else {
      if (response['status'] == 'success') {
        if (mounted) {
          await AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            dialogType: DialogType.SUCCES,
            title: 'نجاح',
            desc: 'تم التعديل بنجاح',
            btnOkOnPress: () {},
            btnOkColor: Colors.blue,
            btnOkText: 'خروج',
          ).show();
        }
        if (mounted) {
          Navigator.pop(context, name);
        }

        // Get.offAll(HomeScreen());
      } else {
        if (mounted) {
          await AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            dialogType: DialogType.ERROR,
            title: 'خطأ',
            desc: 'تأكد من توفر الإنترنت',
            btnOkOnPress: () {},
            btnOkColor: Colors.blue,
            btnOkText: 'Ok',
          ).show();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text('اختار مستخدم جديد للخبر'),
      ),
      body: isLoading == false
          ? WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, ''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Center(
                      child: Text(
                        'تراجع',
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
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
                        TextField(
                          onChanged: (value) => updateList(value),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.blueGrey,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none),
                            // hintText: "ابحث",

                            prefixIcon: const Icon(Icons.search),
                            prefixIconColor: Colors.purple.shade900,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'اسم المستخدم',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'رقم الهاتف',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: ((context, index) => Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: InkWell(
                                    onTap: () {
                                      editNewsUser(
                                        users[index].usid!,
                                        users[index].name!,
                                      );
                                    },
                                    child: Card(
                                      elevation: 3.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  users[index].usty! == '1'
                                                      ? const Icon(Icons.person,
                                                          size: 26)
                                                      : const Icon(
                                                          Icons.verified,
                                                          size: 26,
                                                          color: Colors.blue,
                                                        ),
                                                  Flexible(
                                                    child: Text(
                                                        ' ${users[index].name!}'),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // subtitle: Text(users[index].usty!),
                                        trailing: Text(users[index].usph!),
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, ''),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Center(
                            child: Text(
                              'تراجع',
                              style: TextStyle(),
                            ),
                          ),
                        ),
                      ],
                    ),
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
            ),
    );
  }
}
