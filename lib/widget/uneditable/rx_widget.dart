import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_nps/widget/uneditable/radiology_widget.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/sheet.dart';
import 'sub_widgets/rx_sub_widget.dart';

class RxU extends StatelessWidget {
  RxU({required this.drugs, super.key});
  List<Rx?> drugs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(0, 01, 0, 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
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
                  'Rx',
                  style: TextStyle(fontFamily: 'neo', fontSize: 26),
                ),
                Container(height: 10),
                ...drugs.map((e) {
                  return RxSU(
                    name: e!.drug_name,
                    count: e.count,
                    description: e.description ?? '',
                  );
                })
              ],
            ),
          ),
        ),
        Positioned(
          child: GestureDetector(
            onTap: () {
              BottomSheet(context, type: '1');
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                'assets/images/send.svg',
                width: 28,
              ),
            ),
          ),
          bottom: 0,
          left: 40,
        )
      ],
    );
  }
}

Future<void> BottomSheet(BuildContext context, {required String type}) async {
  return showModalBottomSheet<void>(
    constraints:
        BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.8),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return NewWidget(
        type: type,
      );
    },
  );
}
