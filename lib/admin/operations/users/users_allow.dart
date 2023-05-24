import 'dart:convert';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';

import 'package:aldeerh_news/utilities/user_change_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllowUsers extends StatefulWidget {
  const AllowUsers({super.key});

  @override
  State<AllowUsers> createState() => _UsersState();
}

class _UsersState extends State<AllowUsers> {
  bool isLoading = false;
  bool isUpdateing = false;
  List<UserNewsChange> users = <UserNewsChange>[];
  List<UserNewsChange> userList = <UserNewsChange>[];
  final Curd curd = Curd();
  Future fetchs() async {
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
    fetchs();
  }

  //  List<UserNewsChange> display_list = await List.from(fetchs);
  editUser(String userId, int index) async {
    // return Iterable<ImageFile>

    isUpdateing = true;
    if (mounted) {
      setState(() {});
    }
    dynamic response;

    response = await curd.postRequest(linkUserState, {
      "usid": userId,
      "state": '0',
    });

    isUpdateing = false;
    if (mounted) {
      setState(() {});
    }

    if (response['status'] == 'success') {
      if (mounted) {
        await AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.SUCCES,
          title: 'نجاح',
          desc: 'تمت عملية الحظر بنجاح',
          btnOkOnPress: () {},
          btnOkColor: Colors.blue,
          btnOkText: 'خروج',
        ).show();
        setState(() {
          users.removeAt(index);
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == false
          ? Column(
              children: const [
                Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              ],
            )
          : users.isEmpty
              ? Center(
                  child: Text(
                  'ليس هناك أي مستخدم ',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.appTheme.primaryColor,
                  ),
                ))
              : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'عدد الأخبار',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                                      onTap: () => AwesomeDialog(
                                        context: context,
                                        animType: AnimType.TOPSLIDE,
                                        dialogType: DialogType.INFO,
                                        // dialogColor: AppTheme.appTheme.primaryColor,
                                        title: 'الحظر',
                                        desc: 'هل تريد حظر المستخدم',
                                        btnOkOnPress: () =>
                                            editUser(users[index].usid!, index),

                                        btnOkColor: Colors.red,
                                        btnOkText: 'حظر',
                                        btnCancelText: 'إلغاء',
                                        btnCancelOnPress: () {},
                                        btnCancelColor: Colors.blue,
                                      ).show(),
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
                                                        ? const Icon(
                                                            Icons.person,
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
                                          trailing:
                                              Text(users[index].newsCount!),
                                        ),
                                      ),
                                    ),
                                  )),
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
                            child: const Center(
                                child: CupertinoActivityIndicator()))
                        : const SizedBox(height: 0),
                  ],
                ),
    );
  }
}
