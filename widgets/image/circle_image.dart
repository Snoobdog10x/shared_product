import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  const CircleImage(
    this.imageUrl, {
    super.key,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty)
      return Container(
        width: radius,
        height: radius,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.people,
          color: Colors.black,
          size: radius / 2,
        ),
      );

    return new Container(
      width: radius,
      height: radius,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
          fit: BoxFit.cover,
          image: new CachedNetworkImageProvider(imageUrl),
        ),
      ),
    );
  }
}
