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
      this.actions});
  final title;
  final isElevated;
  final opacity;
  final leading;
  List<Widget>? actions;

  @override
  State<MyAppbar> createState() => _MyAppbarState();
}

class _MyAppbarState extends State<MyAppbar> {
  @override
  Widget build(BuildContext context) {
    Widget backButton = IconButton(
      onPressed: () async {
        Navigator.of(context).pop();
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
              style: const TextStyle(
                  fontSize: 30,
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
