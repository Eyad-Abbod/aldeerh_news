import 'package:aldeerh_news/screens/shared_ui/news_details.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:aldeerh_news/utilities/valid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

class CardNews extends StatelessWidget {
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
  final String newsState;

  const CardNews({
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
    required this.newsState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InkWell(
        onTap: () {
          Get.to(
            () => NewsDetails(
              type: '1',
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
            ),
          );
        },
        child: Container(
          color: const Color.fromRGBO(245, 245, 245, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 4.0, left: 4.0),
                child: Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Stack(
                            children: [
                              const Center(
                                  child:
                                      CupertinoActivityIndicator(radius: 15)),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: FadeInImage.memoryNetwork(
                                  fit: BoxFit.cover,
                                  placeholderFit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                  fadeInDuration:
                                      const Duration(milliseconds: 500),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 500),
                                  placeholder: kTransparentImage,
                                  image: linkImageRoot + nsImg,
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                    "assets/AlUyun2.png",
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  placeholderErrorBuilder: (c, o, s) =>
                                      Image.asset(
                                    "assets/AlUyun2.png",
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  // repeat: ImageRepeat.repeat,
                                ),
                              ),
                            ],
                          ),

                          // child: FadeInImage.assetNetwork(
                          //   placeholder: "assets/AlUyun.png",
                          //   height: 100,
                          //   width: 100,
                          //   fit: BoxFit.cover,
                          //   image: linkImageRoot + nsImg,
                          //   fadeInDuration: const Duration(milliseconds: 5),
                          //   fadeOutDuration: const Duration(milliseconds: 5),
                          //   imageErrorBuilder: (c, o, s) => Image.asset(
                          //     "assets/AlUyun.png",
                          //     height: 100,
                          //     width: 100,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          // child: CachedNetworkImage(
                          //   imageUrl:
                          //       'http://www.aldeerahnews.com/ayone/apiByAhmed/uploads/' +
                          //           news[index].nsImg.toString(),
                          //   placeholder: (context, url) =>
                          //       Center(child: CupertinoActivityIndicator()),
                          //   errorWidget: (context, url, error) => Icon(Icons.error),
                          // ),

                          // child: ClipRRect(
                          //   borderRadius: BorderRadius.circular(8.0),
                          //   child: CachedNetworkImage(
                          //     imageUrl: linkImageRoot + nsImg,
                          //     fit: BoxFit.cover,
                          //     placeholder: (context, url) => const Center(
                          //       child: CupertinoActivityIndicator(
                          //         radius: 20,
                          //       ),
                          //     ),
                          //     errorWidget: (context, url, error) =>
                          //         Image.asset('assets/AlUyun2.png'),
                          //   ),
                          // ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            left: 8.0,
                            top: 8.0,
                            right: 6.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              newsState == '1'
                                  ? Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5C84E6)),
                                    )
                                  : newsState == '2'
                                      ? Text(
                                          title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        )
                                      : Text(
                                          title,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                              const SizedBox(height: 5),
                              Row(children: [
                                usty == '1'
                                    ? const Icon(Icons.person,
                                        size: 22, color: Colors.black)
                                    : const Icon(
                                        Icons.verified,
                                        size: 22,
                                        color: Colors.blue,
                                      ),
                                Expanded(
                                  child: Text(
                                    ' $name',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ]),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceAround,
                              //   children: [
                              //     Row(
                              //       children: [
                              //         const Icon(Icons.image, size: 22),
                              //         imagesCount == 'null'
                              //             ? const Text('0')
                              //             : Text(imagesCount)
                              //       ],
                              //     ),
                              //     Row(children: [
                              //       const Icon(Icons.timer_outlined, size: 22),
                              //       dateAndTime == 'null'
                              //           ? Text(
                              //               ' ${timeUntil(DateTime.parse(date))}')
                              //           : Text(
                              //               ' ${timeUntil(DateTime.parse(dateAndTime))}'),
                              //     ]),
                              //   ],
                              // ),
                              const SizedBox(height: 5),
                              // على خط واحد
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceAround,
                              //   children: [
                              //     Flexible(
                              //       child: Row(
                              //         children: [
                              //           const Icon(Icons.image, size: 18),
                              //           Text(' $imagesCount')
                              //         ],
                              //       ),
                              //     ),
                              //     Flexible(
                              //       child: Row(
                              //         children: [
                              //           const Icon(Icons.remove_red_eye,
                              //               size: 18),
                              //           con == 'null'
                              //               ? const Text(' 0')
                              //               : Text(
                              //                   ' ${con.toString().split(',').length.toString()}')
                              //         ],
                              //       ),
                              //     ),
                              //     Flexible(
                              //       child: Row(
                              //         children: [
                              //           const Icon(Icons.comment, size: 18),
                              //           Text(' $commentsCount')
                              //         ],
                              //       ),
                              //     ),
                              //     Flexible(
                              //       child: Row(children: [
                              //         const Icon(Icons.date_range, size: 22),
                              //         dateAndTime == 'null'
                              //             ? Text(
                              //                 ' ${timeUntil(DateTime.parse(date))}')
                              //             : Text(
                              //                 ' ${timeUntil(DateTime.parse(dateAndTime))}'),
                              //       ]),
                              //     ),
                              //   ],
                              // ),
                              //
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            const Icon(Icons.image,
                                                size: 18,
                                                color: Colors.black54),
                                            Text(' $imagesCount')
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(
                                          children: [
                                            const Icon(Icons.remove_red_eye,
                                                size: 18,
                                                color: Colors.black54),
                                            con == 'null'
                                                ? const Text(' 0')
                                                : Text(
                                                    ' ${con.toString().split(',').length.toString()}')
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            const Icon(Icons.comment,
                                                size: 18,
                                                color: Colors.black54),
                                            Text(' $commentsCount')
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(children: [
                                          const Icon(Icons.date_range,
                                              size: 22, color: Colors.black54),
                                          dateAndTime == 'null'
                                              ? Text(
                                                  ' ${timeUntil(DateTime.parse(date))}')
                                              : Text(
                                                  ' ${timeUntil(DateTime.parse(dateAndTime))}'),
                                        ]),
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              ///
                              /////
                              ///
                              ////
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceAround,
                              //   children: [
                              //     Column(
                              //       children: [
                              //         //  imagesCount == 'null'
                              //         //     ? Row(
                              //         //         children: const [
                              //         //           Icon(Icons.image, size: 18),
                              //         //           Icon(Icons.clear,
                              //         //               color: Colors.green,
                              //         //               size: 22),
                              //         //         ],
                              //         //       )
                              //         //     : Row(
                              //         //         children: const [
                              //         //           Icon(Icons.image, size: 18),
                              //         //           Icon(Icons.check,
                              //         //               color: Colors.green,
                              //         //               size: 22),
                              //         //         ],
                              //         //       ),
                              //         Row(
                              //           children: [
                              //             const Icon(Icons.image, size: 18),
                              //             Text(' $imagesCount')
                              //           ],
                              //         ),
                              //         Row(
                              //           children: [
                              //             const Icon(Icons.remove_red_eye),
                              //             con == 'null'
                              //                 ? const Text(' 0')
                              //                 : Text(
                              //                     con
                              //                         .toString()
                              //                         .split(',')
                              //                         .length
                              //                         .toString(),
                              //                   )
                              //           ],
                              //         ),
                              //       ],
                              //     ),
                              //     Column(
                              //       children: [
                              //         Row(
                              //           children: [
                              //             const Icon(Icons.comment, size: 18),
                              //             Text(' $commentsCount')
                              //           ],
                              //         ),
                              //         Row(children: [
                              //           const Icon(Icons.date_range, size: 22),
                              //           dateAndTime == 'null'
                              //               ? Text(
                              //                   ' ${timeUntil(DateTime.parse(date))}')
                              //               : Text(
                              //                   ' ${timeUntil(DateTime.parse(dateAndTime))}'),
                              //         ]),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
