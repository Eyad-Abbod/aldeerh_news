import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' show basename;

class Curd {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        // print("Error ${response.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        // print("Error ${response.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequests(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {}
    } catch (e) {
      return 'Error';
    }
  }

  postRequestWithFile(String url, Map data, File file) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      var length = await file.length();
      var stream = http.ByteStream(file.openRead());

      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);
      data.forEach((key, value) {
        request.fields[key] = value;
      });
      var myrequest = await request.send();

      var response = await http.Response.fromStream(myrequest);
      if (myrequest.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // print("Error ${myrequest.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequestWithFiles(
      String url, Map data, File? file, List<File> images) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      if (file != null) {
        var length = await file.length();
        var stream = http.ByteStream(file.openRead());

        var multipartFile = http.MultipartFile('file', stream, length,
            filename: basename(file.path));
        request.files.add(multipartFile);
      }

      data.forEach((key, value) {
        request.fields[key] = value;
      });

      if (images.isNotEmpty) {
        // print('object');
        List<http.MultipartFile> newList = <http.MultipartFile>[];
        for (int i = 0; i < images.length; i++) {
          var length = await images[i].length();
          var stream = http.ByteStream(images[i].openRead());
          var multipartFile = http.MultipartFile("po[]", stream, length,
              filename: basename(images[i].path));
          newList.add(multipartFile);
        }
        request.files.addAll(newList);
      } else {
        // print('No More Images');
      }

      var myrequest = await request.send();

      var response = await http.Response.fromStream(myrequest);
      if (myrequest.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // print("Error ${myrequest.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequestWithFilesWithOutFile(
      String url, Map data, List<File> images) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      data.forEach((key, value) {
        request.fields[key] = value;
      });

      if (images.isNotEmpty) {
        List<http.MultipartFile> newList = <http.MultipartFile>[];
        for (int i = 0; i < images.length; i++) {
          var length = await images[i].length();
          var stream = http.ByteStream(images[i].openRead());
          var multipartFile = http.MultipartFile("po[]", stream, length,
              filename: basename(images[i].path));
          newList.add(multipartFile);
        }
        request.files.addAll(newList);
      } else {
        // print('No More Images');
      }

      var myrequest = await request.send();

      var response = await http.Response.fromStream(myrequest);
      if (myrequest.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // print("Error ${myrequest.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequestNotifications(String title, String name, String nsid) async {
    try {
      var response = await http.post(
          Uri.parse('https://onesignal.com/api/v1/notifications'),
          headers: {
            'Content-Type': 'application/json',
            'authorization':
                'Basic NTIxNTczMTYtMWVkZC00NTc3LWI2NGUtMzJhMzgxMzNmMDFh'
          },
          body: json.encode({
            "app_id": "ca44ff11-13b6-4dfc-ab37-f6937cd47b78",
            "included_segments": ["Subscribed Users"],
            "data": {"news_id": nsid},
            "android_channel_id": "175fe466-a67c-4ef1-8b15-fefa5d194bbf",
            "ios_sound": "deerh.wav",
            "headings": {"ar": title, "en": title},
            "contents": {"ar": name, "en": name}
          }));

      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        // print("Error ${response.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequestNotificationsForAdmin(
      String title, String newsType, String nsidIfExist) async {
    try {
      var response = await http.post(
          Uri.parse('https://onesignal.com/api/v1/notifications'),
          headers: {
            'Content-Type': 'application/json',
            'authorization':
                // 'Basic NTIxNTczMTYtMWVkZC00NTc3LWI2NGUtMzJhMzgxMzNmMDFh' // 1
                'Basic ZWIwMDY3NzEtZjU4MC00YmFiLWEzYjEtNjgxZjBmYjA5YjI3' // 2
          },
          body: json.encode({
            // "app_id": "ca44ff11-13b6-4dfc-ab37-f6937cd47b78", // 1
            "app_id": "f8a2e3d8-b154-481e-b839-30705c8cab30", // 2
            "included_segments": ["Subscribed Users"],
            "data": {"news_id": '1', "type": '1'},
            // "android_channel_id": "175fe466-a67c-4ef1-8b15-fefa5d194bbf", // 1
            "android_channel_id": "bf0a2198-1df8-4045-af12-8cab72e38d54", // 2
            "ios_sound": "deerh.wav",
            "headings": {"ar": newsType, "en": newsType},
            "contents": {"ar": title, "en": title}
          }));

      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        // print("Error ${response.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequestSMS(String phone, String code) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.oursms.com/api-a/msgs'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "username": "Aldeerh",
          "token": "YhY-1oVdraXswF5nMG2-",
          "src": "Deerah-Uyun",
          "dests": "966$phone",
          "body": "رمز التحقق لتسجيل دخول تطبيق علوم الديرة هو:$code",
        },
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
      }
    } catch (e) {
      return 'Error';
    }
  }
}
