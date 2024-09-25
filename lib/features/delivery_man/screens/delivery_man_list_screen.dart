import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_delegate_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_search_field_widget.dart';
import 'package:sixvalley_vendor_app/features/delivery_man/widgets/delivery_man_list_view_widget.dart';

class DeliveryManListScreen extends StatefulWidget {
  const DeliveryManListScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryManListScreen> createState() => _DeliveryManListScreenState();
}

class _DeliveryManListScreenState extends State<DeliveryManListScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    Provider.of<DeliveryManController>(context, listen: false).deliveryManListURI(1,'');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated('delivery_man_list', context),isBackButtonExist: true,),
      body: RefreshIndicator(
        onRefresh: () async{
          Provider.of<DeliveryManController>(context, listen: false).deliveryManListURI(1,'');
        },
        child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: SliverDelegateWidget(
            height: 80,
            child : Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeMedium, Dimensions.paddingSizeDefault, Dimensions.paddingSizeMedium, Dimensions.paddingSizeDefault),
              child: CustomSearchFieldWidget(
                controller: searchController,
                hint: getTranslated('search', context),
                prefix: Images.iconsSearch,
                iconPressed: () => (){},
                onSubmit: (text) => (){},
                onChanged: (value){
                  Provider.of<DeliveryManController>(context, listen: false).deliveryManListURI(1, value);
                },
                isFilter: false,
              ),
            )
          )),
          const SliverToBoxAdapter(
            child: Column(children: [
                 DeliveryManListViewWidget(),
                 SizedBox(height: Dimensions.paddingSizeSmall)
               ],
            ),
          )
        ],
      ),),
    );
  }
}


