import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';

import 'image_diaglog_widget.dart';

class RefundAttachmentListWidget extends StatelessWidget {
  final RefundModel? refundModel;
  const RefundAttachmentListWidget({Key? key, this.refundModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingEye),
      child: SizedBox(height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: refundModel!.images!.length,
          itemBuilder: (BuildContext context, index){
            return refundModel!.images!.isNotEmpty?
            Padding(padding: const EdgeInsets.all(8.0), child: Stack(children: [
              InkWell( splashColor: Colors.transparent, onTap: () => showDialog(context: context, builder: (ctx)  =>
                  ImageDialogWidget(imageUrl: '${refundModel!.imagesFullUrl![index].path}')),

                child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  width: Dimensions.imageSize, height: Dimensions.imageSize,
                  decoration:  BoxDecoration(color: Colors.white,
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.125)),
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
                  child: ClipRRect(borderRadius: const BorderRadius.all(
                      Radius.circular(Dimensions.paddingSizeExtraSmall)),
                    child: CustomImageWidget(image: '${refundModel!.imagesFullUrl![index].path}',fit: BoxFit.cover,width: Dimensions.imageSize,height: Dimensions.imageSize),
                  ) ,),
              ),
            ],
            ),
            ):const SizedBox();

          },),
      ),
    );
  }
}
