import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CommentBox extends StatelessWidget {
  final Widget child;
  final dynamic formKey;
  final dynamic sendButtonMethod;
  final dynamic commentController;
  final String userImage;
  final String labelText;
  final String errorText;
  final Widget sendWidget;
  final Color backgroundColor;
  final Color textColor;

  const CommentBox({
    Key? key,
    required this.child,
    required this.formKey,
    required this.sendButtonMethod,
    required this.commentController,
    required this.userImage,
    required this.labelText,
    required this.errorText,
    required this.sendWidget,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        const Divider(height: 1),
        ListTile(
          tileColor: backgroundColor,
          leading: Container(
            height: 40.0,
            width: 40.0,
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: CircleAvatar(
                radius: 50,
                backgroundImage: FadeInImage.memoryNetwork(
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                  fadeInDuration: const Duration(milliseconds: 500),
                  fadeOutDuration: const Duration(milliseconds: 500),
                  placeholder: kTransparentImage,
                  image: userImage,
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
                ).image),
          ),
          title: Form(
            key: formKey,
            child: TextFormField(
              maxLines: 4,
              minLines: 1,
              cursorColor: textColor,
              style: TextStyle(color: textColor),
              controller: commentController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                labelText: labelText,
                focusColor: textColor,
                fillColor: textColor,
                labelStyle: TextStyle(color: textColor),
              ),
              validator: (value) => value!.isEmpty ? errorText : null,
            ),
          ),
          trailing: OutlinedButton(
            onPressed: sendButtonMethod,
            child: sendWidget,
          ),
        ),
      ],
    );
  }
}
