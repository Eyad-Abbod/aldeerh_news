import 'dart:async';
import 'dart:io';
import 'package:aldeerh_news/main.dart';
import 'package:aldeerh_news/screens/home_screen.dart';
import 'package:aldeerh_news/shared_ui/policy_and_terms.dart';
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

class AddFromBottomScreen extends StatefulWidget {
  const AddFromBottomScreen({Key? key, required this.title, required this.type})
      : super(key: key);
  final String title;
  final String type;
  @override
  State<AddFromBottomScreen> createState() => _AddFromBottomScreenState();
}

class _AddFromBottomScreenState extends State<AddFromBottomScreen> {
  // late StreamSubscription streamSubscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  bool canSendNews = true;
  bool agree = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // streamSubscription.cancel();
    super.dispose();
  }

  File? file;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  List<File> imagesFileList = [];
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
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

  addNews() async {
    FocusScope.of(context).unfocus();
    if (formstate.currentState!.validate()) {
      if (canSendNews == true) {
        if (agree == false) {
          showToast("يجب الموافقة على الشروط والأحكام");
        } else if (file == null) {
          showToast("بجب إضافة صورة للخبر");
        } else {
          canSendNews = false;

          var moreImages = 'no';
          if (imagesFileList.isNotEmpty) {
            moreImages = 'yes';
          }
          isLoading = true;
          if (mounted) {
            setState(() {});
          }

          var response = await _curd.postRequestWithFiles(
              linkAddNews,
              {
                'ns_title': title.text,
                'ns_txt': content.text,
                'usid': sharedPref.getString('usid'),
                'ns_ty': widget.type,
                'moreImg': moreImages,
                'state': '2',
              },
              file!,
              imagesFileList);
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
              _curd.postRequestNotificationsForAdmin(
                  title.text, content.text, widget.type);
              if (mounted) {
                await AwesomeDialog(
                        context: context,
                        animType: AnimType.TOPSLIDE,
                        dialogType: DialogType.SUCCES,
                        // dialogColor: AppTheme.appTheme.primaryColor,
                        title: 'نجاح',
                        desc: 'الخبر قيد المراجعة من قبل الإدارة',
                        btnOkOnPress: () => onOpen('583099051'),
                        btnOkColor: AppTheme.appTheme.primaryColor,
                        btnOkText: 'مراسلة الإدارة',
                        btnCancelOnPress: () =>
                            Get.offAll(() => const HomeScreen()),
                        btnCancelColor: Colors.blue,
                        btnCancelText: 'خروج')
                    .show();
              }
              Get.to(() => const HomeScreen());
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

  void selectImages() async {
    try {
      final List<XFile> selectedImages = await ImagePicker().pickMultiImage();
      if (selectedImages.isNotEmpty) {
        for (int i = 0; i < selectedImages.length; i++) {
          imagesFileList.add(File(selectedImages[i].path));
        }
      }

      debugPrint('Images list lingth :${selectedImages.length}');
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appTheme.primaryColor,
          title: Text(widget.title),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          backgroundColor: AppTheme.appTheme.primaryColor,
          label: const Text('أرسل الخبر'),
          onPressed: () async => await addNews(),
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
                                    child:
                                        const Center(child: Text('اختر صورة')),
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
                              hint: "عنوان الخبر",
                              maxl: 1,
                              mycontroller: title,
                              myMaxlength: 50,
                              valid: (val) {
                                return validInput(val!, 4, 50);
                              },
                              icon: Icons.ac_unit,
                            ),
                            CustTextFormSign(
                              ourInput: TextInputType.multiline,
                              hint: 'تفاصيل الخبر',
                              maxl: 5,
                              myMaxlength: 0,
                              mycontroller: content,
                              valid: (val) {
                                return validInput(val!, 4, 1000);
                              },
                              icon: Icons.ac_unit,
                            ),
                            Center(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: agree,
                                    onChanged: (newValue) {
                                      if (mounted) {
                                        setState(() => agree = newValue!);
                                      }
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Get.to(() => const PolicyAndTerms()),
                                    child: const Text(
                                      'الموافقة على الشروط والأحكام',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text("صور إضافية",
                          style: TextStyle(
                              color: AppTheme.appTheme.primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                        color: AppTheme.appTheme.primaryColor,
                        onPressed: selectImages,
                        icon: const Icon(Icons.photo_library),
                      ),
                      imagesFileList.isNotEmpty
                          ? addNewsImages()
                          : const Text(''),
                      const SizedBox(height: 80),
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
      ),
    );
    // Widget buildMessageButton() => FloatingActionButton.extended(
    //     icon: Icon(Icons.message), onPressed: () {}, label: Text('أرسل الخبر'));
  }

  void showToast(String message) =>
      CherryToast.success(title: Text(message)).show(context);

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
  Widget addNewsImages() {
    return Column(
      children: [
        const SizedBox(height: 15),
        GridView.builder(
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.all(2),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: imagesFileList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.all(2.0),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 180.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        imagesFileList[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          imagesFileList.removeAt(index);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
