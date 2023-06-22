import '../view/schadule.dart';
import 'package:flutter/material.dart';

import '../model/schadule.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final Widget? leading;
  final List<Widget> children;
  final OrderContainer order;
  
  CustomExpansionTile({
    required this.title,
    this.leading,
    required this.order,
    required this.children,
  });

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _iconRotationAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpandedState() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SchaduleWidget(order:widget.order.orders[0]! , times: [widget.order.startTime, widget.order.endTime],),
            SizeTransition(
              sizeFactor: _animationController,
              axisAlignment: -1.0,
              child: Column(
                children: widget.children.getRange(1, widget.children.length).toList(),
              ),
            ),
            Divider(),
          ],
        ),
        Positioned(
          bottom: 10,
          left: (MediaQuery.of(context).size.width * 0.5) - 15,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: _toggleExpandedState,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Center(
                      child: Icon(
                   _isExpanded? Icons.remove: Icons.add,
                    color: Color(0xff0199EC),
                  ))),
            ),
          ),
        )
      ],
    );
  }
}
