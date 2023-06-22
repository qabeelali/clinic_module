import 'dart:convert';
import 'dart:io';
import '../../helper/base64_to_file.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../controller/ptient_controller.dart';
import '../../helper//image_picker.dart';

class DxWidget extends StatefulWidget {
  const DxWidget({super.key});

  @override
  State<DxWidget> createState() => _DxWidgetState();
}

class _DxWidgetState extends State<DxWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 01, 0, 30),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dx',
                      style: TextStyle(fontFamily: 'neo', fontSize: 26),
                    ),
                   Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<PatientController>(context,
                                          listen: false)
                                      .removeDx();
                                },
                                child:
                                    SvgPicture.asset('assets/images/undo.svg'),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: TextField(
                    onChanged:
                        Provider.of<PatientController>(context, listen: false)
                            .setDxContent,
                    minLines: 5,
                    maxLines: 20,
                    decoration: InputDecoration(
                        hintText: 'Dx',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffF7227F))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffF7227F)))),
                    style: TextStyle(fontSize: 14, fontFamily: 'neo'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 40,
            child: Row(
              children: [
                GestureDetector(
                    onTap: () async {
                      XFile? image = await myImagePicker.pickImage();
                      if (image != null) {
                        // do what u want with image
                        Provider.of<PatientController>(context, listen: false)
                            .addDxImage(image);
                      }
                    },
                    child: CircleAvatar(
                      child: SvgPicture.asset('assets/images/image.svg'),
                      backgroundColor: Colors.white,
                    )),
                ...Provider.of<PatientController>(context)
                    .sheetToSend!
                    .dx!
                    .file_url
                    .mapIndexed((index, e) => GestureDetector(
                          onTap: () {
                            SaiHelper.showNativeDialog(
                                context, Image.memory(base64Decode(e)),
                                actions: ['delete'], index: index);
                          },
                          child: CircleAvatar(
                            backgroundImage: MemoryImage(base64Decode(e)),
                          ),
                        ))
              ],
            ))
      ],
    );
    ;
  }
}
