import 'package:aldeerh_news/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:aldeerh_news/utilities/app_theme.dart';

late SharedPreferences sharedPref;


void main() async {
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  // tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'KS'), // Arabic, no country code
      ],

      locale: const Locale('ar', 'KS'),
      color: AppTheme.appTheme.primaryColor,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      title: 'علوم الديرة',
      debugShowCheckedModeBanner: false,
      // home: OnBoarding(),
      // initialRoute: "/",
      // routes: {"/": (context) => Login_php()},
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (ctx) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'علوم الديرة',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: AppTheme.appTheme.primaryColor,
        //   title: const Text("علوم الديرة"),
        //   centerTitle: true,
        // ),
          body: SizedBox(
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(120.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage("assets/home.png"),
                      ),
                      // const SizedBox(height: 5),
                      SpinKitSpinningLines(
                        color: AppTheme.appTheme.primaryColor,
                        size: 50.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
