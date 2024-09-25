import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/notification/controllers/notification_controller.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/notification/domain/models/notification_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('notification', context),),
      body: Consumer<NotificationController>(
        builder: (context, notificationController, _) {
          return SingleChildScrollView(
            controller: scrollController,
            child: notificationController.notificationModel != null? (notificationController.notificationModel!.notification != null && notificationController.notificationModel!.notification!.isNotEmpty)?
            PaginatedListViewWidget(
              scrollController: scrollController,
              onPaginate: (int? offset) async{
                await notificationController.getNotificationList(offset!);
              },
              totalSize: notificationController.notificationModel?.totalSize,
              offset: notificationController.notificationModel?.offset,
              itemView: ListView.builder(
                shrinkWrap: true,
                  itemCount: notificationController.notificationModel?.notification?.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  itemBuilder: (context, index){
                return NotificationCard(notificationItem: notificationController.notificationModel!.notification![index]);
              }),):const Center(child: NoDataScreen()):const CustomLoaderWidget(),
          );
        }
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notificationItem;
  const NotificationCard({Key? key, required this.notificationItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: InkWell(onTap: (){
        Provider.of<NotificationController>(context, listen: false).seenNotification(notificationItem.id!);
        showDialog(context: context, builder: (_)=> NotificationDialog(title: notificationItem.title!, subTitle: notificationItem.createdAt!));
      },
        child: Stack(children: [
            Container(width: MediaQuery.of(context).size.width, decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(notificationItem.title!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                  const SizedBox(height: Dimensions.paddingSizeSmall,),
                  Text(DateConverter.customTime(DateTime.parse(notificationItem.createdAt!)),
                    style: robotoRegular.copyWith(fontSize: Dimensions.paddingSizeSmall),),
                ],),
              ),
            ),
            if(notificationItem.notificationSeenStatus == 0)
            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CircleAvatar(radius: 4, backgroundColor: Theme.of(context).primaryColor,),
            )
          ],
        ),
      ),
    );
  }
}


class NotificationDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  const NotificationDialog({Key? key, required this.title, required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(

      child: Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, children: [

            InkWell(onTap: ()=> Navigator.of(context).pop(), child: const Padding(
                padding: EdgeInsets.only(top : Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Icon(CupertinoIcons.clear, ),
                  ],
                ),
              ),
            ),

          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
            child: SizedBox(width: 40, child: Image.asset(Images.notificationDialog)),
          ),
          Center(child: Text('${AppConstants.companyName} $title',
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault))),
          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Text(DateConverter.customTime(DateTime.parse(subTitle)),
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor))),

          const SizedBox(height: Dimensions.fontSizeDefault),
          Text(getTranslated('notification_message', context)??'', textAlign: TextAlign.center,),

          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text.rich(TextSpan(children: [
            TextSpan(text: '${getTranslated('note', context)} : ',
                style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
            TextSpan(text: '${getTranslated('notification_note', context)}',
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(.75)))
          ])),

            const SizedBox(height: Dimensions.paddingSizeDefault,),
            CustomButtonWidget(btnTxt: '${getTranslated('visit', context)}', onTap: (){
              _launchUrl('${AppConstants.baseUrl}/shopView/${Provider.of<ProfileController>(context, listen: false).userId}');
            },)
        ],),
      ),
    );
  }
}
Future<void> _launchUrl(String url) async {
  if(kDebugMode){
    print("=====>Url is $url");
  }
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}