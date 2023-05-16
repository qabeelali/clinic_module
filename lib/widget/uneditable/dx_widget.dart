import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';

import '../../view/image_screen.dart';

class DxU extends StatelessWidget {
  final String data;
  final List image;
  const DxU({super.key, required this.data, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 01, 0, 30),
          //   constraints: BoxConstraints(
          //   minHeight: MediaQuery.of(context).size.height * 0.21,
          // ),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 15,
                    spreadRadius: 0.2,
                    blurStyle: BlurStyle.outer,
                    color: Color(0xff000000).withOpacity(0.2)),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dx',
                  style: TextStyle(fontFamily: 'neo', fontSize: 26),
                ),
                Container(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    data,
                    style: TextStyle(fontSize: 14, fontFamily: 'neo'),
                  ),
                ),
              ],
            ),
          ),
        ),
        image.length == 0
            ? Container()
            : Positioned(
                bottom: 0,
                left: 40,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(_createRoute());
                    },
                    child: Hero(
                      tag: 'image1',
                      child: CircleAvatar(
                        child: SvgPicture.asset('assets/images/image.svg'),
                        backgroundColor: Colors.white,
                      ),
                    )))
      ],
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => ImageScreen(
        image: image,
        tag: 'image1',
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
