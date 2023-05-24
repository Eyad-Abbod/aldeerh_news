import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:flutter/material.dart';

class PolicyAndTerms extends StatelessWidget {
  const PolicyAndTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الشروط والأحكام'),
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: const [
                // GestureDetector(
                //   // onLongPress: () => checkIsAdmin(),
                //   child:

                // ),
                SizedBox(
                  height: 30,
                ),
                Text('علوم الديرة',
                    style:
                        TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                Text(
                    'حسب اللوائح والأنظمة لدى وزارة الداخلية ووزارة الإعلام فإنه يُمنع كل ما يلي:',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 15,
                ),

                Text(
                    '١- يُمنع استخدامُ لقب "شيخ" لغير مشايخ القبائل المعتمَدين لدى وزارة الداخلية ورجال الدين المحسوبين، وغيرها من الألقاب والمناصب لغير المعتمدين من الدولة.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 10,
                ),
                Text(
                    '٢- يُمنع نشرُ الأخبار لأشخاص ونسبهم إلى قبائل أو عائلاتٍ لا ينتسبون إليها أو بأسماءٍ مخالفةٍ لما في الهُوِيَّةِ الرَّسميَّةِ.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 10,
                ),
                Text(
                    '٣- يُمْنَعُ إرسالُ الأخبار التي فيها إساءةٌ أو تهكُّمٌ بأشخاص أو جماعات أو استخدام عبارات غير لائقة.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 10,
                ),
                Text(
                    '٤- يُمنع إرسالُ أخبار باسم الجهات الرسمية كالبلدية والنادي والمستشفيات والمدارس وغيرها إلا من الشخص المسؤول بصفةٍ رسميةٍ.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'كلُّ مَنْ يُخالف هذه الشروط سيكون عُرضةً للمساءلة القانونية أمام الجهات المختصة.',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                    textAlign: TextAlign.center),

                SizedBox(
                  height: 20,
                ),

                Text('تنبيه',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center),

                Text(
                    'يحق للإدارة منع نشر الأخبار التي تراها غير مناسبة أو لا تتوافق مع سياسة التطبيق.',
                    style: TextStyle(
                      fontSize: 18,
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
