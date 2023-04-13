import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../../../../generated/abstract_bloc.dart';
import '../../../../generated/abstract_state.dart';
import '../../../utils/text/shared_text_style.dart';
import 'image_gallery_picker_bloc.dart';
import '../../default_appbar.dart';

class ImageGalleryPickerScreen extends StatefulWidget {
  final bool isPickMultiple;
  final void Function(List<File?>)? onFileSelected;
  const ImageGalleryPickerScreen({
    super.key,
    this.isPickMultiple = true,
    this.onFileSelected,
  });

  @override
  State<ImageGalleryPickerScreen> createState() =>
      ImageGalleryPickerScreenState();
}

class ImageGalleryPickerScreenState
    extends AbstractState<ImageGalleryPickerScreen> {
  late ImageGalleryPickerBloc bloc;

  @override
  AbstractBloc initBloc() {
    return bloc;
  }

  @override
  BuildContext initContext() {
    return context;
  }

  @override
  void onCreate() {
    bloc = ImageGalleryPickerBloc();
    askPermission();
  }

  @override
  void onReady() {
    // TODO: implement onReady
  }
  Future<void> askPermission() async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      bloc.initImage();
    } else {
      // Limited(iOS) or Rejected, use `==` for more precise judgements.
      // You can call `PhotoManager.openSetting()` to open settings for further steps.
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => bloc,
      builder: (context, child) {
        return Consumer<ImageGalleryPickerBloc>(
          builder: (context, value, child) {
            var body = buildBody();
            return buildScreen(
              body: body,
              isSafe: false,
              appBar: buildAppBar(),
            );
          },
        );
      },
    );
  }

  Widget buildBody() {
    if (!widget.isPickMultiple) return buildGridImages();
    return Container(
      child: Stack(
        children: [
          buildGridImages(),
          buildSendButton(),
        ],
      ),
    );
  }

  Widget buildSendButton() {
    return GestureDetector(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: paddingBottom()),
          alignment: Alignment.center,
          width: screenWidth() * 0.8,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            "Send ${bloc.selectedImages.length}",
            style: TextStyle(
              fontSize: SharedTextStyle.SUB_TITLE_SIZE,
              fontWeight: SharedTextStyle.SUB_TITLE_WEIGHT,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridImages() {
    return Container(
      color: Color.fromARGB(255, 240, 240, 240),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
        ),
        itemCount: bloc.galleryImages.length,
        itemBuilder: (BuildContext context, int index) {
          var image = bloc.galleryImages[index];
          return GestureDetector(
            onTap: () async {
              if (!widget.isPickMultiple) {
                bloc.selectedImages.add(image);
                widget.onFileSelected?.call(await bloc.getSelectedFiles());
                popTopDisplay();
                return;
              }
              bloc.onSelectImage(image);
            },
            child: buildImageBlock(image),
          );
        },
      ),
    );
  }

  Widget buildImageBlock(AssetEntity image) {
    var isSelected = bloc.selectedImages.contains(image);
    var index = bloc.selectedImages.indexOf(image);
    return Stack(
      children: [
        Container(
          width: screenWidth(),
          height: screenHeight(),
          child: Image(
            fit: BoxFit.cover,
            image: AssetEntityImageProvider(
              image,
            ),
          ),
        ),
        if (isSelected && widget.isPickMultiple) ...[
          Container(
            alignment: Alignment.center,
            color: Colors.white.withOpacity(0.4),
            child: Container(
              alignment: Alignment.center,
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent,
              ),
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                  fontSize: SharedTextStyle.SUB_TITLE_SIZE,
                  fontWeight: SharedTextStyle.SUB_TITLE_WEIGHT,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ]
      ],
    );
  }

  Widget buildAppBar() {
    if (widget.isPickMultiple) {
      return DefaultAppBar(
        tapBackIcon: Icons.close,
        onTapBackButton: () {
          popTopDisplay();
        },
        appBarTitle: "Pick images",
        appBarAction: GestureDetector(
          onTap: () async {
            widget.onFileSelected?.call(await bloc.getSelectedFiles());
            popTopDisplay();
          },
          child: Text(
            "OK",
          ),
        ),
      );
    }

    return DefaultAppBar(
      appBarTitle: "Pick an image",
      appBarAction: GestureDetector(
        onTap: () {
          print("click");
          popTopDisplay();
        },
        child: Container(
          alignment: Alignment.centerRight,
          child: Container(
            height: 35,
            width: 35,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              Icons.close,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onDispose() {}
}
