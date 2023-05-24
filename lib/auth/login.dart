import 'dart:math';

import 'package:aldeerh_news/auth/check.dart';
import 'package:aldeerh_news/auth/signup.dart';
import 'package:aldeerh_news/shared_ui/customtextfield.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formstate = GlobalKey();
  final Curd _curd = Curd();
  bool isLoading = false;
  String vSms = '';
  Random random = Random();

  TextEditingController usph = TextEditingController();
  // late SharedPreferences sharedPref;

  login() async {
    FocusScope.of(context).unfocus();
    if (formstate.currentState!.validate()) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      var response = await _curd.postRequest(linkLogin, {'usph': usph.text});

      if (response == 'Error') {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
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
          vSms = (random.nextInt(10)).toString() +
              (random.nextInt(10)).toString() +
              (random.nextInt(10)).toString() +
              (random.nextInt(10)).toString();
          var response = await _curd
              .postRequest(linkCheck, {'usph': usph.text, 'v_sms': vSms});
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
              _curd.postRequestSMS(usph.text.substring(1), vSms);

              if (mounted) {
                setState(() {
                  isLoading = false;
                });
                await AwesomeDialog(
                  context: context,
                  animType: AnimType.TOPSLIDE,
                  dialogType: DialogType.SUCCES,
                  // dialogColor: AppTheme.appTheme.primaryColor,
                  title: 'نجاح',
                  desc: 'تم إرسال رقم التحقق',
                  btnOkOnPress: () => Get.to(() => Check(
                    sms: vSms,
                    name: response["data"]["name"].toString(),
                    usid: response["data"]["usid"].toString(),
                    usph: usph.text,
                    uspho: response["data"]["uspho"].toString(),
                  )),
                  btnOkColor: AppTheme.appTheme.primaryColor,
                  btnOkText: 'Ok',
                ).show();
              }
              Get.to(
                    () => Check(
                  sms: vSms,
                  name: response["data"]["name"].toString(),
                  usid: response["data"]["usid"].toString(),
                  usph: usph.text,
                  uspho: response["data"]["uspho"].toString(),
                ),
              );
            }
          }
        } else {
          if (mounted) {
            AwesomeDialog(
              context: context,
              animType: AnimType.TOPSLIDE,
              dialogType: DialogType.ERROR,
              title: "خطأ",
              desc: "لا يوجد حساب بهذا الرقم",
              btnOkOnPress: () {},
              btnOkColor: Colors.red,
              btnOkText: 'رجوع',
            ).show();
          }
        }
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
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Form(
                                        key: formstate,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "تسجيل الدخول",
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

                                            // const SizedBox(height: 30),
                                            CustTextFormSign(
                                              ourInput: const TextInputType
                                                      .numberWithOptions(
                                                  decimal: true),
                                              hint: 'أدخل رقم الهاتف',
                                              maxl: 1,
                                              mycontroller: usph,
                                              myMaxlength: 10,
                                              valid: (val) {
                                                return validInput(val!, 10, 10);
                                              },
                                              icon: Icons.phone,
                                            ),
                                            // const SizedBox(height: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.black87,
                                                backgroundColor: AppTheme
                                                    .appTheme.primaryColor,
                                                elevation: 5.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                login();
                                              },
                                              child: Text(
                                                "تسجيل",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  letterSpacing: 1.5,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          40,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 10,
                                            ),
                                            _buildSignUpBtn(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                AppTheme.appTheme.primaryColor),
                                        child: IconButton(
                                          onPressed: () => Get.back(),
                                          icon: const Icon(
                                            Icons.arrow_back_outlined,
                                            size: 20,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
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
          padding: const EdgeInsets.only(top: 30),
          child: TextButton(
            onPressed: () {
              Get.to(() => const SignUp());
            },
            child: Column(
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'ليس لديك حساب بعد؟ ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height / 40,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ]),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'إنشاء حساب ',
                      style: TextStyle(
                        color: AppTheme.appTheme.primaryColor,
                        fontSize: MediaQuery.of(context).size.height / 40,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]),
                ),
              ],
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
