import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:aldeerh_news/main.dart';
import 'package:aldeerh_news/screens/bottom_bar_screen/home_person.dart';
import 'package:aldeerh_news/screens/news_notification.dart';
import 'package:aldeerh_news/screens/bottom_bar_screen/home_news.dart';
import 'package:aldeerh_news/screens/bottom_bar_screen/home_user_share.dart';
import 'package:aldeerh_news/screens/bottom_bar_screen/productive_families.dart';
import 'package:aldeerh_news/screens/search_news.dart';
import 'package:aldeerh_news/shared_ui/navigation_drawer.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:store_redirect/store_redirect.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  String visited = '';

  int visiter = 0;
  bool isLoadRunning = false;
  bool needUpdate = false;

  bool seenToDay = false;

  final screens = [
    const HomeNews(),
    const HomePerson(),
    const HomeUserShare(),
    const ProductiveFamilies(),
  ];

  visitedToDay() async {
    if (mounted) {
      setState(() {
        isLoadRunning = true;
      });
    }
    try {
      final res = await http.get(Uri.parse(linkVisitedToDay));

      if (mounted) {
        setState(() {
          visited = json.decode(res.body);

          List visitCount = visited.split(',');
          for (var i = 0; i < visitCount.length; i++) {
            visiter = visiter + 1;
          }

          isLoadRunning = false;
        });
      }
    } catch (e) {
      // _isConnected = false;
      if (mounted) {
        // showDilogBox();

        setState(() {
          isLoadRunning = false;
        });
      }

      debugPrint("Something went wrong to add new visite to day");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    checkUpdate();

    if (sharedPref.getString('shared_ID') == null) {
      getSharedPref();
    } else {
      visitApp();
    }

    if (sharedPref.getString('uspho') == null) {
      sharedPref.setString("uspho", '');
    }

    visitedToDay();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    // if (result.notification.additionalData!['news_id'].toString() == 'ok'){}

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.setAppId("ca44ff11-13b6-4dfc-ab37-f6937cd47b78");

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      debugPrint("Accepted permission: $accepted");
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      debugPrint(result.notification.additionalData?['news_id'].toString());

      Get.to(() => NewsFromNotifications(
          newsID: result.notification.additionalData!['news_id'].toString()));
    });

    // OneSignal.shared.setNotificationWillShowInForegroundHandler(
    //     (OSNotificationReceivedEvent event) {
    //   debugPrint('FOREGROUND HANDLER CALLED WITH: $event');

    //   /// Display Notification, send null to not display
    //   event.complete(null);

    //   if (mounted) {
    //   setState(() {});
    // }
    // });
  }

  // Future<void> initPlatformState1() async {
  //   if (!mounted) return;

  //   OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  //   await OneSignal.shared.setAppId("64632726-24fb-4888-9337-6b26b1f894a0");

  //   OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  //     debugPrint("Accepted permission: $accepted");
  //   });

  //   OneSignal.shared
  //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //     debugPrint(result.notification.additionalData?['news_id'].toString());

  //     Get.to(() => NewsFromNotifications(
  //         newsID: result.notification.additionalData!['news_id'].toString()));
  //   });

  //   // OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //   //     (OSNotificationReceivedEvent event) {
  //   //   debugPrint('FOREGROUND HANDLER CALLED WITH: $event');

  //   //   /// Display Notification, send null to not display
  //   //   event.complete(null);

  //   //   if (mounted) {
  //   //   setState(() {});
  //   // }
  //   // });
  // }

  final Curd curd = Curd();
  getSharedPref() async {
    if (sharedPref.getString('shared_ID') == null) {
      // print('is Null');
      var response = await curd.postRequest(linkAddSheardID, {});
      // print('object');
      if (response == 'Error') {
      } else {
        if (response['status'] == 'success') {
          sharedPref.setString("shared_ID", response["data"]);
          // print(sharedPref.getString('shared_ID'));
        } else {
          // print('No Shared_Id');
        }
      }
    }
  }

  List<String> seenList = [];

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

  visitApp() async {
    if (sharedPref.getString("usid") == null) {
      curd.postRequests(
        linkVisitAppToDay,
        {'userSheard': sharedPref.getString('shared_ID')},
      );

      // if (response['status'] == 'success') {
      //   print('Add Shared_Id');
      // } else {
      //   print('No Shared_Id');
      // }
    } else {
      curd.postRequests(
        linkVisitAppToDay,
        {
          'userSheard': sharedPref.getString("shared_ID"),
          'userId': sharedPref.getString('usid')
        },
      );

      // if (response['status'] == 'success') {
      //   print('Add Shared_Id');
      // } else {
      //   print('No Shared_Id');
      // }
      // print(sharedPref.getString('usid'));
      // print(sharedPref.getString('shared_ID'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return needUpdate == true
        ? Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text("علوم الديرة"),
      ),
      body: Stack(
        children: [
          const HomeNews(),
          GestureDetector(
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
          ),
        ],
      ),
    )
        : Scaffold(
      body: screens[index],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text("علوم الديرة"),
        actions: <Widget>[
          visiter == 0
              ? const Center(
            child: Text(
              'الزوار اليوم !',
              style: TextStyle(),
            ),
          )
              : Center(child: Text('الزوار اليوم $visiter')),
          IconButton(
            onPressed: () {
              // showSearch(context: context, delegate: SearchUser());
              Get.to(() => const SearchNews(
                isAdmin: 0,
              ));
            },
            icon: const Icon(Icons.search_sharp),
          ),
        ],
      ),
      drawer: const AppNavigationDrawer(),
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          indicatorColor: Colors.white,
          // labelTextStyle: MaterialStateProperty.all(
          //   TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          // ),
        ),
        child: NavigationBar(
          height: 60,
          // animationDuration: Duration(seconds: 1),
          backgroundColor: Colors.white54,
          // backgroundColor: AppTheme.appTheme.primaryColor,
          selectedIndex: index,
          onDestinationSelected: (index) =>
              setState(() => this.index = index),
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.portrait_outlined,
                color: AppTheme.appTheme.primaryColor,
                size: 30,
              ),
              icon: const Icon(
                Icons.portrait,
                color: Colors.grey,
              ),
              label: 'الأخبار',
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.people_alt_outlined,
                color: Colors.grey,
              ),
              selectedIcon: Icon(
                Icons.people_alt,
                color: AppTheme.appTheme.primaryColor,
                size: 30,
              ),
              label: 'شخصيات',
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.border_color_outlined,
                color: Colors.grey,
              ),
              selectedIcon: Icon(
                Icons.border_color,
                color: AppTheme.appTheme.primaryColor,
                size: 30,
              ),
              label: 'خواطر ومشاركات',
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.family_restroom,
                color: Colors.grey,
              ),
              selectedIcon: Icon(
                Icons.family_restroom_outlined,
                color: AppTheme.appTheme.primaryColor,
                size: 30,
              ),
              label: 'أسر منتجة',
            ),
          ],
        ),
      ),
    );
  }
}
