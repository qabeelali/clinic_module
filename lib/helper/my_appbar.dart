import 'package:flutter/services.dart';

import '../helper/image_picker.dart';
import '../helper/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';

class MyAppbar extends StatefulWidget {
  MyAppbar(
      {super.key,
      required this.title,
      this.isElevated,
      required this.opacity,
      required this.leading,
      this.textSize,
      this.actions, this.exit});
  final title;
  final isElevated;
  final opacity;
  final leading;
  final double? textSize;
  List<Widget>? actions;
  final bool? exit;

  @override
  State<MyAppbar> createState() => _MyAppbarState();
}

class _MyAppbarState extends State<MyAppbar> {
  final channel2 = MethodChannel('com.example.myChannel');
  @override
  Widget build(BuildContext context) {
    Widget backButton = IconButton(
      onPressed: () async {
        if(widget.exit==null){

        Navigator.of(context).pop();
        }else{
           channel2.invokeMethod('popFlutterApp');
        }
      },
      icon: Icon(Icons.arrow_back_ios_new),
      color: Colors.black,
    );
    return Material(
      borderRadius: widget.isElevated != 0
          ? BorderRadius.only(
              bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36))
          : BorderRadius.zero,
      elevation: widget.isElevated,
      child: ClipRRect(
        borderRadius: widget.isElevated != 0.0
            ? BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36))
            : BorderRadius.zero,
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color(0xffffffff),
          title: AnimatedOpacity(
            duration: Duration(milliseconds: 100),
            opacity: widget.opacity,
            child: Text(
              widget.title,
              style:  TextStyle(
                  fontSize: widget.textSize?? 30,
                  fontFamily: 'neo',
                  fontWeight: FontWeight.w500,
                  color: Color(0xff2A2D37)),
            ),
          ),
          centerTitle: true,
          elevation: widget.isElevated ?? 0,
          leading: backButton,
          actions: widget.actions,
        ),
      ),
    );
  }
}
