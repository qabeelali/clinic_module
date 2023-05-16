import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class RxSU extends StatefulWidget {
  const RxSU({super.key, required this.name, required this.count, required this.description});
final String name;
final String count;
final String description;
  @override
  State<RxSU> createState() => _RxSUState();
}

class _RxSUState extends State<RxSU> {
  bool show = false;
  double opacity = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            show=!show;
         
          });
        },
        child: Column(
          children: [
            Row(
              children: [
                EleText(
                  data: widget.name,
                  flex: 3,
                ),
  
                EleText(
                  data: widget.count,
                  flex: 1,
                ),
              ],
            ),
            show
                ? 
                     EleLongText(
                      data:
                          widget.description,
                    )
                : Container()
          ],
        ),
      ),
    );
  }
}

class EleLongText extends StatelessWidget {
  final String data;
  const EleLongText({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(9),
      elevation: 3,
      color: Colors.white,
      child: Container(
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Text(data)),
    );
  }
}

class EleText extends StatelessWidget {
  const EleText({
    super.key,
    required this.data,
    required this.flex,
  });
  final String data;
  final int flex;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            child: Center(child: Text(data)),
          ),
        ),
      ),
    );
  }
}
