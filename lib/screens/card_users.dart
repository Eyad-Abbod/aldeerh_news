import 'package:flutter/material.dart';

class CardUser extends StatelessWidget {
  final String usid;
  final String name;
  final String usty;

  const CardUser({
    Key? key,
    required this.usid,
    required this.name,
    required this.usty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0),
        ),
        child: Container(
          padding:
              const EdgeInsets.only(top: 20, right: 25, left: 25, bottom: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        usty == '1'
                            ? const Icon(Icons.person, size: 26)
                            : const Icon(
                                Icons.verified,
                                size: 26,
                                color: Colors.blue,
                              ),
                        Flexible(
                          child: Text(
                            ' $name',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 22, color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.numbers),
                  Text(
                    ' $usid',
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
