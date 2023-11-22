import 'package:flutter/material.dart';
import 'package:shopping_store/constants/app_colors.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/views/widgets/shopping_network_image_widget.dart';

class FeaturedProductsListItem extends StatelessWidget {
  final String productName;
  final String imageUrl;
  final String productPrice;
  final bool isPackage;

  const FeaturedProductsListItem({
    Key? key,
    required this.productName,
    required this.imageUrl,
    required this.productPrice,
    this.isPackage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 2.3,
      child: Card(
        color: isPackage ? AppColors.lightBackgroundColor : AppColors.lightCardBackground,
        elevation: isPackage ? 0 : AppSizes.buttonElevation,
        child: SizedBox(
          width: size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: size.height / 5,
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.cardBorderRadius),
                    topRight: Radius.circular(AppSizes.cardBorderRadius),
                  ),
                  child: shoppingNetworkImageWidget(
                    imageUrl: imageUrl,
                    imageWidth: size.width / 2.3,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                  ),
                  child: Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.apply(
                          fontWeightDelta: 2,
                          fontSizeDelta: 1,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                    ),
                    child: Text(
                      productPrice,
                      style: Theme.of(context).textTheme.bodyMedium?.apply(
                            fontWeightDelta: 2,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
