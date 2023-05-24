class CongModel {
  String? id;
  String? congTitle;
  String? congText;

  CongModel({this.id, this.congTitle, this.congText});

  CongModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    congTitle = json['cong_title'];
    congText = json['cong_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cong_title'] = congTitle;
    data['cong_text'] = congText;

    return data;
  }
}
