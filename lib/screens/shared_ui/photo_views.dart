import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoViews extends StatefulWidget {
  const PhotoViews({Key? key}) : super(key: key);

  @override
  State<PhotoViews> createState() => _PhotoViewsState();
}

class _PhotoViewsState extends State<PhotoViews> {
  // late int index = widget.index;
  @override
  Widget build(BuildContext context) {
    // int currentIndex = 0;
    dynamic newsPhoto = Get.arguments;

    PageController pageController = PageController(initialPage: newsPhoto[1]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: Text(newsPhoto[2].toString()),
        centerTitle: true,
      ),
      body: PhotoViewGallery.builder(
        itemCount: newsPhoto[0].length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            // imageProvider: CachedNetworkImageProvider(
            //     linkImageRoot + news_photo[0][index]['img_url']),
            imageProvider: FadeInImage.memoryNetwork(
              fit: BoxFit.cover,
              height: 100,
              width: 100,
              fadeInDuration: const Duration(milliseconds: 500),
              fadeOutDuration: const Duration(milliseconds: 500),
              placeholder: kTransparentImage,
              image: linkImageRoot + newsPhoto[0][index]['img_url'],
              imageErrorBuilder: (c, o, s) => Image.asset(
                "assets/AlUyun2.png",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              placeholderErrorBuilder: (c, o, s) => Image.asset(
                "assets/AlUyun2.png",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              // repeat: ImageRepeat.repeat,
            ).image,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 4,

            // initialScale: PhotoViewComputedScale.contained * 0.5,
            // heroAttributes: PhotoViewHeroAttributes(tag: news_photo[0][index]),
          );
        },
        // loadingBuilder: (context, event) => Center(
        //   child: Container(
        //     width: 28.0,
        //     height: 28.0,
        //     child: CupertinoActivityIndicator(
        //       value: event == null
        //           ? 0
        //           : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
        //     ),
        //   ),
        // ),
        onPageChanged: (index) => setState(() => index = index),
        pageController: pageController,
      ),
    );
  }
}
