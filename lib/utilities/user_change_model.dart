import 'package:flutter/cupertino.dart';

class UserNewsChange with ChangeNotifier {
  String? usid;
  String? name;
  String? usty;
  String? newsCount;
  String? usph;

  UserNewsChange({this.usid, this.name, this.usty});

  UserNewsChange.fromJson(Map<String, dynamic> json) {
    usid = json['usid'];
    name = json['name'];
    usty = json['usty'];
    newsCount = json['newsCount'];
    usph = json['usph'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usid'] = usid;
    data['name'] = name;
    data['usty'] = usty;
    data['newsCount'] = newsCount;
    data['usph'] = usph;

    return data;
  }
}
