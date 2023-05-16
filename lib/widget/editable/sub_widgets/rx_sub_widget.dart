import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RxSU extends StatefulWidget {
  const RxSU({super.key, required this.editing});
  final bool editing;


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
      child: Column(
        children: [
          Row(
            children: [
              EleText(
                onTap: (){  setState(() {
            show = !show;
          });},
                title: true,
                editing: widget.editing,
                hint: 'Drug',
                data: 'Omperazol',
                flex: 3,
              ),
              EleText(
                title: false,
                editing: widget.editing,
                hint: 'Type',
                data: 'Vial',
                flex: 2,
              ),
              EleText(
                title:false,
                editing: widget.editing,
                hint: 'Vol',
                data: '40mg',
                flex: 2,
              ),
              EleText(
                title: false,
                editing: widget.editing,
                hint: 'Co.',
                data: '2',
                flex: 1,
              ),
            ],
          ),
          show
              ? EleLongText(
                  data:
                      'ie fjioewfj oiwe fjoiwe jfdoiwe jdoiwe jfioewj f\n widofwei dioew jdoiewj \ndiowej dioewjd i wed iwejdio wedjiowe djioewdj ioewd jioewd jio edjieh duiwehd iuewd h',
                )
              : Container()
        ],
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
  final String  hint;
  final bool editing;
  final bool title;
  final Function()? onTap;
  const EleText({
    super.key,
    required this.data,
    required this.flex, required this.hint, required this.editing, required this.title, this.onTap,
  });
  final String data;
  final int flex;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Stack(
        children: [
          Container(
            height: 30,
            margin: EdgeInsets.fromLTRB(10,10,10,20),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                child: Center(
                    child:editing? TextField(
                      maxLines: 1,
                  decoration: InputDecoration(
                    hintText:hint,
                    border: InputBorder.none,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ): title? Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(data),
                  GestureDetector(
                    onTap: (){},
                    child: SvgPicture.asset('assets/images/undo.svg',))
                  ],
                ):Text(data)) ,
              ),
              
            ),
          ),
        title?  Positioned(bottom: 0, left: 50, child: GestureDetector(onTap: onTap , child: CircleAvatar(child: SvgPicture.asset('assets/images/drug_bio.svg',width: 20,),backgroundColor: Colors.white, radius: 15,))):Container()
        ],
      ),
    );
  }
}
