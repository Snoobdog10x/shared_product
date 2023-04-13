import 'dart:io';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

import '../../../../generated/abstract_bloc.dart';
import 'image_gallery_picker_screen.dart';

class ImageGalleryPickerBloc
    extends AbstractBloc<ImageGalleryPickerScreenState> {
  List<AssetEntity> galleryImages = [];
  List<AssetEntity> selectedImages = [];
  int page = 0;
  int limit = 10;
  Future<void> initImage() async {
    galleryImages =
        await PhotoManager.getAssetListPaged(page: page, pageCount: limit);
    notifyDataChanged();
  }

  Future<List<File?>> getSelectedFiles() async {
    List<Future<File?>> getFile = [];
    selectedImages.forEach((element) {
      getFile.add(element.originFile);
    });

    return await Future.wait(getFile);
  }

  void onSelectImage(AssetEntity image) {
    if (selectedImages.contains(image)) {
      selectedImages.remove(image);
      notifyDataChanged();
      return;
    }
    selectedImages.add(image);
    notifyDataChanged();
  }
}
