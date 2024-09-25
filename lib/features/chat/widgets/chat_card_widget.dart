import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/chat/domain/models/chat_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/chat/screens/chat_screen.dart';

class ChatCardWidget extends StatelessWidget {
  final Chat? chat;
  const ChatCardWidget({Key? key, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int? id = Provider.of<ChatController>(context, listen: false).userTypeIndex == 0 ?
    chat!.customer?.id?? -1 : chat!.deliveryManId;

    String? image = Provider.of<ChatController>(context, listen: false).userTypeIndex == 0 ?
    chat!.customer != null? chat?.customer?.imageFullUrl?.path: '' : chat!.deliveryMan?.imageFullUrl?.path;

    String name = Provider.of<ChatController>(context, listen: false).userTypeIndex == 0 ?
    chat!.customer != null?
    '${chat!.customer?.fName} ${chat!.customer?.lName}' :'Deleted' :
    '${chat!.deliveryMan?.fName??'Deliveryman'} ${chat!.deliveryMan?.lName??'Deleted'}';


    return Padding(
      padding:  const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: (){
        if(name.trim() == "Deleted"){
          showCustomSnackBarWidget('Customer was deleted', context,  sanckBarType: SnackBarType.success);
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ChatScreen(userId: id, name: name);
          }));
        }},
        child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),

          child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,children: [

            ClipRRect(borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                errorWidget: (ctx, url ,err )=>Image.asset(Images.placeholderImage,
                  height: Dimensions.chatImage, width: Dimensions.chatImage, fit: BoxFit.cover,),
                placeholder: (ctx, url )=>Image.asset(Images.placeholderImage),
                imageUrl: '$image',
                fit: BoxFit.cover, height: Dimensions.chatImage, width: Dimensions.chatImage,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall,),

            Expanded(
              child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: titilliumSemiBold.copyWith(color: ColorResources.titleColor(context))),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                Text( (chat!.message == null && chat!.attachment != null) ? getTranslated('sent_attachment', context)! : chat!.message??'',
                  maxLines: 2,overflow: TextOverflow.ellipsis,
                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.getTextColor(context).withOpacity(.8)),
                ),
                Text(DateConverter.customTime(DateTime.parse(chat!.createdAt!)),
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
              ],),
            )
          ],),),
      ),
    );
  }
}
