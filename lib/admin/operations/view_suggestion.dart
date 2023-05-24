import 'dart:convert';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class ViewSuggestion extends StatefulWidget {
  const ViewSuggestion({super.key});

  @override
  State<ViewSuggestion> createState() => _ViewSuggestionState();
}

class _ViewSuggestionState extends State<ViewSuggestion> {
  int? state;

  int _page = 1;

  bool _isFirstLoadRunning = false;

  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List suggestions = [];

  late String type;

  late String newsOrAd;

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      if (mounted) {
        setState(() {
          _isLoadMoreRunning = true;
        });
      }
      _page += 1;

      try {
        final res = await http.get(Uri.parse("$linkViewAllSugg?page=$_page"));

        final List fetchedSuggestion = json.decode(res.body);
        if (fetchedSuggestion.isNotEmpty) {
          if (mounted) {
            setState(() {
              suggestions.addAll(fetchedSuggestion);
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _hasNextPage = false;
            });
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Something went wrong");
        }
      }
      if (mounted) {
        setState(() {
          _isLoadMoreRunning = false;
        });
      }
    }
  }

  void _firstLoad() async {
    if (mounted) {
      setState(() {
        _isFirstLoadRunning = true;
      });
    }

    try {
      final res = await http.get(Uri.parse("$linkViewAllSugg?page=$_page"));
      if (mounted) {
        setState(() {
          suggestions = json.decode(res.body);
          _isFirstLoadRunning = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Something went wrong");
      }
      if (mounted) {
        await AwesomeDialog(
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

        newsRefresh();
      }
    }
  }

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  Future newsRefresh() async {
    setState(() {
      _page = 1;

      _isFirstLoadRunning = false;

      _hasNextPage = true;

      _isLoadMoreRunning = false;

      suggestions.clear();
    });
    _firstLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: const Text('التعليقات والمقترحات'),
      ),
      body: _isFirstLoadRunning
          ? const Center(child: CupertinoActivityIndicator())
          : suggestions.isEmpty
              ? Center(
                  child: Text(
                  'لاتوجد أي اقتراحات',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.appTheme.primaryColor,
                  ),
                ))
              : RefreshIndicator(
                  onRefresh: () => newsRefresh(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, right: 8.0, left: 8.0, bottom: 10),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: suggestions.length,
                              controller: _controller,
                              itemBuilder: (content, index) =>
                                  buildHeader(context, index)),
                        ),
                        if (_isLoadMoreRunning == true)
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 40),
                            child: Center(
                              child: CupertinoActivityIndicator(
                                color: AppTheme.appTheme.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget buildHeader(BuildContext context, int index) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          InkWell(
            onTap: () => onOpen(suggestions[index]['usph'].substring(1)),
            child: Center(
              child: Text(suggestions[index]['name'],
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
          ),
          const SizedBox(height: 10),
          suggestions[index]['tex'] == ''
              ? const SizedBox(height: 0)
              : Column(
                  children: [
                    const Divider(),
                    Text(suggestions[index]['tex'],
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center),
                    const Divider(),
                  ],
                ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('تاريخ الإقتراح: '),
              Text(suggestions[index]['com_tim']),
            ],
          ),
          RatingBarIndicator(
            rating: double.parse(suggestions[index]['rat']),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
