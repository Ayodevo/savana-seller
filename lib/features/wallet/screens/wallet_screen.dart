import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/features/transaction/controllers/transaction_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/title_row_widget.dart';
import 'package:sixvalley_vendor_app/features/transaction/screens/transaction_screen.dart';
import 'package:sixvalley_vendor_app/features/wallet/widgets/wallet_card_widget.dart';
import 'package:sixvalley_vendor_app/features/wallet/widgets/wallet_transaction_list_view_widget.dart';
import 'package:sixvalley_vendor_app/features/wallet/widgets/withdraw_balance_widget.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    Provider.of<TransactionController>(context, listen: false).getTransactionList(context,'all','','');
    super.initState();
  }
  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(title: getTranslated('wallet', context)),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<TransactionController>(context, listen: false).getTransactionList(context,'all','','');
        },
        backgroundColor: Theme.of(context).primaryColor,


        child: CustomScrollView(controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                child: Column(children: [
                  const WithdrawBalanceWidget(),
                  Consumer<ProfileController>(
                      builder: (context, seller, child) {
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            child: Row(children: [
                              Expanded(child: WalletCardWidget(
                                amount: PriceConverter.convertPrice(context, seller.userInfoModel!.wallet != null ?
                                seller.userInfoModel!.wallet!.withdrawn : 0),

                                title: '${getTranslated('withdrawn', context)}',
                                color: ColorResources.withdrawCardColor(context),)),

                              Expanded(child: WalletCardWidget(
                                amount: PriceConverter.convertPrice(context, seller.userInfoModel!.wallet != null ?
                                seller.userInfoModel!.wallet!.pendingWithdraw : 0),

                                title: '${getTranslated('pending_withdrawn', context)}',
                                color: ColorResources.pendingCardColor(context),)),
                            ],)),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            child: Row(children: [
                              Expanded(child: WalletCardWidget(
                                amount: PriceConverter.convertPrice(context, seller.userInfoModel!.wallet != null ?
                                seller.userInfoModel!.wallet!.commissionGiven : 0),

                                title: '${getTranslated('commission_given', context)}',
                                color: ColorResources.commissionCardColor(context),)),

                              Expanded(child: WalletCardWidget(
                                amount: PriceConverter.convertPrice(context, seller.userInfoModel!.wallet != null ?
                                seller.userInfoModel!.wallet!.deliveryChargeEarned : 0),

                                title: '${getTranslated('delivery_charge_earned', context)}',
                                color: ColorResources.deliveryChargeCardColor(context),)),
                            ],)),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            child: Row(children: [
                              Expanded(child: WalletCardWidget(
                                amount: PriceConverter.convertPrice(context, seller.userInfoModel!.wallet != null ?
                                seller.userInfoModel!.wallet!.collectedCash : 0),
                                title: '${getTranslated('collected_cash', context)}',
                                color: ColorResources.collectedCashCardColor(context),)),

                              Expanded(child: WalletCardWidget(
                                amount: PriceConverter.convertPrice(context, seller.userInfoModel!.wallet != null ?
                                seller.userInfoModel!.wallet!.totalTaxCollected : 0),

                                title: '${getTranslated('total_collected_tax', context)}',
                                color: ColorResources.collectedTaxCardColor(context),)),
                            ],),
                          ),
                        ],);
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeMedium, Dimensions.paddingSizeDefault, Dimensions.paddingSizeMedium, Dimensions.paddingSizeSmall),
                    child: TitleRowWidget(title: getTranslated('withdraw_history', context),
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionScreen())),),
                  ),

                  Consumer<TransactionController>(
                      builder: (context, transactionProvider, child) {
                        return  Container(
                          child: transactionProvider.transactionList !=null ? transactionProvider.transactionList!.isNotEmpty ?
                          WalletTransactionListViewWidget(transactionProvider: transactionProvider) : const NoDataScreen()
                              : Center(child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                        );
                      }
                  ),
                ],),
              )
            )
          ],
        ),
      ),
    );
  }
}

