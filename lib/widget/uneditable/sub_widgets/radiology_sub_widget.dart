import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../view/image_screen.dart';

class RadiologySubWidget extends StatelessWidget {
  RadiologySubWidget({
    super.key,
    required this.name,
    required this.des,
    required this.image,
  });
  final String name;
  final String des;
  final List image;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.92,
      height: MediaQuery.of(context).size.height * 0.139,
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.405,
                      child: Material(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(child: Text(name)),
                        ),
                        borderRadius: BorderRadius.circular(9),
                        elevation: 3,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width * 0.405,
                        child: Material(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(des),
                          ),
                          borderRadius: BorderRadius.circular(9),
                          elevation: 3,
                        ),
                      ))
                ],
              )),
          Expanded(
              flex: 1,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Hero(
                    tag: 'image2',
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(_createRoute(image));
                        },
                        child: Image.network(
                          image.first['file'],
                          fit: BoxFit.cover,
                        )),
                  )))
        ],
      ),
    );
  }

  Route _createRoute(images) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => ImageScreen(
        image: images,
        tag: 'image2',
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
