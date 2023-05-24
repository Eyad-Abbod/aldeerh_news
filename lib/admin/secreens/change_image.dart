import 'dart:convert';
import 'package:aldeerh_news/admin/operations/add_image.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/image_model.dart';
import 'package:aldeerh_news/utilities/link_app.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class ChangeNewsImage extends StatefulWidget {
  const ChangeNewsImage({super.key, required this.nsid, required this.nsImg});
  final String nsid;
  final String nsImg;

  @override
  State<ChangeNewsImage> createState() => _ChangeUserState();
}

class _ChangeUserState extends State<ChangeNewsImage> {
  bool isLoading = false;
  bool isUpdateing = false;
  List<ImageModel> images = <ImageModel>[];

  final Curd curd = Curd();
  Future fetchs() async {
    try {
      var response = await http.get(Uri.parse(linkShowImage));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print(data[1]);
        for (var item in data) {
          images.add(ImageModel.fromJson(item));
        }
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
      } else {
        if (mounted) {
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
        }

        fetchs();
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        debugPrint("Something went wrong");
        if (mounted) {
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
        }
        fetchs();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    images.clear();
  }

  @override
  void initState() {
    super.initState();
    fetchs();
  }

  //  List<ImageModel> display_list = await List.from(fetchs);
  editNewsImage(String nsImg) async {
    // return Iterable<ImageFile>

    isUpdateing = true;
    if (mounted) {
      if (mounted) {
        setState(() {});
      }
    }
    dynamic response;

    response = await curd.postRequest(linkChangeImage, {
      'nsid': widget.nsid.toString(),
      'ns_img': nsImg.toString(),
    });

    isUpdateing = false;
    if (mounted) {
      if (mounted) {
        setState(() {});
      }
    }
    if (response['status'] == 'exist') {
      if (mounted) {
        AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.WARNING,
          // dialogColor: AppTheme.appTheme.primaryColor,
          title: 'عذراً',
          desc: 'لم تقم بتعديل أي بيانات',
          btnOkOnPress: () {},
          btnOkColor: Colors.blue,
          btnOkText: 'خروج',
        ).show();
      }
    } else {
      if (response['status'] == 'success') {
        if (mounted) {
          await AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            dialogType: DialogType.SUCCES,
            title: 'نجاح',
            desc: 'تم التعديل بنجاح',
            btnOkOnPress: () {},
            btnOkColor: Colors.blue,
            btnOkText: 'خروج',
          ).show();
        }
        if (mounted) {
          Navigator.pop(context, nsImg);
        }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text('تغير صورة الخبر'),
        actions: [
          IconButton(
            onPressed: () {
              if (mounted) {
                setState(() {
                  isLoading = false;
                  images.clear();
                  fetchs();
                });
              }
            },
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton(
            itemBuilder: ((context) => [
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        // String val = await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (BuildContext context) {
                        //     return AddImage();
                        //   }),
                        // );
                        Get.to(() => const AddImage());
                        // print(val);
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.image,
                            color: Colors.black,
                          ),
                          Text(' إضافة صورة'),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        ],
      ),
      body: isLoading == false
          ? WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
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
            )
          : WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'إبحث عن المستخدم المطلوب',
                        //   style: TextStyle(
                        //     color: Colors.redAccent,
                        //     fontSize: 22.0,
                        //   ),
                        // ),
                        // SizedBox(height: 20.0),
                        // TextField(
                        //   onChanged: (value) => updateList(value),
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.blueGrey,
                        //     border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(8.0),
                        //         borderSide: BorderSide.none),
                        //     // hintText: "ابحث",

                        //     prefixIcon: const Icon(Icons.search),
                        //     prefixIconColor: Colors.purple.shade900,
                        //   ),
                        // ),
                        const SizedBox(height: 20.0),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'الصورة',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'اسم الصورة',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: images.length,
                                itemBuilder: ((context, index) => InkWell(
                                      onTap: () {
                                        editNewsImage(
                                          images[index].imgName!,
                                        );
                                      },
                                      child: Container(
                                        color: const Color.fromRGBO(
                                            245, 245, 245, 1),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 4.0, left: 4.0),
                                          child: Card(
                                            elevation: 3.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 100.0,
                                                    height: 100.0,
                                                    child: Stack(
                                                      children: [
                                                        const Center(
                                                            child:
                                                                CupertinoActivityIndicator(
                                                                    radius:
                                                                        15)),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: FadeInImage
                                                              .memoryNetwork(
                                                            fit: BoxFit.cover,
                                                            height: 100,
                                                            width: 100,
                                                            fadeInDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            fadeOutDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            placeholder:
                                                                kTransparentImage,
                                                            image: linkImageRoot +
                                                                images[index]
                                                                    .imgName!,
                                                            imageErrorBuilder:
                                                                (c, o, s) =>
                                                                    Image.asset(
                                                              "assets/AlUyun2.png",
                                                              height: 100,
                                                              width: 100,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            placeholderErrorBuilder:
                                                                (c, o, s) =>
                                                                    Image.asset(
                                                              "assets/AlUyun2.png",
                                                              height: 100,
                                                              width: 100,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            // repeat: ImageRepeat.repeat,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            images[index]
                                                                .imgName!,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              AwesomeDialog(
                                                                      context:
                                                                          context,
                                                                      animType:
                                                                          AnimType
                                                                              .TOPSLIDE,
                                                                      dialogType: DialogType
                                                                          .QUESTION,
                                                                      title:
                                                                          'تحذير',
                                                                      desc:
                                                                          'هل أنت متأكد من عملية الحذف',
                                                                      btnOkOnPress:
                                                                          () async {
                                                                        var response = await curd.postRequest(
                                                                            linkDeleteMainImage,
                                                                            {
                                                                              "id": images[index].id,
                                                                              "img_name": images[index].imgName,
                                                                            });
                                                                        // print(response['status']);
                                                                        if (response ==
                                                                            'Error') {
                                                                          // canSendNews =
                                                                          true;
                                                                          isLoading =
                                                                              false;
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
                                                                          if (response['status'] ==
                                                                              'success') {
                                                                            if (mounted) {
                                                                              await AwesomeDialog(
                                                                                context: context,
                                                                                animType: AnimType.TOPSLIDE,
                                                                                dialogType: DialogType.SUCCES,
                                                                                title: 'نجاح',
                                                                                desc: 'تمت عملية الحذف بنجاح',
                                                                                btnOkOnPress: () {
                                                                                  if (mounted) {
                                                                                    setState(() {});
                                                                                  }
                                                                                },
                                                                                btnOkColor: Colors.blue,
                                                                                btnOkText: 'خروج',
                                                                              ).show();
                                                                              setState(() {
                                                                                images.removeAt(index);
                                                                              });
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
                                                                      },
                                                                      btnOkColor:
                                                                          Colors
                                                                              .red,
                                                                      btnOkText:
                                                                          'حذف',
                                                                      btnCancelOnPress:
                                                                          () {},
                                                                      btnCancelColor:
                                                                          Colors
                                                                              .blue,
                                                                      btnCancelText:
                                                                          'تراجع')
                                                                  .show();
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
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )))),
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context, ''),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Center(
                                child: Text(
                              'تراجع',
                              style: TextStyle(),
                            ))),
                      ],
                    ),
                  ),
                  isUpdateing == true
                      ? Container(
                          color: Colors.white12,
                          width: double.infinity,
                          height: double.infinity,
                          child:
                              const Center(child: CupertinoActivityIndicator()))
                      : const SizedBox(height: 0),
                ],
              ),
            ),
    );
  }
}
