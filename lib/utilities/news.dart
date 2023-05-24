class News {
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
  String? name;
  String? usph;
  String? uspho;
  String? vSms;
  String? usty;

  News(
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
      this.name,
      this.usph,
      this.uspho,
      this.vSms,
      this.usty});

  News.fromJson(Map<String, dynamic> json) {
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
    name = json['name'];
    usph = json['usph'];
    uspho = json['uspho'];
    vSms = json['v_sms'];
    usty = json['usty'];
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
    data['name'] = name;
    data['usph'] = usph;
    data['uspho'] = uspho;
    data['v_sms'] = vSms;
    data['usty'] = usty;

    return data;
  }
}
