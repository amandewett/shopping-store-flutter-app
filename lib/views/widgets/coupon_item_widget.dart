import 'package:flutter/material.dart';
import 'package:shopping_store/constants/app_assets.dart';

class CouponItemWidget extends StatelessWidget {
  final Size size;
  final double couponPercent;
  final String couponName;
  final String couponDescription;

  const CouponItemWidget({
    Key? key,
    required this.size,
    required this.couponPercent,
    required this.couponName,
    required this.couponDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /* Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              AppAssets.appApplyNowButton,
              width: size.width / 8,
            ),
          ),
        ), */
        Positioned(
          top: -size.height / 120,
          bottom: 0,
          left: -size.width / 45,
          right: 0,
          child: Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              AppAssets.appCouponBg,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: size.width / 15,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$couponPercent%",
                style: Theme.of(context).textTheme.displaySmall?.apply(
                      fontWeightDelta: 1,
                      fontSizeDelta: -10,
                    ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    bottom: 10,
                    right: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        couponName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.apply(
                              fontWeightDelta: 2,
                              fontSizeDelta: -3,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Text(
                          couponDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.apply(
                                fontWeightDelta: 1,
                                fontSizeDelta: -3,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
