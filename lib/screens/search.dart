import 'dart:convert';

import 'package:aldeerh_news/screens/shared_ui/card_ads.dart';
import 'package:aldeerh_news/utilities/news.dart';
import 'package:aldeerh_news/screens/shared_ui/card_news.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchUser extends SearchDelegate {
  // Future<List<News>> newNews =  fetchs();

  Future<List<News>> fetchs({String? query}) async {
    // final url = Uri.parse('http://s.aldeerahnews.com/public/api/news_and_ad');

    var response = await http.get(Uri.parse('$linkSearchNews?like=$query'));
    List<News> news = <News>[];
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data[1]);
      for (var item in data) {
        news.add(News.fromJson(item));
      }
    } else {}
    return news;
  }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   controller.dispose();
  //   super.dispose();
  // }

  Future refresh() async {
    // setState(() {
    //   isLoading = false;
    //   hasMore = true;
    //   page = 0;
    //   newNews.clear();
    // });
    // fetchs();
  }

  ///
  ///
  ///
  ///////////////////////////////////////////////////////
  // FetchUserList _userList = FetchUserList();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<News>>(
        // future: _userList.getuserList(query: query),
        future: fetchs(query: query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          List<News>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return data![index].nsTy.toString() == '1'
                    ? CardNews(
                        ontap: () {},
                        title: data[index].nsTitle.toString(),
                        nsTxt: data[index].nsTxt.toString(),
                        dateAndTime: data[index].newsDate.toString(),
                        date: data[index].nsDaSt.toString(),
                        usid: data[index].usid.toString(),
                        con: data[index].con.toString(),
                        nsImg: data[index].nsImg.toString(),
                        name: data[index].name.toString(),
                        nsid: data[index].nsid.toString(),
                        usty: data[index].usty.toString(),
                        usph: data[index].usph.toString(),
                        imagesCount: '99',
                        commentsCount: '99',
                        newsState: data[index].state!,
                      )
                    : CardAds(
                        ontap: () {},
                        title: data[index].nsTitle.toString(),
                        nsTxt: data[index].nsTxt.toString(),
                        dateAndTime: data[index].newsDate.toString(),
                        date: data[index].nsDaSt.toString(),
                        usid: data[index].usid.toString(),
                        con: data[index].con.toString(),
                        nsImg: data[index].nsImg.toString(),
                        name: data[index].name.toString(),
                        nsid: data[index].nsid.toString(),
                        usty: data[index].usty.toString(),
                        usph: data[index].usph.toString(),
                        imagesCount: '99',
                        commentsCount: '99',
                      );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text(
        'أبحث بعنوان الخبر',
        style: TextStyle(fontSize: 22, color: Colors.green),
      ),
    );
  }
}
