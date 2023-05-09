import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../models/video/video.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final bool isPlay;
  final bool isMute;
  final bool onTapPause;
  final void Function()? loadDoneCallBack;
  final bool isNetworkVideo;
  const VideoPlayerItem({
    super.key,
    required this.videoUrl,
    this.isPlay = false,
    this.isMute = false,
    this.onTapPause = true,
    this.loadDoneCallBack,
    this.isNetworkVideo = true,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    _initController(widget.isPlay, widget.isMute);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized()) {
      return buildLoadWidget();
    }
    return buildReadyVideo();
  }

  void notifyDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget buildReadyVideo() {
    return GestureDetector(
      onTap: () {
        if (!widget.onTapPause) return;
        _changeVideoState();
      },
      child: VisibilityDetector(
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction <= 0.7) {
            _stopVideo();
            return;
          }
          _playVideo();
        },
        key: ObjectKey(this),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            height: _controller!.value.size.height,
            width: _controller!.value.size.width,
            child: VideoPlayer(_controller!),
          ),
        ),
      ),
    );
  }

  Widget buildLoadWidget() {
    return Container(
      color: Colors.black,
      child: CupertinoActivityIndicator(
        radius: 20,
        color: Colors.white,
      ),
    );
  }

  void _initController(bool isPlay, bool isMute) async {
    if (_controller != null && _controller!.value.isInitialized) {
      return;
    }
    if (widget.isNetworkVideo)
      _controller = VideoPlayerController.network(widget.videoUrl);
    else
      _controller = VideoPlayerController.file(File(widget.videoUrl));

    _controller!.addListener(() {
      notifyDataChanged();
    });

    _controller!.setLooping(true);
    await _controller!.initialize();
    widget.loadDoneCallBack?.call();
    if (isMute) {
      _controller!.setVolume(0);
    }

    if (isPlay) {
      _controller!.play();
    } else {
      _controller!.pause();
    }

    notifyDataChanged();
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  bool _isInitialized() {
    if (_controller != null && _controller!.value.isInitialized) {
      return true;
    }
    return false;
  }

  void _changeVideoState() {
    if (_controller!.value.isPlaying) {
      _stopVideo();
      return;
    }
    _playVideo();
  }

  void _playVideo() {
    _controller?.play();
  }

  void _stopVideo() {
    _controller?.pause();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }
}
