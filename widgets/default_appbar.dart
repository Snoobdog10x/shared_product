import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget {
  final String? appBarTitle;
  final Widget? appBarAction;
  final Function? onTapBackButton;
  final IconData? tapBackIcon;
  final TextStyle? titleStyle;
  const DefaultAppBar({
    super.key,
    this.appBarTitle,
    this.appBarAction,
    this.onTapBackButton,
    this.tapBackIcon = Icons.arrow_back_ios,
    this.titleStyle = const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: onTapBackButton == null
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        onTapBackButton?.call();
                      },
                      child: Icon(tapBackIcon),
                    ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              child: Text(appBarTitle ?? "", style: titleStyle),
            ),
          ),
          Expanded(
            flex: 2,
            child: appBarAction ?? Container(),
          ),
        ],
      ),
    );
  }
}
