// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

String timeUntil(DateTime date) {
  // return timeago.format(date, locale: 'ar', allowFromNow: false);
  return timeago.format(date, locale: 'en_short', allowFromNow: false);
}

Future<void> onOpen(String usph) async {
  var link = 'https://wa.me/966$usph';
  final bool nativeAppLaunchSucceeded = await launchUrl(
    Uri.parse(link),
    mode: LaunchMode.externalNonBrowserApplication,
  );
  if (!nativeAppLaunchSucceeded) {
    await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.inAppWebView,
    );
  }
}

validInput(String val, int min, int max) {
  if (min == max && min != 10) {
    return "لابد أن يتكون هذا الرقم من $min أرقام";
  }
  if (val.length > max && max != 0) {
    return "لا يمكن أن يكون هذا الحقل أكبر من $max";
  }
  if (val.isEmpty) {
    return "لا يمكن أن يكون هذا الحقل فارغ";
  }
  if (val.length < min) {
    return "لا يمكن أن يكون هذا الحقل أصغر من $min";
  }
}

validInputKSANumber(String val, int min, int max) {
  if (val.toString().substring(0, 2) != "05") {
    return "رقم غير صحيح لابد أن يبدأ الرقم 05";
  }
  if (min == max && min != 10) {
    return "لابد أن يتكون هذا الرقم من $min أرقام";
  }
  if (val.length > max && max != 0) {
    return "لا يمكن أن يكون هذا الحقل أكبر من $max";
  }
  if (val.isEmpty) {
    return "لا يمكن أن يكون هذا الحقل فارغ";
  }
  if (val.length < min) {
    return "لا يمكن أن يكون هذا الحقل أصغر من $min";
  }
}

validInputName(String val, int min, int max) {
  if (min == max && min != 10) {
    return "لابد أن يتكون هذا الرقم من $min أرقام";
  }
  if (val.length > max && max != 0) {
    return "لا يمكن أن يكون هذا الحقل أكبر من $max";
  }
  if (val.isEmpty) {
    return "لا يمكن أن يكون هذا الحقل فارغ";
  }
  if (val.length < min) {
    return "لا يمكن أن يكون هذا الحقل أصغر من $min";
  }

  if (val.contains('  ')) {
    return 'لا يمكن للغسم ان يحتوي على فراغات متتالية';
  }
}

validCheckInput(String val, int min, int max) {
  if (min == max && min != 4) {
    return "لابد أن يتكون هذا الرقم من $min أرقام";
  }
  if (val.length > max) {
    return "لا يمكن أن يكون هذا الحقل أكبر من $max";
  }
  if (val.isEmpty) {
    return "لا يمكن أن يكون هذا الحقل فارغ";
  }
  if (val.length < min) {
    return "لا يمكن أن يكون هذا الحقل أصغر من $min";
  }
}

validInputPhoneNumber(String val, int min, int max) {
  if (min == max && min != 10) {
    return "لابد أن يتكون هذا الرقم من $min أرقام";
  }
  if (val.length > max) {
    return "لا يمكن أن يكون هذا الحقل أكبر من $max";
  }
  if (val.isEmpty) {
    return "لا يمكن أن يكون هذا الحقل فارغ";
  }
  if (val.length < min) {
    return "لا يمكن أن يكون هذا الحقل أصغر من $min";
  }
}
// Future<bool> checkConnection() async {
//   try {
//     final result = await InternetAddress.lookup("google.com");
//     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       print('Connect');
//       return true;
//     } else {
//       print('Not Connect');
//       return false;
//     }
//   } on SocketException catch (_) {
//     print('Not Connect');
//     return false;
//   }
// }
