import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_vendor_app/helper/image_size_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/features/chat/widgets/chat_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/features/chat/widgets/message_bubble_widget.dart';
import 'package:sixvalley_vendor_app/features/chat/widgets/send_message_widget.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final int? userId;
  const ChatScreen({Key? key, required this.userId, this.name = ''}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ImagePicker picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<ChatController>(context, listen: false).getMessageList(widget.userId, 1);
    Provider.of<ChatController>(context, listen: false).setEmojiPickerValue(false, notify: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChatController>(builder: (context, chat, child) {
        return Column(children: [
          CustomAppBarWidget(title: widget.name),
          const SizedBox(height: 2),
          Expanded(child: chat.messageList != null ? chat.messageList!.isNotEmpty ?
          SingleChildScrollView(
            reverse: true,
            controller : _scrollController,
            child: PaginatedListViewWidget(
              reverse: true,
              scrollController: _scrollController,
              totalSize: chat.messageModel?.totalSize,
              offset: chat.messageModel != null ? int.parse(chat.messageModel!.offset!) : 1,
              onPaginate: (int? offset) async => await chat.getMessageList( widget.userId, offset!, reload: false),

              itemView : ListView.builder(
                itemCount: chat.dateList?.length,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, index) {
                  return Column( mainAxisSize: MainAxisSize.min, children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall,
                        vertical: Dimensions.paddingSizeSmall),
                        // DateConverter.customTime(DateTime.parse(chat!.createdAt!))
                        child: Text(chat.dateList![index].toString(),
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5)),
                          textDirection: TextDirection.ltr)),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        itemCount: chat.messageList![index].length,
                        reverse: true,
                        itemBuilder: (context, subIndex) {
                          return MessageBubbleWidget(
                            message: chat.messageList![index][subIndex],
                            previous: (subIndex !=0) ? chat.messageList![index][subIndex-1] : null,
                            next: subIndex == (chat.messageList![index].length -1) ?  null : chat.messageList![index][subIndex+1],
                          );
                        },
                      )
                    ],
                  );
                }),
            ),
          )
           : const SizedBox.shrink() : const ChatShimmerWidget()),

          chat.pickedImageFileStored != null && chat.pickedImageFileStored!.isNotEmpty ?
          Container(
            color:  chat.isLoading == false && ((chat.pickedImageFileStored!=null && chat.pickedImageFileStored!.isNotEmpty) || (chat.objFile != null && chat.objFile!.isNotEmpty)) ?
            Theme.of(context).primaryColor.withOpacity(0.1) : null,
            height:  (chat.pickedFIleCrossMaxLimit || chat.pickedFIleCrossMaxLength || chat.singleFIleCrossMaxLimit) ? 110 : 90, width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: Dimensions.paddingSizeExtraSmall),
            child: Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  child: ListView.builder(scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return  Stack(children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(borderRadius: BorderRadius.circular(10),
                                child: SizedBox(height: 80, width: 80,
                                    child: Image.file(File(chat.pickedImageFileStored![index].path), fit: BoxFit.cover)))),


                        Positioned(right: 5,
                            child: InkWell(
                                splashColor: Colors.transparent,
                                child: const Icon(Icons.cancel_outlined, color: Colors.red),
                                onTap: () => chat.pickMultipleImage(true,index: index))),
                      ],
                      );},
                    itemCount: chat.pickedImageFileStored!.length,
                  ),
                ),

                if(chat.pickedFIleCrossMaxLimit || chat.pickedFIleCrossMaxLength || chat.singleFIleCrossMaxLimit)
                  Text( "${chat.pickedFIleCrossMaxLength ? "• ${getTranslated('can_not_select_more_than', context)!} ${AppConstants.maxLimitOfTotalFileSent.floor()} 'files' " :""} "
                      "${chat.pickedFIleCrossMaxLimit ? "• ${getTranslated('total_images_size_can_not_be_more_than', context)!} ${AppConstants.maxLimitOfFileSentINConversation.floor()} MB" : ""} "
                      "${chat.singleFIleCrossMaxLimit ? "• ${getTranslated('single_file_size_can_not_be_more_than', context)!} ${AppConstants.maxSizeOfASingleFile.floor()} MB" : ""} ",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                    ),
                  ),
              ],
            )
          ) : const SizedBox(),

          chat.objFile != null && chat.objFile!.isNotEmpty && chat.isLoading == false ?
          ColoredBox(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: []),
                  SizedBox(height: 70,
                    child: ListView.separated(
                      shrinkWrap: true, scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 5),
                      separatorBuilder: (context, index) => const SizedBox(width: Dimensions.paddingSizeDefault),
                      itemCount: chat.objFile!.length,
                      itemBuilder: (context, index){
                        String fileSize =  ImageSize.getFileSizeFromPlatformFileToString(chat.objFile![index]);
                        return Container(width: 180,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [

                            Image.asset(Images.fileIcon,height: 30, width: 30,),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall,),

                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [

                              Text(chat.objFile![index].name,
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                              ),

                              Text(fileSize, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).hintColor,
                              )),
                            ])),


                            InkWell(
                              onTap: () {
                                chat.pickOtherFile(true, index: index);
                              },
                              child: Padding(padding: const EdgeInsets.only(top: 5),
                                child: Align(alignment: Alignment.topRight,
                                  child: Icon(Icons.close,
                                    size: Dimensions.paddingSizeLarge,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ),
                            )
                          ]),
                        );
                      },
                    ),
                  ),

                  if(chat.pickedFIleCrossMaxLimit || chat.pickedFIleCrossMaxLength || chat.singleFIleCrossMaxLimit)
                    Text( "${chat.pickedFIleCrossMaxLength ? "• ${getTranslated('can_not_select_more_than', context)!} ${AppConstants.maxLimitOfTotalFileSent.floor()} 'files' " :""} "
                        "${chat.pickedFIleCrossMaxLimit ? "• ${getTranslated('total_images_size_can_not_be_more_than', context)!} ${AppConstants.maxLimitOfFileSentINConversation.floor()} MB" : ""} "
                        "${chat.singleFIleCrossMaxLimit ? "• ${getTranslated('single_file_size_can_not_be_more_than', context)!} ${AppConstants.maxSizeOfASingleFile.floor()} MB" : ""} ",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
          ) : const SizedBox(),

          SizedBox(height: chat.openEmojiPicker ? 360 : 60, child: SendMessageWidget(id: widget.userId))
        ]);
      }),
    );
  }
}



