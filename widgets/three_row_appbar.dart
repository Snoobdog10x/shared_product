import 'package:flutter/material.dart';

class ThreeRowAppBar extends StatelessWidget {
  final Widget? firstWidget;
  final Widget? secondWidget;
  final Widget? lastWidget;
  const ThreeRowAppBar({
    super.key,
    this.firstWidget,
    this.secondWidget,
    this.lastWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: [
          firstWidget ?? Container(),
          Expanded(
            flex: 5,
            child: secondWidget ?? Container(),
          ),
          Expanded(
            flex: 3,
            child: lastWidget ?? Container(),
          ),
        ],
      ),
    );
  }
}
