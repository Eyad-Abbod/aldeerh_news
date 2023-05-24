import 'dart:async';
import 'dart:io';
import 'package:aldeerh_news/main.dart';
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

class AddNewsAdmin extends StatefulWidget {
  const AddNewsAdmin({Key? key}) : super(key: key);

  @override
  State<AddNewsAdmin> createState() => _AddNewsAdminState();
}

class _AddNewsAdminState extends State<AddNewsAdmin> {
  // late StreamSubscription streamSubscription;
  // late DateTime lastDate;
  DateTime dateTime = DateTime.now();
  DateTime dateTimeToUplode = DateTime.now();
  late String formattedDate;

  var isDeviceConnected = false;
  bool isAlertSet = false;
  bool canSendNews = true;
  int type = 1;
  int typeOf = 0;

  @override
  void initState() {
    // lastDate = DateTime.now();
    // lastDate = lastDate.add(const Duration(days: 60));

    // formattedDate = DateFormat('d,MM,yyyy').format(dateTime);
    super.initState();
  }

  @override
  void dispose() {
    content.dispose();
    title.dispose();
    super.dispose();
  }

  File? file;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  final List<XFile> _iamgesList = [];
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

  addNewsAdmin() async {
    FocusScope.of(context).unfocus();
    if (formstate.currentState!.validate()) {
      if (canSendNews == true) {
        if (file == null) {
          showToast();
        } else {
          canSendNews = false;

          List<File> files = [];
          for (int i = 0; i < _iamgesList.length; i++) {
            files.add(File(_iamgesList[i].path));
          }
          var moreImages = 'no';
          if (_iamgesList.isNotEmpty) {
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
                'ns_ty': type.toString(),
                'moreImg': moreImages,
                'ns_pos': typeOf.toString(), //
                'dates':
                    '${dateTimeToUplode.year}-${dateTimeToUplode.month}-${dateTimeToUplode.day}', //
                'state': '2', //
              },
              file!,
              files);
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
                  desc: 'تم إضافة المنشور بنجاح ',
                  btnOkOnPress: () => Get.back(),
                  btnOkColor: AppTheme.appTheme.primaryColor,
                  btnOkText: 'خروج',
                ).show();
              }
              Get.back();
            } else {
              if (mounted) {
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
        _iamgesList.addAll(selectedImages);
      }

      debugPrint('Images list lingth :${_iamgesList.length}');
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text('إضافة منشور'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.appTheme.primaryColor,
        label: const Text('إضافة المنشور'),
        onPressed: () => addNewsAdmin(),
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
                    buildNewsImage(context),
                    const SizedBox(height: 10),
                    buildNewsType(context),
                    const SizedBox(height: 15),
                    buildMoreImages(context),
                  ],
                ),
              ),
            ),
          ),
          isLoading
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

  Widget buildNewsImage(BuildContext context) {
    return Card(
      elevation: 5.0,
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
                  onPressed: () => pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppTheme.appTheme.primaryColor, // Background color
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
                    onPressed: () => pickImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppTheme.appTheme.primaryColor, // Background color
                    ),
                    child: const Text(
                      'الكاميرا',
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget buildNewsType(BuildContext context) {
    return Padding(
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
              return validInput(val!, 4, 0);
            },
            icon: Icons.ac_unit,
          ),
          Container(
            width: Get.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    'نوع المنشور',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: type,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => type = value!);
                          }
                        },
                      ),
                      const Text(
                        'خبر',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: type,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => type = value!);
                          }
                        },
                      ),
                      const Text(
                        'إعلان',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 3,
                        groupValue: type,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => type = value!);
                          }
                        },
                      ),
                      const Text(
                        'شخصيات',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 4,
                        groupValue: type,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => type = value!);
                          }
                        },
                      ),
                      const Text(
                        'خواطر ومشاركات',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 5,
                        groupValue: type,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => type = value!);
                          }
                        },
                      ),
                      const Text(
                        'أسر منتجة',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            width: Get.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    'حالة المنشور',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: typeOf,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => typeOf = value!);
                          }
                        },
                      ),
                      const Text(
                        'عدم التثبيت',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: typeOf,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() => typeOf = value!);
                          }
                        },
                      ),
                      const Text(
                        'تثبيت في الأعلى',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          type == 2
              ? Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'تاريخ إنهاء العرض',
                          style: TextStyle(fontSize: 20),
                        ),

                        // TextButton(
                        //     child: Text(dateTime.toString()),
                        //     onPressed: () => GetUtils.showSheet(context,
                        //             child: buildDatePicker(), onClicked: () {
                        //           Navigator.pop(context);
                        //         })),

                        TextButton(
                          child: Text(
                              '${dateTimeToUplode.year}-${dateTimeToUplode.month}-${dateTimeToUplode.day}'),
                          onPressed: () => showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                              actions: [
                                buildDatePicker(),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('Done'),
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      dateTimeToUplode = dateTime;
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ),

                        // InkWell(
                        //   onTap: () {},
                        //   child: buildDatePicker(),
                        // ),
                        // InkWell(
                        //   onTap: () async {
                        //     DateTime? newDate = await showDatePicker(
                        //       context: context,
                        //       initialDate: lastDate,
                        //       firstDate: DateTime(2022),
                        //       lastDate: DateTime(2029),
                        //     );
                        //     if (newDate == null) return;
                        //     lastDate = newDate;

                        //     setState(() => formattedDate =
                        //         DateFormat('d,MM,yyyy').format(lastDate));
                        //   },
                        //   child: Row(
                        //     children: [
                        //       const Icon(Icons.date_range),
                        //       Text(
                        //         formattedDate.toString(),
                        //         style: TextStyle(color: Colors.blue.shade700),
                        //       )
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ))
              : const SizedBox(height: 0)
        ],
      ),
    );
  }

  Widget buildMoreImages(BuildContext context) {
    return Column(
      children: [
        Text('صور إضافية',
            style:
                TextStyle(fontSize: 18, color: AppTheme.appTheme.primaryColor)),
        IconButton(
            onPressed: () => selectImages(),
            icon: const Icon(Icons.camera_alt)),
        GridView.builder(
          padding: const EdgeInsets.all(2),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: _iamgesList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.all(2.0),
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(File(_iamgesList[index].path))),
                  IconButton(
                      onPressed: () {
                        _iamgesList.removeAt(index);
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // static void showSheet(
  //   BuildContext context, {
  //   required Widget child,
  //   required VoidCallback onClicked,
  // }) =>
  //     showCupertinoModalPopup(
  //         context: context,
  //         builder: (context) => CupertinoActionSheet(
  //               actions: [
  //                 child,
  //               ],
  //               cancelButton: CupertinoActionSheetAction(
  //                 child: Text('Done'),
  //                 onPressed: onClicked,
  //               ),
  //             ));

  Widget buildDatePicker() => SizedBox(
        height: 250,
        child: CupertinoDatePicker(
            initialDateTime: dateTime,
            minimumYear: DateTime.now().year,
            maximumYear: 2027,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (dateTime) => setState(
                  (() => this.dateTime = dateTime),
                )),
      );

  void showToast() =>
      CherryToast.success(title: const Text("بجب إضافة صورة للخبر"))
          .show(context);
}
