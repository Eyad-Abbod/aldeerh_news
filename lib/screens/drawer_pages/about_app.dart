import 'dart:convert';

import 'package:aldeerh_news/screens/common_questions.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/link_app.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  bool isTextLoading = true;
  // String title = '';
  String title = '';

  void firstLoad() async {
    try {
      var response = await http.get(Uri.parse('$linkGetTextAbout?id=1'));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        // title.addAll(json.decode(responsebody));

        title = responsebody['data'][0]['text'];
        // print(title);
        if (mounted) {
          setState(() {
            isTextLoading = false;
          });
        }
      } else {
        title = '';
        if (mounted) {
          setState(() {
            isTextLoading = false;
          });
        }
      }

      // var response = await http.get(Uri.parse('$linkGetTextAbout?id=1'));
      // title.addAll(json.decode(response.body));
      // print(title[0]['data']);
    } catch (e) {
      title = '';
      if (mounted) {
        setState(() {
          isTextLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    firstLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text('عن التطبيق'),
        centerTitle: true,
      ),
      body: isTextLoading
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      // GestureDetector(
                      //   // onLongPress: () => checkIsAdmin(),
                      //   child:
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20),
                      //   child: Container(
                      //     width: 200.0,
                      //     height: 200.0,
                      //     decoration: BoxDecoration(
                      //       color: AppTheme.appTheme.primaryColor,
                      //       image: const DecorationImage(
                      //         image: AssetImage('assets/AlUyun.png'),
                      //         fit: BoxFit.cover,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //   ),
                      // ),
                      // ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text('علوم الديرة',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      title == ''
                          ? Column(
                              children: const [
                                Text(
                                    "تطبيق يهتم بنشر مناسبات وأحداث وأخبار أهالي مدينة العيون",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center),
                                SizedBox(height: 15),
                                Text(
                                    "(عقد قران - زواج - مولود - ترقية - أخبار النادي - تبرع دم - وفاة - قصائد - مقالات - مناسبات أخبار عامة",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center)
                              ],
                            )
                          : Text(title,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center),

                      const SizedBox(
                        height: 80,
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => const CommonQuestions()),
                        child: const Text(
                          'الأسئلة الشائعة',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,),
                        ),
                      )


                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // const Text(
                      //     '(عقد قران - زواج - مولود - ترقية - أخبار النادي - تبرع دم - وفاة - قصائد - مقالات - مناسبات أخبار عامة)',
                      //     style: TextStyle(
                      //       fontSize: 20,
                      //     ),
                      //     textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
