import 'package:aldeerh_news/admin/dashboard.dart';
import 'package:aldeerh_news/auth/login.dart';
import 'package:aldeerh_news/main.dart';
import 'package:aldeerh_news/screens/drawer_pages/about_app.dart';
import 'package:aldeerh_news/screens/drawer_pages/about_city.dart';
import 'package:aldeerh_news/screens/drawer_pages/add_news.dart';
import 'package:aldeerh_news/screens/drawer_pages/my_news.dart';
import 'package:aldeerh_news/screens/drawer_pages/suggestion.dart';
import 'package:aldeerh_news/screens/home_screen.dart';
import 'package:aldeerh_news/screens/drawer_pages/personal_page.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

class AppNavigationDrawer extends StatefulWidget {
  const AppNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<AppNavigationDrawer> createState() => _AppNavigationDrawerState();
}

class NavMenuItem {
  String title;
  IconData icon;
  Function destination;

  NavMenuItem(this.title, this.icon, this.destination);
}

class _AppNavigationDrawerState extends State<AppNavigationDrawer> {
  List<NavMenuItem> navigationMenu = [
    NavMenuItem("تسجيل الدخول", Icons.login, () => const Login()),
    NavMenuItem(
        "إضافة خبر",
        Icons.add_box_outlined,
        () => const AddNews(
              title: 'إضافة خبر',
              type: '1',
            )),
    NavMenuItem(
        "أخباري",
        Icons.new_label_sharp,
        () => const MyNews(
              title: 'أخباري',
              type: '1',
            )),
    NavMenuItem(
        "للتقييم والإقتراحات", Icons.thumb_up_alt, () => const Suggestion()),
    NavMenuItem("عن التطبيق", Icons.info, () => const AboutApp()),
    NavMenuItem("مدينة العيون", Icons.info, () => const AboutCity()),
    NavMenuItem(
        "لمراسلة الإدارة والإعلانات", Icons.message, () => const AboutApp()),
    NavMenuItem("تسجيل خروج", Icons.exit_to_app, () => const HomeScreen()),
  ];
  bool isLoading = false;

  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final Curd curd = Curd();
  double rating = 0.0;
  String? last;
  bool canSend = true;
  addSuggestion() async {
    if (rating != 0.0) {
      FocusManager.instance.primaryFocus?.unfocus();
      if (canSend == true) {
        isLoading = true;
        canSend = false;
        if (mounted) {
          setState(() {});
        }
        int a = rating.toInt();
        var response = await curd.postRequest(linkAddSugg, {
          'usid': sharedPref.getString('usid'),
          'rat': a.toString(),
          'tex': content.text,
        });
        isLoading = false;
        canSend = true;

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
        }

        if (mounted) {
          if (response['status'] == 'success') {
            await AwesomeDialog(
              context: context,
              animType: AnimType.TOPSLIDE,
              dialogType: DialogType.SUCCES,
              // dialogColor: AppTheme.appTheme.primaryColor,
              title: 'نجاح',
              desc: 'شكراً لك... تم رفع تقييمك  ',
              btnOkOnPress: () => Get.offAll(() => const HomeScreen()),
              btnOkColor: Colors.blue,
              btnOkText: 'خروج',
            ).show();
            Get.offAll(() => const HomeScreen());
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
    } else {
      showToast();
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
                btnCancelOnPress: () =>
                    Get.offAll(() => const DashboardScreen()),
                btnCancelColor: Colors.blue,
                btnCancelText: 'دخول',
              ).show();
            }

            // Get.offAll(() => DashboardScreen());
          } else {
            debugPrint('You Are Not Admin');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        color: Colors.black87,
        padding: EdgeInsets.only(
            top: 20 + MediaQuery.of(context).padding.top, bottom: 10),
        child: Column(
          children: [
            GestureDetector(
              onLongPress: () => checkIsAdmin(),
              child: CircleAvatar(
                radius: 52,
                backgroundImage: sharedPref.getString("uspho")!.toString() != ''
                    ? FadeInImage.memoryNetwork(
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                        fadeInDuration: const Duration(milliseconds: 500),
                        fadeOutDuration: const Duration(milliseconds: 500),
                        placeholder: kTransparentImage,
                        image: linkUserImageRoot +
                            sharedPref.getString("uspho")!.toString(),
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
                      ).image
                    : FadeInImage.memoryNetwork(
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                        fadeInDuration: const Duration(milliseconds: 500),
                        fadeOutDuration: const Duration(milliseconds: 500),
                        placeholder: kTransparentImage,
                        image: '${linkImageRoot}AlUyun.png',
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
                      ).image,
              ),
            ),
            const SizedBox(height: 10),
            sharedPref.getString("name") == null
                ? const Text(
                    'علوم الديرة',
                    style: TextStyle(fontSize: 23, color: Colors.white),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: sharedPref.getString("usty") == '4'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: AutoSizeText(
                                        sharedPref.getString("name").toString(),
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 23,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.verified,
                                size: 22,
                                color: Colors.lightBlue,
                              ),
                            ],
                          )
                        : AutoSizeText(
                            sharedPref.getString("name").toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 23, color: Colors.white),
                          ),
                  ),
            // IconButton(
            //   onPressed: () => AwesomeDialog(
            //           context: context,
            //           animType: AnimType.TOPSLIDE,
            //           dialogType: DialogType.INFO,
            //           title: 'تحذير',
            //           desc: 'هل أنت متأكد من الخروج',
            //           btnOkOnPress: () {
            //             sharedPref.clear();
            //             Get.offAll(() => const HomeScreen());
            //           },
            //           btnOkColor: Colors.red,
            //           btnOkText: 'تسجيل خروج',
            //           btnCancelOnPress: () {
            //             Get.offAll(() => const HomeScreen());
            //           },
            //           btnCancelColor: AppTheme.appTheme.primaryColor,
            //           btnCancelText: 'تراجع')
            //       .show(),
            //   icon: const Icon(
            //     Icons.exit_to_app,
            //     color: Colors.white,
            //   ),
            // )
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => ListView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: navigationMenu.length,
        itemBuilder: (context, position) {
          if (position == 0) {
            return sharedPref.getString("name") == null
                ? ListTile(
                    title: Text(navigationMenu[position].title),
                    leading: Icon(
                      navigationMenu[position].icon,
                      color: AppTheme.appTheme.primaryColor,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigator.pop(context);
                      // Get.to(() => navigationMenu[position].destination());
                      sharedPref.getString("name") == null
                          ? Get.to(() => const Login())
                          : Get.to(
                              () => navigationMenu[position].destination());
                    },
                  )
                : ListTile(
                    title: const Text('الصفحة الشخصية'),
                    leading: Icon(
                      Icons.person,
                      color: AppTheme.appTheme.primaryColor,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigator.pop(context);
                      // Get.to(() => navigationMenu[position].destination());

                      Get.to(() => PersonalPage(
                            name: sharedPref.getString("name")!,
                            uspho: sharedPref.getString("uspho")!,
                          ));
                    },
                  );
          } else if (position == 3) {
            return ListTile(
              title: Text(navigationMenu[position].title),
              leading: Icon(
                navigationMenu[position].icon,
                color: AppTheme.appTheme.primaryColor,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                sharedPref.getString("name") == null
                    ? Get.to(() => const Login())
                    : {
                        if (mounted)
                          {
                            setState(() {
                              rating = 0.0;
                            }),
                            openDialog()
                          }
                      };
              },
            );
          } else if (position == 4) {
            return ListTile(
              title: Text(navigationMenu[position].title),
              leading: Icon(
                navigationMenu[position].icon,
                color: AppTheme.appTheme.primaryColor,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          navigationMenu[position].destination()),
                );
              },
            );
          } else if (position == 5) {
            return ListTile(
              title: Text(navigationMenu[position].title),
              leading: Icon(
                navigationMenu[position].icon,
                color: AppTheme.appTheme.primaryColor,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          navigationMenu[position].destination()),
                );
              },
            );
          } else if (position == 6) {
            return sharedPref.getString("name") == null
                ? ListTile(
                    title: Text(navigationMenu[position].title),
                    leading: Icon(
                      navigationMenu[position].icon,
                      color: AppTheme.appTheme.primaryColor,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigator.pop(context);
                      // Get.to(() => navigationMenu[position].destination());
                      sharedPref.getString("name") == null
                          ? Get.to(() => const Login())
                          : Get.to(
                              () => navigationMenu[position].destination());
                    },
                  )
                : ListTile(
                    title: AutoSizeText(
                      navigationMenu[position].title,
                      maxLines: 1,
                    ),
                    leading: Icon(
                      navigationMenu[position].icon,
                      color: AppTheme.appTheme.primaryColor,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      onOpen("583099051");
                    },
                  );
          } else if (position == 7) {
            return sharedPref.getString("name") != null
                ? ListTile(
                    title: Text(navigationMenu[position].title),
                    leading: Icon(
                      navigationMenu[position].icon,
                      color: AppTheme.appTheme.primaryColor,
                    ),
                    onTap: () {
                      if (mounted) {
                        AwesomeDialog(
                                context: context,
                                animType: AnimType.TOPSLIDE,
                                dialogType: DialogType.INFO,
                                title: 'تحذير',
                                desc: 'هل أنت متأكد من الخروج',
                                btnOkOnPress: () {
                                  last = sharedPref.getString('shared_ID');
                                  sharedPref.clear();
                                  sharedPref.setString("shared_ID", last!);
                                  sharedPref.setString("uspho", '');
                                  Get.offAll(() => const HomeScreen());
                                },
                                btnOkColor: Colors.red,
                                btnOkText: 'تسجيل خروج',
                                btnCancelOnPress: () {
                                  Navigator.pop(context);
                                },
                                btnCancelColor: AppTheme.appTheme.primaryColor,
                                btnCancelText: 'تراجع')
                            .show();
                      }
                    },
                  )
                : const SizedBox(height: 0);
          } else {
            return ListTile(
              title: Text(navigationMenu[position].title),
              leading: Icon(
                navigationMenu[position].icon,
                color: AppTheme.appTheme.primaryColor,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (sharedPref.getString("name") == null) {
                  Get.to(() => const Login());
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            navigationMenu[position].destination()),
                  );
                }
              },
            );
          }
        },
      );

  openDialog() => showDialog(
      context: context,
      builder: (context) => Center(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AlertDialog(
                    title: Center(
                      child: Text(
                        'التقيم والإقتراحات',
                        style: TextStyle(
                            color: AppTheme.appTheme.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: Form(
                      key: formstate,
                      child: Column(
                        children: [
                          const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'التقيم',
                                style: TextStyle(color: Colors.green),
                              )),
                          RatingBar.builder(
                            minRating: 1,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.greenAccent,
                            ),
                            updateOnDrag: true,
                            onRatingUpdate: (rating) => setState(
                              () {
                                this.rating = rating;
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'المقترح',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: content,
                            minLines: 4,
                            maxLines: 5,
                            validator: (val) {
                              return validInput(val!, 10, 100);
                            },
                            maxLength: 300,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: 'أضف مقترحك',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  addSuggestion();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor:
                                      AppTheme.appTheme.primaryColor,
                                ),
                                child: const Text('إرسال'),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.blueAccent,
                                ),
                                child: const Text('إلغاء'),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ));

  void showToast() =>
      CherryToast.success(title: const Text('"قيمنا من فضلك"')).show(context);
}
