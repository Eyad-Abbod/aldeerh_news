import 'package:aldeerh_news/screens/shared_ui/news_details.dart';
import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

class CardAds extends StatelessWidget {
  final void Function() ontap;
  final String title;
  final String nsTxt;
  final String date;
  final String dateAndTime;
  final String usid;
  final String con;
  final String nsImg;
  final String name;
  final String nsid;
  final String usty;
  final String usph;
  final String imagesCount;
  final String commentsCount;

  const CardAds({
    Key? key,
    required this.ontap,
    required this.title,
    required this.nsTxt,
    required this.date,
    required this.dateAndTime,
    required this.usid,
    required this.con,
    required this.nsImg,
    required this.name,
    required this.nsid,
    required this.usty,
    required this.usph,
    required this.imagesCount,
    required this.commentsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => NewsDetails(
              type: '2',
              title: title,
              content: nsTxt,
              date: date,
              name: name,
              nsImg: nsImg,
              nsid: nsid,
              usty: usty,
              usph: usph,
              viewsCount: con.toString().split(',').length.toString(),
              commentsCount: commentsCount,
            ));
      },
      child: Container(
        color: const Color.fromRGBO(245, 245, 245, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 4.0, left: 4.0),
              child: ClipRect(
                child: Banner(
                  message: 'إعلان',
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  location: BannerLocation.topEnd,
                  color: AppTheme.appTheme.primaryColor,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(
                                children: [
                                  const Center(
                                      child: CupertinoActivityIndicator(
                                    color: Colors.white,
                                  )),
                                  Center(
                                    child: FadeInImage.memoryNetwork(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                      fadeInDuration:
                                          const Duration(milliseconds: 500),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 500),
                                      placeholder: kTransparentImage,
                                      image: linkImageRoot + nsImg,
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(
                                        "assets/AlUyun2.png",
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      placeholderErrorBuilder: (c, o, s) =>
                                          Image.asset(
                                        "assets/AlUyun2.png",
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                      repeat: ImageRepeat.repeat,
                                    ),
                                  ),
                                ],
                              )
                              // child: CachedNetworkImage(
                              //   imageUrl: linkImageRoot + nsImg,
                              //   fit: BoxFit.fill,
                              //   placeholder: (context, url) => const Center(
                              //     child: CupertinoActivityIndicator(),
                              //   ),
                              //   errorWidget: (context, url, error) =>
                              //       Image.asset('assets/AlUyun.png'),
                              // ),
                              ),
                        ),
                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: Center(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // SizedBox(width: 8),
                                    usty == '1'
                                        ? const Icon(Icons.person, size: 22)
                                        : const Icon(
                                            Icons.verified,
                                            size: 22,
                                            color: Colors.blue,
                                          ),
                                    Flexible(
                                      child: Text(
                                        ' $name',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Flexible(
                              //   child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         const Icon(Icons.date_range, size: 22),
                              //         dateAndTime == 'null'
                              //             ? Text(
                              //                 ' ${timeUntil(DateTime.parse(date))}')
                              //             : Text(
                              //                 ' ${timeUntil(DateTime.parse(dateAndTime))}'),
                              //       ]),
                              // ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.image, size: 18),
                                Text(' $imagesCount')
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.remove_red_eye, size: 18),
                                con == 'null'
                                    ? const Text(' 0')
                                    : Text(
                                        ' ${con.toString().split(',').length.toString()}')
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.comment, size: 18),
                                Text(' $commentsCount')
                              ],
                            ),
                            Row(children: [
                              const Icon(Icons.date_range, size: 22),
                              dateAndTime == 'null'
                                  ? Text(' ${timeUntil(DateTime.parse(date))}')
                                  : Text(
                                      ' ${timeUntil(DateTime.parse(dateAndTime))}'),
                            ]),
                          ],
                        ),
                        const SizedBox(height: 11),
                        // Image.asset('assets/AlUyun.png'),
                        // Image.asset('assets/AlUyun.png'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
