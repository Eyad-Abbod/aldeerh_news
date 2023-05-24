import 'package:aldeerh_news/utilities/app_theme.dart';
import 'package:aldeerh_news/utilities/link_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoNewsImg extends StatefulWidget {
  const PhotoNewsImg({Key? key}) : super(key: key);

  @override
  State<PhotoNewsImg> createState() => _PhotoNewsImgState();
}

class _PhotoNewsImgState extends State<PhotoNewsImg> {
  // late int index = widget.index;
  @override
  Widget build(BuildContext context) {
    // int currentIndex = 0;
    dynamic newsPhoto = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appTheme.primaryColor,
        title: Text(newsPhoto[2].toString()),
        centerTitle: true,
      ),
      body: PhotoViewGallery.builder(
        itemCount: 1,
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
              image: linkImageRoot + newsPhoto[0],
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
          );
        },
      ),
    );
  }
}
