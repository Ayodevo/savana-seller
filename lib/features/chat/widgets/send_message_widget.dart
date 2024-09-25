import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/chat/domain/models/message_body.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:flutter/foundation.dart' as foundation;


class SendMessageWidget extends StatefulWidget {
  final int? id;
  const SendMessageWidget({Key? key, this.id}) : super(key: key);

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final TextEditingController _controller = TextEditingController();
  bool emojiPicker = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(
      builder: (context, chatController, _) {
        return ColoredBox(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: SizedBox(height: 40,
                  child: Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                    child: Row(children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                          child: TextField(
                            controller: _controller,
                            style: titilliumRegular,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            expands: true,
                            onTap: (){
                              setState(() {
                                emojiPicker = false;
                                chatController.setEmojiPickerValue(false, notify: true);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: getTranslated('type_here', context),
                              hintStyle: titilliumRegular.copyWith(color: ColorResources.hintTextColor),
                              border: InputBorder.none,

                              prefixIcon: GestureDetector(onTap: (){
                                setState(() {
                                  chatController.setEmojiPickerValue(!emojiPicker, notify: true);
                                  emojiPicker = !emojiPicker;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                });
                              },
                                child: Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Image.asset(Images.emoji),),
                              ),

                              suffixIcon: Row( mainAxisSize : MainAxisSize.min, children: [
                                  GestureDetector(onTap: ()=> chatController.pickOtherFile(false),
                                    child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                      child: Image.asset(Images.file, height: 30, width: 30)),
                                  ),
                                  GestureDetector(onTap: ()=> chatController.pickMultipleImage(false),
                                    child: Padding(padding: const EdgeInsets.symmetric(horizontal:  Dimensions.paddingSizeExtraSmall),
                                      child: Image.asset(Images.attachment, height: 30, width: 30, color: Theme.of(context).primaryColor)),
                                  ),
                                ],
                              ),
                            ),
                            onChanged: (String newText) {
                              if(newText.isNotEmpty && !chatController.isSendButtonActive) {
                                chatController.toggleSendButtonActivity();
                              }else if(newText.isEmpty && chatController.isSendButtonActive) {
                                chatController.toggleSendButtonActivity();
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      chatController.isLoading? const Center(child: SizedBox(width: 30,height: 30,child: CircularProgressIndicator())):
                      GestureDetector(
                        onTap: () {
                          if(_controller.text.trim().isNotEmpty || chatController.pickedImageFileStored!.isNotEmpty || chatController.objFile!.isNotEmpty){
                            MessageBody messageBody = MessageBody(sellerId: widget.id, message: _controller.text.trim());
                            chatController.sendMessage(messageBody).then((value){
                              if(value.statusCode == 200){
                                _controller.clear();
                              }
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            border: Border.all(color: Theme.of(context).hintColor, width: 2),
                          ),
                          child: SizedBox(width: Dimensions.iconSizeLarge,height: Dimensions.iconSizeLarge,
                            child: Image.asset(Images.send,
                              color: chatController.isSendButtonActive ? Theme.of(context).primaryColor : ColorResources.hintTextColor),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),

              if(emojiPicker)
                SizedBox(height: 250,
                  child: EmojiPicker(
                    onBackspacePressed: () {
                    },
                    textEditingController: _controller,
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: const Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      recentTabBehavior: RecentTabBehavior.RECENT,
                      recentsLimit: 28,
                      noRecents: const Text('No Recents', style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,),
                      loadingIndicator: const SizedBox.shrink(),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                    ),
                  ),
                ),
            ],
          ),
        );
      }
    );
  }
}
