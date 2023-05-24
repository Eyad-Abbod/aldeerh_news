import 'dart:async';
import 'dart:io';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:aldeerh_news/shared_ui/customtextfield.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddImage> {
  var isDeviceConnected = false;
  bool isAlertSet = false;
  bool canSendNews = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  File? file;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();

  bool isLoading = false;
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

  addImage() async {
    if (formstate.currentState!.validate()) {
      if (canSendNews == true) {
        if (file == null) {
          showToast();
        } else {
          canSendNews = false;
          isLoading = true;
          if (mounted) {
            setState(() {});
          }
          var response = await _curd.postRequestWithFile(
              linkAddImage, {'name': title.text}, file!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text('إضافة صورة'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.appTheme.primaryColor,
        label: const Text('إضافة الصورة'),
        onPressed: () async => await addImage(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formstate,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: [
                          file != null
                              ? SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Image.file(
                                    file!,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Container(
                                  width: 200,
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Center(child: Text('اختر صورة')),
                                ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 150.0,
                                // height: 100.0,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      pickImage(ImageSource.gallery),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.appTheme
                                        .primaryColor, // Background color
                                  ),
                                  child: const Text(
                                    'متصفح الصور',
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: 150.0,
                                  // height: 100.0,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        pickImage(ImageSource.camera),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.appTheme
                                          .primaryColor, // Background color
                                    ),
                                    child: const Text(
                                      'الكاميرا',
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Column(
                        children: [
                          CustTextFormSign(
                            ourInput: TextInputType.name,
                            hint: "اسم الصورة",
                            maxl: 1,
                            mycontroller: title,
                            myMaxlength: 15,
                            valid: (val) {
                              return validInput(val!, 4, 15);
                            },
                            icon: Icons.ac_unit,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Text('صور إضافية',
                    //     style: TextStyle(
                    //         fontSize: 18,
                    //         color: AppTheme.appTheme.primaryColor)),

                    // IconButton(
                    //     onPressed: () => selectImages(),
                    //     icon: const Icon(Icons.camera_alt)),
                    // GridView.builder(
                    //   padding: const EdgeInsets.all(2),
                    //   scrollDirection: Axis.vertical,
                    //   shrinkWrap: true,
                    //   gridDelegate:
                    //       const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 3,
                    //   ),
                    //   itemCount: _iamgesList.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return Container(
                    //       padding: const EdgeInsets.all(2.0),
                    //       child: Stack(
                    //         children: [
                    //           ClipRRect(
                    //               borderRadius: BorderRadius.circular(8.0),
                    //               child: Image.file(
                    //                   File(_iamgesList[index].path))),
                    //           IconButton(
                    //               onPressed: () {
                    //                 _iamgesList.removeAt(index);
                    //                 if (mounted) {
                    //   setState(() {});
                    // }
                    //               },
                    //               icon: const Icon(
                    //                 Icons.delete,
                    //                 color: Colors.red,
                    //               )),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // ),

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
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.white38,
                  width: double.infinity,
                  height: double.infinity,
                  child: const Center(child: CupertinoActivityIndicator()))
              : const SizedBox(height: 0),
        ],
      ),
    );
    // Widget buildMessageButton() => FloatingActionButton.extended(
    //     icon: Icon(Icons.message), onPressed: () {}, label: Text('أرسل الخبر'));
  }

  void showToast() =>
      CherryToast.success(title: const Text("بجب إضافة صورة")).show(context);

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
