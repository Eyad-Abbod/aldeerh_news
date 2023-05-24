import 'package:flutter/material.dart';

class CustTextFormWithEdit extends StatefulWidget {
  final TextInputType? ourInput;
  final String hint;
  final String fromDB;
  final int maxl;
  final int myMaxlength;
  final String? Function(String?) valid;
  final TextEditingController mycontroller;
  const CustTextFormWithEdit(
      {Key? key,
      required this.ourInput,
      required this.hint,
      required this.fromDB,
      required this.maxl,
      required this.myMaxlength,
      required this.mycontroller,
      required this.valid})
      : super(key: key);

  @override
  State<CustTextFormWithEdit> createState() => _CustTextFormWithEditState();
}

class _CustTextFormWithEditState extends State<CustTextFormWithEdit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: widget.myMaxlength == 0
          ? TextFormField(
              keyboardType: widget.ourInput,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              maxLines: widget.maxl,
              validator: widget.valid,
              controller: widget.mycontroller,
              decoration: InputDecoration(
                  labelText: widget.hint,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            )
          : TextFormField(
              keyboardType: widget.ourInput,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              maxLength: widget.myMaxlength,
              maxLines: widget.maxl,
              validator: widget.valid,
              controller: widget.mycontroller,
              decoration: InputDecoration(
                  labelText: widget.hint,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
    );
  }
}



// class CustTextFormWithEdit extends StatelessWidget {
//   final TextInputType? ourInput;
//   final String hint;
//   final String fromDB;
//   final int maxl;
//   final int myMaxlength;
//   final String? Function(String?) valid;
//   final TextEditingController mycontroller;
//   const CustTextFormWithEdit(
//       {Key? key,
//       required this.ourInput,
//       required this.hint,
//       required this.fromDB,
//       required this.maxl,
//       required this.myMaxlength,
//       required this.mycontroller,
//       required this.valid})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       child: myMaxlength == 0
//           ? TextFormField(
//               keyboardType: ourInput,
//               textAlignVertical: TextAlignVertical.center,
//               textAlign: TextAlign.center,
//               maxLines: maxl,
//               validator: valid,
//               controller: mycontroller,
//               decoration: InputDecoration(
//                   labelText: hint,
//                   contentPadding:
//                       const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             )
//           : TextFormField(
//               keyboardType: ourInput,
//               textAlignVertical: TextAlignVertical.center,
//               textAlign: TextAlign.center,
//               maxLength: myMaxlength,
//               maxLines: maxl,
//               validator: valid,
//               controller: mycontroller,
//               decoration: InputDecoration(
//                   labelText: hint,
//                   contentPadding:
//                       const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//     );
//   }
// }