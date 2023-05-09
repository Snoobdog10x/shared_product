import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:convert';

class VideoEditor {
  Future<Uint8List> convertVideoToThumbnail(String filePath,
      {int maxWith = 128, int quality = 25}) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: filePath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 80,
    );
    return uint8list!;
  }

  Future<String> encodeThumbnail(String filePath) async {
    var videoThumbnail = await convertVideoToThumbnail(filePath);
    String base64Image = base64Encode(videoThumbnail);
    return base64Image;
  }

  Future<XFile> compressFile(XFile video, {bool isWeb = false}) async {
    if (isWeb) return video;

    final info = await VideoCompress.compressVideo(
      video.path,
      quality: VideoQuality.Res1280x720Quality,
      deleteOrigin: false,
      includeAudio: true,
    );
    if (info == null) {
      return video;
    }
    return XFile(info.path!);
  }
}
