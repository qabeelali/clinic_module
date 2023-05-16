import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class schaduleWidget extends StatelessWidget {
   schaduleWidget({super.key, required this.id, required this.name, required this.image});
final id;
final name;
final image;
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Container(
      height: _height * 0.107,
      width: _width * 0.77866,
      decoration: BoxDecoration(
          color: Color(0xff0199EC).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: _height * 0.035,
              backgroundImage: NetworkImage(
                  image),
            ),
            SizedBox(width: 12,),
            Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: Color(0xff0199EC),
                      fontFamily: 'neo',
                      fontWeight: FontWeight.w500,
                      fontSize: 22),
                ),
                   Text(
                  'id:$id',
                  style: TextStyle(
                      color: Color(0xff0199EC),
                      fontFamily: 'neo',
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
