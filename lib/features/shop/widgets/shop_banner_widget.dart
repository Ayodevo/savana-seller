import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';


class ShopBannerWidget extends StatelessWidget {
  final ShopController? resProvider;
  final bool fromBottom;
  final bool fromOffer;
  const ShopBannerWidget({Key? key, this.resProvider, this.fromBottom = false, this.fromOffer = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width/3,
      child: fromBottom? CustomImageWidget(image: '${resProvider!.shopModel?.bottomBannerFullUrl?.path}'):
      fromOffer?CustomImageWidget(image: '${resProvider!.shopModel?.offerBannerFullUrl?.path}'):
        CustomImageWidget(image: '${resProvider!.shopModel?.bannerFullUrl?.path}'),
    );
  }
}
