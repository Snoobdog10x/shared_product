import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget {
  final String? appBarTitle;
  final Widget? appBarAction;
  final Function? onTapBackButton;
  const DefaultAppBar({
    super.key,
    this.appBarTitle,
    this.appBarAction,
    this.onTapBackButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 45,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: onTapBackButton == null
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        onTapBackButton?.call();
                      },
                      child: Icon(Icons.arrow_back_ios),
                    ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                appBarTitle ?? "",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
