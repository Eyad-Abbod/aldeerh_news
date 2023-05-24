import 'dart:async';
import 'dart:io';
import 'package:aldeerh_news/main.dart';
import 'package:aldeerh_news/shared_ui/customtextfield.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:transparent_image/transparent_image.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({
    Key? key,
    required this.name,
    required this.uspho,
  }) : super(key: key);
  final String name;
  final String uspho;

  @override
  State<PersonalPage> createState() => _AddNewsState();
}

class _AddNewsState extends State<PersonalPage> {
  bool canSendNews = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    name.text = widget.name;
  }

  @override
  void dispose() {
    // streamSubscription.cancel();
    super.dispose();
  }

  File? file;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  final Curd _curd = Curd();
  Future pickImage(ImageSource source) async {
    try {
      final iamge = await ImagePicker().pickImage(source: source);
      if (iamge == null) return;

      final imageTemporary = File(iamge.path);
      if (mounted) {
        setState(() => file = imageTemporary);
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  editPerson() async {
    if (formstate.currentState!.validate()) {
      if (canSendNews == true) {
        if (file == null && name.text == widget.name && errorText == null) {
          if (mounted) {
            AwesomeDialog(
              context: context,
              animType: AnimType.TOPSLIDE,
              dialogType: DialogType.ERROR,
              // dialogColor: AppTheme.appTheme.primaryColor,
              title: 'عذراً',
              desc: 'لم تقم بتعديل أي بيانات',
              btnOkOnPress: () {},
              btnOkColor: Colors.blue,
              btnOkText: 'خروج',
            ).show();
          }
        } else {
          canSendNews = false;
          isLoading = true;
          if (mounted) {
            setState(() {});
          }
          if (file == null) {
            var response = await _curd.postRequest(linkEditPersonInfo, {
              'name': name.text,
              'usid': sharedPref.getString("usid")!.toString()
            });
            isLoading = false;

            if (mounted) {
              setState(() {});
            }

            if (response == 'Error') {
              canSendNews = true;
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
                  await AwesomeDialog(
                          context: context,
                          animType: AnimType.TOPSLIDE,
                          dialogType: DialogType.SUCCES,
                          // dialogColor: AppTheme.appTheme.primaryColor,
                          title: 'نجاح',
                          desc: 'تم تعديل بياناتك بنجاح',
                          btnCancelOnPress: () => Get.back(),
                          btnCancelColor: Colors.blue,
                          btnCancelText: 'خروج')
                      .show();
                }

                if (response["img"].toString() != 'no') {
                  sharedPref.setString("uspho", response["img"].toString());
                }
                if (name.text != widget.name) {
                  sharedPref.setString("name", name.text);
                }
                // sharedPref.setString("name", name.text);
                // sharedPref.setString("uspho", widget.uspho);
                Get.back();
              } else {
                canSendNews = true;
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
              }
            }
          } else {
            var response = await _curd.postRequestWithFile(
                linkEditPersonInfo,
                {
                  'name': name.text,
                  'usid': sharedPref.getString("usid")!.toString()
                },
                file!);
            isLoading = false;
            if (mounted) {
              setState(() {});
            }

            if (response == 'Error') {
              canSendNews = true;
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
                  await AwesomeDialog(
                          context: context,
                          animType: AnimType.TOPSLIDE,
                          dialogType: DialogType.SUCCES,
                          // dialogColor: AppTheme.appTheme.primaryColor,
                          title: 'نجاح',
                          desc: 'تم إضافة الصورة بنجاح',
                          btnCancelOnPress: () => Get.back(),
                          btnCancelColor: Colors.blue,
                          btnCancelText: 'خروج')
                      .show();
                }
                if (response["img"].toString() != 'no') {
                  sharedPref.setString("uspho", response["img"].toString());
                }
                if (name.text != widget.name) {
                  sharedPref.setString("name", name.text);
                }
                Get.back();
              } else {
                canSendNews = true;
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
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text('البيانات الشخصية'),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.settings),
        //   )
        // ],
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, top: 30, right: 15),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Form(
                key: formstate,
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1)),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: file != null
                                    ? Image.file(file!).image
                                    : sharedPref
                                                .getString("uspho")!
                                                .toString() !=
                                            ''
                                        ? FadeInImage.memoryNetwork(
                                            fit: BoxFit.cover,
                                            height: 100,
                                            width: 100,
                                            fadeInDuration: const Duration(
                                                milliseconds: 500),
                                            fadeOutDuration: const Duration(
                                                milliseconds: 500),
                                            placeholder: kTransparentImage,
                                            image: linkUserImageRoot +
                                                widget.uspho,
                                            imageErrorBuilder: (c, o, s) =>
                                                Image.asset(
                                              "assets/AlUyun2.png",
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                            placeholderErrorBuilder:
                                                (c, o, s) => Image.asset(
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
                                            fadeInDuration: const Duration(
                                                milliseconds: 500),
                                            fadeOutDuration: const Duration(
                                                milliseconds: 500),
                                            placeholder: kTransparentImage,
                                            image: '${linkImageRoot}AlUyun.png',
                                            imageErrorBuilder: (c, o, s) =>
                                                Image.asset(
                                              "assets/AlUyun2.png",
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                            placeholderErrorBuilder:
                                                (c, o, s) => Image.asset(
                                              "assets/AlUyun2.png",
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                            // repeat: ImageRepeat.repeat,
                                          ).image,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                pickImage(ImageSource.gallery);
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: Colors.white,
                                  ),
                                  color: Colors.blue,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // const Text(
                    //   'اسم المستخدم:',
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    // Row(
                    //   children: [
                    //     IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                    //     Text(
                    //       widget.name,
                    //       style:
                    //           const TextStyle(fontSize: 26, color: Colors.blue),
                    //     ),
                    //   ],
                    // ),
                    CustTextFormSign(
                      ourInput: TextInputType.name,
                      hint: "اسم المستخدم",
                      maxl: 1,
                      mycontroller: name,
                      myMaxlength: 40,
                      valid: (val) {
                        return validInputName(val!, 4, 40);
                      },
                      icon: Icons.ac_unit,
                    ),
                    // buildTextField('اسم المستخدم', 'الاسم', false),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text(
                            'خروج',
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 2,
                                color: Colors.black),
                          ),
                        ),
                        errorText == null
                            ? ElevatedButton(
                                onPressed: () => editPerson(),
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: const Text('حفظ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 2,
                                        color: Colors.white)),
                              )
                            : ElevatedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: const Text('حفظ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 2,
                                        color: Colors.white)),
                              )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          isLoading == true
              ? Container(
                  color: Colors.white12,
                  width: double.infinity,
                  height: double.infinity,
                  child: const Center(child: CupertinoActivityIndicator()))
              : const SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        // obscureText: isPasswordTextField ? isObscurePassword : false,
        controller: name,
        decoration: InputDecoration(
          errorText: errorText,
          // icon: Icon(Icons.info),
          contentPadding: const EdgeInsets.only(bottom: 5),
          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 24),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }

  String? get errorText {
    // at any time, we can get the text from _controller.value.text
    final text = name.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'لا يمكن أن يكون الاسم فارغ';
    }
    if (text.length < 4) {
      return 'الاسم صغير';
    }
    // return null if the text is valid
    return null;
  }

  // showDilogBox() => showCupertinoDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //           title: Text('لا يتوفر إتضال بالإنترنت'),
  //           content: Text('أعد الإتصال بالإنترنت'),
  //           actions: [
  //             TextButton(
  //                 onPressed: () async {
  //                   Navigator.pop(context, 'Cancel');
  //                   setState(() => isAlertSet = false);
  //                   isDeviceConnected =
  //                       await InternetConnectionChecker().hasConnection;
  //                   if (!isDeviceConnected) {
  //                     showDilogBox();
  //                     setState(() => isAlertSet = true);
  //                   }
  //                 },
  //                 child: Text('OK'))
  //           ],
  //         ));
}
