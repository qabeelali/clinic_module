import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TabBarItem extends StatelessWidget {
  const TabBarItem({super.key, required this.data, required this.isSelected, this.height,required this.onTap, required this.color});
  final data;
  final isSelected;
  final height;
  final onTap;
  final color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
      duration: Duration(milliseconds: 100),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
        color: isSelected? color:Colors.white
          ),
          child: Tab(
            child: Center(child: Text(data, style: TextStyle(color: isSelected? Colors.white: Colors.black , fontFamily: 'neo', fontSize: 17, fontWeight: FontWeight.w500),)),
          ),
        ),
      ),
    );
  }
}