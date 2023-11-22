import 'package:flutter/material.dart';
import 'package:shopping_store/constants/app_sizes.dart';
import 'package:shopping_store/views/widgets/shopping_network_image_widget.dart';

class NewArrivalProductsListItem extends StatelessWidget {
  final String productName;
  final String imageUrl;
  final String productPrice;

  const NewArrivalProductsListItem({
    Key? key,
    required this.productName,
    required this.imageUrl,
    required this.productPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 2.3,
      child: Card(
        child: SizedBox(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: size.width,
                  height: size.height / 14,
                  child: Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.apply(
                          fontWeightDelta: 2,
                        ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: size.height / 6,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        AppSizes.cardBorderRadius,
                      ),
                    ),
                    child: shoppingNetworkImageWidget(
                      imageUrl: imageUrl,
                      imageWidth: size.width / 2.3,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      productPrice,
                      style: Theme.of(context).textTheme.bodyMedium?.apply(
                            fontWeightDelta: 1,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
