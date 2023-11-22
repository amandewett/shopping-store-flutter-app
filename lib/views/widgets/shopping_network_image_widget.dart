import 'package:flutter/material.dart';

class shoppingNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double imageWidth;
  final double imageHeight;
  final BoxFit boxFit;

  const shoppingNetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.imageWidth = 20,
    this.imageHeight = 20,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: imageWidth,
      height: imageHeight,
      fit: boxFit,
      loadingBuilder: (bContext, widget, loadingProgress) {
        if (loadingProgress == null) return widget;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
          ),
        );
      },
      errorBuilder: (bContext, object, stackTrace) => const Icon(Icons.broken_image),
    );
  }
}
