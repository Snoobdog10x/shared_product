import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../../screens/user/profile/profile_screen.dart';

class VideoDescription extends StatelessWidget {
  final String username;
  final String videtoTitle;
  final String songInfo;
  final Function? onTapUserName;

  VideoDescription({
    this.username = "",
    this.videtoTitle = "",
    this.songInfo = "",
    this.onTapUserName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.transparent,
      padding: EdgeInsets.only(left: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              onTapUserName?.call();
            },
            child: Text(
              username,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          ReadMoreText(
            videtoTitle + " ",
            trimLines: 2,
            trimLength: 30,
            moreStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            lessStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Row(children: [
            Icon(
              Icons.music_note,
              size: 15.0,
              color: Colors.white,
            ),
            Text(
              songInfo,
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            )
          ]),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
