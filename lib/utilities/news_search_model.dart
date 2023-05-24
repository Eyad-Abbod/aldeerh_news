class Serach {
  String? nsid;
  String? nsImg;
  String? nsTitle;
  String? nsTxt;
  String? nsDaSt;
  String? nsDaEn;
  String? usid;
  String? nsTy;
  String? nsSlid;
  String? nsPos;
  String? state;
  String? con;
  String? seen;
  String? newsDate;
  String? usty;
  String? name;
  String? usph;
  String? imagesCount;
  String? commentsCount;
  String? id;
  String? newsView;

  Serach(
      {this.nsid,
      this.nsImg,
      this.nsTitle,
      this.nsTxt,
      this.nsDaSt,
      this.nsDaEn,
      this.usid,
      this.nsTy,
      this.nsSlid,
      this.nsPos,
      this.state,
      this.con,
      this.seen,
      this.newsDate,
      this.usty,
      this.name,
      this.usph,
      this.commentsCount,
      this.imagesCount,
      this.id,
      this.newsView});

  Serach.fromJson(Map<String, dynamic> json) {
    nsid = json['nsid'];
    nsImg = json['ns_img'];
    nsTitle = json['ns_title'];
    nsTxt = json['ns_txt'];
    nsDaSt = json['ns_da_st'];
    nsDaEn = json['ns_da_en'];
    usid = json['usid'];
    nsTy = json['ns_ty'];
    nsSlid = json['ns_slid'];
    nsPos = json['ns_pos'];
    state = json['state'];
    con = json['con'];
    seen = json['seen'];
    newsDate = json['news_date'];
    usty = json['usty'];
    name = json['name'];
    usph = json['usph'];
    // imagesCount = json['imagesCount'].toString();

    imagesCount = json['imagesCount'];
    commentsCount = json['commentsCount'];
    id = json['id'];
    newsView = json['news_view'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nsid'] = nsid;
    data['ns_img'] = nsImg;
    data['ns_title'] = nsTitle;
    data['ns_txt'] = nsTxt;
    data['ns_da_st'] = nsDaSt;
    data['ns_da_en'] = nsDaEn;
    data['usid'] = usid;
    data['ns_ty'] = nsTy;
    data['ns_slid'] = nsSlid;
    data['ns_pos'] = nsPos;
    data['state'] = state;
    data['con'] = con;
    data['seen'] = seen;
    data['news_date'] = newsDate;
    data['usty'] = usty;
    data['name'] = name;
    data['usph'] = usph;
    data['imagesCount'] = imagesCount;
    data['commentsCount'] = commentsCount;
    data['id'] = id;
    data['news_view'] = newsView;
    return data;
  }
}
