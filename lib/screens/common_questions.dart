import 'dart:convert';

import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/link_app.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class CommonQuestions extends StatefulWidget {
  const CommonQuestions({Key? key}) : super(key: key);

  @override
  State<CommonQuestions> createState() => _CommonQuestionsState();
}

class _CommonQuestionsState extends State<CommonQuestions> {
  bool isTextLoading = true;
  // String title = '';
  String title = '';

  void firstLoad() async {
    try {
      isTextLoading = true;
      var response = await http.get(Uri.parse('$linkGetTextAbout?id=3'));
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
        title: const Text('الأسئلة الشائعة'),
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

                // ),
                const SizedBox(
                  height: 30,
                ),

                const SizedBox(
                  height: 10,
                ),
                title == ''
                    ? Padding(
                  padding: const EdgeInsets.only(
                      top: 100.0, bottom: 100.0),
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off,
                              color: AppTheme.appTheme.primaryColor,
                              size: 44),
                          Text(
                            'لا يوجد اتصال بالإنترنت',
                            style: TextStyle(
                              fontSize: 22,
                              color: AppTheme.appTheme.primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.extended(
                              label:
                              const Text('اعادة تحميل'), // <-- Text
                              backgroundColor:
                              AppTheme.appTheme.primaryColor,
                              icon: const Icon(
                                // <-- Icon
                                Icons.refresh,
                                size: 24.0,
                              ),
                              onPressed: () => firstLoad(),
                            ),
                          ),
                        ],
                      )),
                )
                    : Text(title,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
