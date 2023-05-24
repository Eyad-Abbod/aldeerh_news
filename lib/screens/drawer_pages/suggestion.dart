import 'package:aldeerh_news/main.dart';
import 'package:aldeerh_news/screens/home_screen.dart';
import 'package:aldeerh_news/shared_ui/customtextfield.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/crud.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class Suggestion extends StatefulWidget {
  const Suggestion({Key? key}) : super(key: key);

  @override
  State<Suggestion> createState() => _AboutAppState();
}

class _AboutAppState extends State<Suggestion> {
  bool isLoading = false;
  bool canSend = true;

  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final Curd _curd = Curd();
  double rating = 0;

  addSuggestion() async {
    if (formstate.currentState!.validate()) {
      if (canSend == true) {
        isLoading = true;
        canSend = false;
        if (mounted) {
          setState(() {});
        }
        int a = rating.toInt();
        var response = await _curd.postRequest(linkAddSugg, {
          'usid': sharedPref.getString('usid'),
          'rat': a.toString(),
          'tex': content.text,
        });
        isLoading = false;

        if (mounted) {
          setState(() {});
        }
        if (response == 'Error') {
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
        } else {
          if (response['status'] == 'success') {
            if (mounted) {
              AwesomeDialog(
                context: context,
                animType: AnimType.TOPSLIDE,
                dialogType: DialogType.SUCCES,
                // dialogColor: AppTheme.appTheme.primaryColor,
                title: 'نجاح',
                desc: 'شكراً لك... تم رفع إقتراحك بنجاح',
                btnOkOnPress: () => Get.offAll(() => const HomeScreen()),
                btnOkColor: Colors.blue,
                btnOkText: 'خروج',
              ).show();
            }
          } else {
            if (mounted) {
              AwesomeDialog(
                context: context,
                animType: AnimType.TOPSLIDE,
                dialogType: DialogType.ERROR,
                // dialogColor: AppTheme.appTheme.primaryColor,
                title: 'خطأ',
                desc: 'تأكد من توفر الإنترنت',
                // btnOkOnPress: () => Get.offAll(() => HomeScreen()),
                // btnOkColor: Colors.blue,
                // btnOkText: 'خروج',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.appTheme.primaryColor,
        onPressed: () => addSuggestion(),
        child: const Icon(Icons.add),
      ),
      // appBar: AppBar(
      //   backgroundColor: AppTheme.appTheme.primaryColor,
      //   title: const Text('المقترحات '),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          SingleChildScrollView(
            reverse: true,
            child: Form(
              key: formstate,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: AppTheme.appTheme.primaryColor,
                            image: const DecorationImage(
                              image: AssetImage('assets/AlUyun.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustTextFormSign(
                        ourInput: TextInputType.multiline,
                        hint: 'تفاصيل الإقتراح',
                        maxl: 5,
                        myMaxlength: 100,
                        mycontroller: content,
                        valid: (val) {
                          return validInput(val!, 5, 200);
                        },
                        icon: Icons.details,
                      ),
                      const Text('قيمنا من قضلك',
                          style: TextStyle(fontSize: 26)),
                      const SizedBox(
                        height: 10,
                      ),
                      RatingBar.builder(
                        minRating: 1,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        updateOnDrag: true,
                        onRatingUpdate: (rating) => setState(
                          () {
                            this.rating = rating;
                          },
                        ),
                      )
                    ],
                  ),
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
}
