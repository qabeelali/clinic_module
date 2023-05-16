import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TabBar extends StatefulWidget {
  const TabBar({super.key, required this.children});
  final children;
  @override
  State<TabBar> createState() => _TabBarState();
}

class _TabBarState extends State<TabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: widget.children,
    );
  }
}
