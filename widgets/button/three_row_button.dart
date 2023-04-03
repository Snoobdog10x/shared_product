import 'package:flutter/material.dart';

class ThreeRowButton extends StatelessWidget {
  final Widget? title;
  final Widget? prefixIcon;
  final Widget? postfixIcon;
  final double width;
  final double height;
  final Color color;
  final Function? onTap;
  const ThreeRowButton({
    super.key,
    this.title,
    this.prefixIcon,
    this.postfixIcon,
    this.onTap,
    this.width = double.infinity,
    this.height = 50,
    this.color = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
                child: Wrap(children: [prefixIcon ?? Container()]), flex: 2),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: title ?? Container(),
              ),
              flex: 6,
            ),
            Expanded(child: postfixIcon ?? Container(), flex: 2),
          ],
        ),
      ),
    );
  }
}
