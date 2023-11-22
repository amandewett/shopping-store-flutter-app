import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/services/api.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewWidget extends StatelessWidget {
  final String imageUrl;
  final List<String> arrMedia;
  final int currentIndex;

  const ImageViewWidget({
    Key? key,
    required this.imageUrl,
    required this.arrMedia,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: size.width,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),
            ),
            Expanded(
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                itemCount: arrMedia.length,
                gaplessPlayback: true,
                allowImplicitScrolling: true,
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                builder: (ctx, pIndex) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(
                      "${Api.fileBaseUrl}/${arrMedia[pIndex]}",
                    ),
                    initialScale: PhotoViewComputedScale.contained * 0.8,
                    heroAttributes: PhotoViewHeroAttributes(tag: arrMedia[pIndex]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
