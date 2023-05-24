class ImageModel {
  String? id;
  String? imgName;

  ImageModel({this.id, this.imgName});

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgName = json['img_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['img_name'] = imgName;

    return data;
  }
}
