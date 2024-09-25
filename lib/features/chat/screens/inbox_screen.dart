import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/chat/widgets/chat_card_widget.dart';
import 'package:sixvalley_vendor_app/features/chat/widgets/chat_header_widget.dart';

class InboxScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const InboxScreen({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final ScrollController _scrollController = ScrollController();

@override
  void initState() {
  Provider.of<ChatController>(context, listen: false).getChatList(context, 1);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      appBar: CustomAppBarWidget(title: getTranslated('inbox', context)),
      body: Consumer<ChatController>(builder: (context, chatProvider, child) {

        return Column(children: [

          Container(padding: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeExtraSmall),
              child:  const ChatHeaderWidget()),

          chatProvider.chatModel != null? (chatProvider.chatModel!.chat != null && chatProvider.chatModel!.chat!.isNotEmpty)?
          Expanded(
            child:  RefreshIndicator(
              onRefresh: () async {
                chatProvider.getChatList(context,1);
              },
              child: Scrollbar(child: SingleChildScrollView(controller: _scrollController,
                  child: Center(child: SizedBox(width: 1170,
                      child:  Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: PaginatedListViewWidget(
                          reverse: false,
                          scrollController: _scrollController,
                          onPaginate: (int? offset) => chatProvider.getChatList(context,offset!, reload: false),
                          totalSize: chatProvider.chatModel!.totalSize,
                          offset: int.parse(chatProvider.chatModel!.offset!),
                          enabledPagination: chatProvider.chatModel == null,
                          itemView: ListView.builder(
                            itemCount: chatProvider.chatModel!.chat!.length,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return  ChatCardWidget(chat: chatProvider.chatModel!.chat![index]);
                            },
                          ),
                        ),
                      ))))),
            ),
          ) :const Expanded(child: NoDataScreen()): Expanded(child: CustomLoaderWidget(height: MediaQuery.of(context).size.height-500)),

        ]);
      },
      ),
    );
  }
}



