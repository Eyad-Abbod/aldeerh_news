import 'dart:async';
import 'dart:math';
import 'package:aldeerh_news/main.dart';
import 'package:aldeerh_news/screens/home_screen.dart';
import 'package:aldeerh_news/shared_ui/customtextfield.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Check extends StatefulWidget {
  const Check({
    Key? key,
    required this.sms,
    required this.name,
    required this.usid,
    required this.usph,
    required this.uspho,
  }) : super(key: key);
  final String sms;
  final String name;
  final String usid;
  final String usph;
  final String uspho;

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  GlobalKey<FormState> formstate = GlobalKey();
  final Curd _curd = Curd();
  bool isLoading = false;
  String sms = '';
  Random random = Random();
  String vSms = '';

  TextEditingController code = TextEditingController();
  // late SharedPreferences sharedPref;

  int seconds = 59;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        if (mounted) {
          setState(() => seconds--);
        }
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    sms = widget.sms;
    startTimer();
    debugPrint(sms);
  }

  check() async {
    if (formstate.currentState!.validate()) {
      String a = code.text;
      String b = sms;
      if (a == b) {
        stopTimer();
        sharedPref.setString("usid", widget.usid);
        sharedPref.setString("name", widget.name);
        sharedPref.setString("uspho", widget.uspho);
        if (mounted) {
          await AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            dialogType: DialogType.SUCCES,
            title: 'نجاح',
            desc: 'تم التحقق بنجاح',
            btnOkOnPress: () {},
            btnOkColor: AppTheme.appTheme.primaryColor,
            btnOkText: 'Ok',
          ).show();
        }
        if (mounted) {
          await AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            dialogType: DialogType.NO_HEADER,
            title: 'شكرًا لتسجيلك',
            desc:
                'يمكنك الآن الاستمتاع بخدمات التطبيق والتفاعل مع محتوى التطبيق.',
            btnOkOnPress: () => Get.offAll(() => const HomeScreen()),
            btnOkColor: Colors.orange,
            btnOkText: 'Ok',
          ).show();
        }
        Get.offAll(() => const HomeScreen());
      } else {
        if (mounted) {
          AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            dialogType: DialogType.ERROR,
            // dialogColor: AppTheme.appTheme.primaryColor,
            title: 'خطأ',
            desc: 'رمز التحقق غير صحيح',
            btnOkOnPress: () {},
            btnOkColor: Colors.red,
            btnOkText: 'Ok',
          ).show();
        }
      }
    }
  }

  reSend() async {
    isLoading = true;
    code.text = '';
    if (mounted) {
      setState(() {});
    }

    vSms = (random.nextInt(10)).toString() +
        (random.nextInt(10)).toString() +
        (random.nextInt(10)).toString() +
        (random.nextInt(10)).toString();

    var response = await _curd
        .postRequest(linkCheck, {'usph': widget.usph, 'v_sms': vSms});
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
    if (response == 'Error') {
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
    } else {
      if (response['status'] == 'success') {
        if (mounted) {
          setState(() {
            sms = vSms;
            seconds = 59;
          });
          // print(vSms);
          await AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            dialogType: DialogType.SUCCES,
            // dialogColor: AppTheme.appTheme.primaryColor,
            title: 'نجاح',
            desc: 'تم إعادة إرسال رمز التحقق بنجاح',
            btnCancelOnPress: () {},
            btnCancelColor: AppTheme.appTheme.primaryColor,
            btnCancelText: 'Ok',
          ).show();
        }
        startTimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: const Color(0xfff2f3f7),
            body: Stack(
              children: [
                const Center(child: CupertinoActivityIndicator()),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(70),
                        bottomRight: Radius.circular(70),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Form(
                                    key: formstate,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "صفحة التحقق",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        CustTextFormSign(
                                            ourInput: TextInputType.number,
                                            maxl: 1,
                                            myMaxlength: 4,
                                            valid: (val) {
                                              return validCheckInput(
                                                  val!, 4, 4);
                                            },
                                            mycontroller: code,
                                            hint: 'أدخل رمز التحقق',
                                            icon: Icons.message_sharp),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: seconds > 0
                                                ? Text(
                                                    'إعادة إرسال الرمز بعد $seconds',
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold))
                                                : TextButton(
                                                    onPressed: () => reSend(),
                                                    child: Text(
                                                        'إعادة الإرسال الأن',
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .appTheme
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)))),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black87,
                                            backgroundColor:
                                                AppTheme.appTheme.primaryColor,
                                            elevation: 5.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            check();
                                          },
                                          child: Text(
                                            "تحقق",
                                            style: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: 1.5,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  40,
                                            ),
                                          ),
                                        ),
                                        _buildSignUpBtn()
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                isLoading == true
                    ? Container(
                        color: Colors.white12,
                        width: double.infinity,
                        height: double.infinity,
                        child:
                            const Center(child: CupertinoActivityIndicator()))
                    : const SizedBox(height: 0),
              ],
            )),
      ),
    );
  }

  Widget _buildSignUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: TextButton(
            onPressed: () {
              stopTimer();
              Get.offAll(() => const HomeScreen());
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'إلغاء التحقق ',
                  style: TextStyle(
                    color: AppTheme.appTheme.primaryColor,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'علوم الديرة',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
