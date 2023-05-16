import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';

class AddTabChild extends StatelessWidget {
  const AddTabChild(
      {super.key,
      required this.height,
      required this.name,
      required this.image});
  final height;
  final name;
  final image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/add-patient');
        },
        child: Container(
          height: height * 0.144,
          width: height * 0.12,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xffF7227F), width: 1)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: new SvgPicture.asset(image),
                width:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? MediaQuery.of(context).size.width * 0.06
                        : height * 0.06,
                height:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? MediaQuery.of(context).size.width * 0.06
                        : height * 0.06,
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'neo'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
