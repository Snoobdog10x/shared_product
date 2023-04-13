import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:reel_t/shared_product/utils/format/format_utlity.dart';
import 'package:reel_t/shared_product/utils/text/shared_text_style.dart';

import '../../assets/icon/tik_tok_icons_icons.dart';
import 'circle_image_animation.dart';

class ActionsToolbar extends StatelessWidget {
  // Full dimensions of an action
  static const double ActionWidgetSize = 60.0;

// The size of the icon showen for Social Actions
  static const double ActionIconSize = 35.0;

// The size of the share social icon
  static const double ShareActionIconSize = 25.0;

// The size of the profile image in the follow Action
  static const double ProfileImageSize = 50.0;

// The size of the plus icon under the profile image in follow action
  static const double PlusIconSize = 20.0;

  final int numLikes;
  final int numComments;
  final String userPic;
  final Future<bool?> Function(bool)? onTapFollow;
  final Future<bool?> Function(bool)? onTapLike;
  final Future<bool?> Function(bool)? onTapComment;
  final Future<bool?> Function(bool)? onTapShare;
  final void Function()? onTapAvatar;
  final bool isLiked;
  bool isFollow;
  ActionsToolbar({
    this.numLikes = 0,
    this.numComments = 0,
    this.userPic = "",
    this.isLiked = false,
    this.isFollow = false,
    this.onTapFollow,
    this.onTapShare,
    this.onTapComment,
    this.onTapLike,
    this.onTapAvatar,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getFollowAction(pictureUrl: userPic),
          SizedBox(height: 16),
          buildAction(
            icon: TikTokIcons.heart,
            title: "Love",
            count: numLikes,
            onTap: onTapLike,
            isActive: isLiked!,
          ),
          SizedBox(height: 16),
          buildAction(
            icon: TikTokIcons.chat_bubble,
            title: "0",
            isChangeColor: false,
            count: numComments,
            onTap: onTapComment,
          ),
          SizedBox(height: 16),
          buildAction(
            icon: TikTokIcons.reply,
            title: 'Share',
            isChangeColor: false,
            isShowTitle: true,
            onTap: onTapShare,
          ),
          SizedBox(height: 16),
          CircleImageAnimation(
            child: _getMusicPlayerAction(userPic),
          ),
        ],
      ),
    );
  }

  Widget buildAction({
    required String title,
    int count = 0,
    required IconData icon,
    bool isActive = false,
    bool isChangeColor = true,
    bool isShowTitle = false,
    Future<bool?> Function(bool)? onTap,
  }) {
    return LikeButton(
      size: ActionIconSize,
      likeBuilder: (bool isLiked) {
        return Icon(
          icon,
          color: isLiked && isChangeColor
              ? Colors.red
              : Color.fromARGB(255, 232, 232, 232),
          size: ActionIconSize,
        );
      },
      likeCount: count,
      likeCountAnimationType: LikeCountAnimationType.none,
      countPostion: CountPostion.bottom,
      isLiked: isActive,
      onTap: onTap,
      countBuilder: (count, isLiked, text) {
        return Text(
          count == 0 || isShowTitle
              ? title
              : FormatUtility.formatNumber(count!),
          style: TextStyle(
              color: Colors.white,
              fontSize: SharedTextStyle.NORMAL_SIZE,
              fontWeight: SharedTextStyle.NORMAL_WEIGHT),
        );
      },
    );
  }

  Widget _getFollowAction({required String pictureUrl}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: 60.0,
      height: 60.0,
      child: Stack(
        children: [
          _getProfilePicture(pictureUrl),
          _getPlusIcon(),
        ],
      ),
    );
  }

  Widget _getPlusIcon() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Positioned(
          bottom: 0,
          left: ((ActionWidgetSize / 2) - (PlusIconSize / 2)),
          child: GestureDetector(
            onTap: () async {
              isFollow = !isFollow;
              setState(() {});
              await onTapFollow?.call(isFollow);
            },
            child: Container(
              width: PlusIconSize, // PlusIconSize = 20.0;
              height: PlusIconSize, // PlusIconSize = 20.0;
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 43, 84),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Icon(
                !isFollow ? Icons.add : Icons.check,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getProfilePicture(userPic) {
    return Positioned(
      left: (ActionWidgetSize / 2) - (ProfileImageSize / 2),
      child: GestureDetector(
        onTap: () {
          onTapAvatar?.call();
        },
        child: Container(
          padding:
              EdgeInsets.all(1.0), // Add 1.0 point padding to create border
          height: ProfileImageSize, // ProfileImageSize = 50.0;
          width: ProfileImageSize, // ProfileImageSize = 50.0;
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ProfileImageSize / 2)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10000.0),
            child: userPic.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: userPic,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  )
                : Icon(
                    Icons.people_alt,
                    size: ProfileImageSize,
                    color: Colors.grey[300],
                  ),
          ),
        ),
      ),
    );
  }

  LinearGradient get musicGradient => LinearGradient(colors: [
        Colors.grey[800]!,
        Colors.grey[900]!,
        Colors.grey[900]!,
        Colors.grey[800]!
      ], stops: [
        0.0,
        0.4,
        0.6,
        1.0
      ], begin: Alignment.bottomLeft, end: Alignment.topRight);

  Widget _getMusicPlayerAction(userPic) {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        width: ActionWidgetSize,
        height: ActionWidgetSize,
        child: Column(children: [
          Container(
              padding: EdgeInsets.all(11.0),
              height: ProfileImageSize,
              width: ProfileImageSize,
              decoration: BoxDecoration(
                  gradient: musicGradient,
                  borderRadius: BorderRadius.circular(ProfileImageSize / 2)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10000.0),
                  child: CachedNetworkImage(
                    imageUrl: userPic,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ))),
        ]));
  }
}
