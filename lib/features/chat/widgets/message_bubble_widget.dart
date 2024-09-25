import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/chat/domain/models/message_model.dart';
import 'package:sixvalley_vendor_app/features/chat/widgets/chatting_multi_image_slider.dart';
import 'package:sixvalley_vendor_app/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/image_diaglog_widget.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Message message;
  final Message? previous;
  final Message? next;
  const MessageBubbleWidget({Key? key, required this.message, this.previous, this.next}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMe = message.sentBySeller!;

    String? image = Provider.of<ChatController>(context, listen: false).userTypeIndex == 0 ?
    message.customer != null? message.customer?.imageFullUrl?.path :'' : message.deliveryMan?.imageFullUrl?.path;

    return Consumer<ChatController>(
        builder: (context, chatProvider,child) {

          List<Attachment> images = [];
          List<Attachment> files = [];

          String chatTime  = chatProvider.getChatTime(message.createdAt!, message.createdAt);
          bool isSameUserWithPreviousMessage = chatProvider.isSameUserWithPreviousMessage(previous, message);
          bool isSameUserWithNextMessage = chatProvider.isSameUserWithNextMessage(message, next);
          bool isLTR = Provider.of<LocalizationController>(context, listen: false).isLtr;
          String previousMessageHasChatTime = previous != null ? chatProvider.getChatTime(previous!.createdAt!, message.createdAt) : "";

          if(message.attachment != null) {
            for(Attachment attachment in message.attachment!){
              if(attachment.type == 'image'){
                images.add(attachment);
              }else if (attachment.type == 'file') {
                files.add(attachment);
              }
            }
          }

        return Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end:CrossAxisAlignment.start, children: [
            Row( crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                ((!isMe && !isSameUserWithPreviousMessage) ||  (!isMe && isSameUserWithPreviousMessage)) &&
                    chatProvider.getChatTimeWithPrevious(message, previous).isNotEmpty ?
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: InkWell(child: ClipOval(child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),
                      color: Theme.of(context).highlightColor,
                      border: Border.all(color: Theme.of(context).primaryColor)),
                    child: CustomImageWidget(image: '$image', width: Dimensions.paddingSizeExtraLarge + 5, height: Dimensions.paddingSizeExtraLarge + 5)
                  ))),
                ) : !isMe ? const SizedBox(width: Dimensions.paddingSizeExtraLarge + 5) : const SizedBox(),

                Flexible(child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
              if(message.message != null && message.message!.isNotEmpty)
                InkWell(
                  onTap: (){
                    chatProvider.toggleOnClickMessage(onMessageTimeShowID :
                    message.id.toString());
                  },
                  child: Container(
                    margin: isMe ?  const EdgeInsets.fromLTRB(70, 2, 10, 2) : const EdgeInsets.fromLTRB(10, 2, 10, 2),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: isMe && (isSameUserWithNextMessage || isSameUserWithPreviousMessage) ? BorderRadius.only(
                        topRight: Radius.circular(isSameUserWithNextMessage && isLTR && chatTime =="" ? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                        bottomRight: Radius.circular(isSameUserWithPreviousMessage && isLTR && previousMessageHasChatTime =="" ? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                        topLeft: Radius.circular(isSameUserWithNextMessage && !isLTR && chatTime ==""? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                        bottomLeft: Radius.circular(isSameUserWithPreviousMessage && !isLTR && previousMessageHasChatTime ==""? Dimensions.radiusSmall :Dimensions.radiusExtraLarge + 5),

                      ) : !isMe && (isSameUserWithNextMessage || isSameUserWithPreviousMessage) ? BorderRadius.only(
                        topLeft: Radius.circular(isSameUserWithNextMessage && isLTR && chatTime ==""? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                        bottomLeft: Radius.circular( isSameUserWithPreviousMessage && isLTR && previousMessageHasChatTime =="" ? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                        topRight: Radius.circular(isSameUserWithNextMessage && !isLTR && chatTime ==""? Dimensions.radiusSmall : Dimensions.radiusExtraLarge + 5),
                        bottomRight: Radius.circular(isSameUserWithPreviousMessage && !isLTR && previousMessageHasChatTime ==""? Dimensions.radiusSmall :Dimensions.radiusExtraLarge + 5),
                      ) : BorderRadius.circular(Dimensions.radiusExtraLarge + 5),

                        color: isMe ? Theme.of(context).hintColor.withOpacity(.125) : ColorResources.getPrimary(context).withOpacity(.10)),

                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      (message.message != null && message.message!.isNotEmpty) ? Text(message.message!,
                          style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                              color: isMe ? ColorResources.getTextColor(context): ColorResources.getTextColor(context))
                      ) : const SizedBox.shrink(),
                    ]),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: AnimatedContainer(
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(milliseconds: 500),
                    height: chatProvider.onMessageTimeShowID == message.id.toString() ? 25.0 : 0.0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: chatProvider.onMessageTimeShowID == message.id.toString() ?
                        Dimensions.paddingSizeExtraSmall : 0.0,
                      ),
                      child: Text(chatProvider.getOnPressChatTime(message) ?? "", style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall
                      ),),
                    ),
                  ),
                ),



              // Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              //     child: Text(DateConverter.customTime(DateTime.parse(message.createdAt!)),
              //         style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
              //             color: ColorResources.getHint(context)))),


            ],
                )),
              ],
            ),



            // if(images.isNotEmpty) const SizedBox(height: Dimensions.paddingSizeSmall),
            images.isNotEmpty?
            Directionality(textDirection:Provider.of<LocalizationController>(context, listen: false).isLtr ? isMe ?
            TextDirection.rtl : TextDirection.ltr : isMe ? TextDirection.ltr : TextDirection.rtl,
                child: Padding (
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall),
                  child: SizedBox(width: MediaQuery.of(context).size.width /2 ,
                    child: Stack(children: [
                      GridView.builder(
                        padding: EdgeInsets.zero,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1, crossAxisCount: 2,
                            mainAxisSpacing: Dimensions.paddingSizeSmall, crossAxisSpacing: Dimensions.paddingSizeSmall),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: images.length> 4? 4: images.length,
                          itemBuilder: (BuildContext context, index) {
                            return  InkWell(onTap: () {
                              if(images.length == 1){
                                showDialog(context: context, builder: (ctx)  =>  ImageDialogWidget(
                                    imageUrl: '${images[index].path}'));
                              }else{
                                showDialog(context: context, builder: (ctx)  =>  ChattingMultiImageSlider(
                                    images: images));
                              }
                            },
                              child: ClipRRect(borderRadius: BorderRadius.circular(5),
                                child:CustomImageWidget(fit: BoxFit.cover,
                                      image: '${images[index].path}')),);

                          }),

                      if(images.length> 4)
                        Positioned(bottom: 0, right: 0,
                          child: InkWell(onTap: () => showDialog(context: context, builder: (ctx)  =>  ChattingMultiImageSlider(
                              images: images)),
                            child: ClipRRect(borderRadius: BorderRadius.circular(5),
                                child:Container(width: MediaQuery.of(context).size.width/4.2, height: MediaQuery.of(context).size.width/4.2,
                                  decoration: BoxDecoration(
                                      color: Colors.black54.withOpacity(.75), borderRadius: BorderRadius.circular(10)
                                  ),child: Center(child: Text("+${images.length-3}", style: robotoRegular.copyWith(color: Colors.white),)),)),),
                        ),

                    ],
                    ),
                  ),
                )) : const SizedBox.shrink(),




          files.isNotEmpty ?
          Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [

            files.isNotEmpty ?
            Directionality(
              textDirection: isMe  && isLTR?
              TextDirection.rtl : !isLTR && !isMe?
              TextDirection.rtl : TextDirection.ltr,

              child: Padding(
                padding: EdgeInsets.only(left: isMe ? 30 : 0, right: !isMe ? 30 : 0, bottom: 5),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: files.length,
                    padding: files.isNotEmpty ? const EdgeInsets.only(top: Dimensions.paddingSizeSmall) : EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 60,
                        crossAxisCount: 2,
                        mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
                        crossAxisSpacing: Dimensions.paddingSizeExtraSmall
                    ),
                    itemBuilder: (context, index){

                      return InkWell(
                        onTap: ()async{
                          final status = await Permission.notification.request();
                          if (kDebugMode) {
                            print("Status is $status");
                          }
                          if(status.isGranted){
                            Directory? directory = Directory('/storage/emulated/0/Download');
                            if (!await directory.exists()){
                              directory = Platform.isAndroid
                                  ? await getExternalStorageDirectory() //FOR ANDROID
                                  : await getApplicationSupportDirectory();
                            }
                            chatProvider.downloadFile(
                                files[index].path!, directory!.path,
                                "${directory.path}/${files[index].key}", ""
                                "${files[index].key}"
                            );
                          }else if(status.isDenied){
                            await openAppSettings();
                          }
                        },
                        onLongPress: () {
                          // conversationController.toggleOnClickImageAndFile(
                          //     onImageOrFileTimeShowID : widget.conversationData.id!);
                        },
                        child: Container(width: 180, height: 60,
                            decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),),
                            child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Row(children: [
                                    const Image(image: AssetImage(Images.fileIcon),
                                      height: 30,
                                      width: 30,
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),


                                    Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start, children: [


                                          Text(files[index].key.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                                          ),


                                          Text("${files[index].size}", style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: Theme.of(context).hintColor)
                                          ),
                                        ]),
                                    )],

                                  ),
                                )
                            )
                        ),
                      );
                    }
                ),
              ),
            )
                : const SizedBox(),

            // AnimatedContainer(
            //   curve: Curves.fastOutSlowIn,
            //   duration: const Duration(milliseconds: 500),
            //   height: conversationController.onImageOrFileTimeShowID == widget.conversationData.id ? 25.0 : 0.0,
            //   child: Padding(
            //     padding: EdgeInsets.only(
            //       top: conversationController.onImageOrFileTimeShowID == widget.conversationData.id ?
            //       Dimensions.paddingSizeExtraSmall : 0.0,
            //     ),
            //     child: Text(conversationController.getOnPressChatTime(widget.conversationData) ?? "", style: ubuntuRegular.copyWith(
            //         fontSize: Dimensions.fontSizeSmall
            //     ),),
            //   ),
            // ),

          ]) :const SizedBox.shrink(),





          ],
        );
      }
    );
  }
}
