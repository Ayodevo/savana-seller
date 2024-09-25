import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/bank_info/controllers/bank_info_controller.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionChart extends StatefulWidget {

  const TransactionChart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TransactionChartState();
}

class TransactionChartState extends State<TransactionChart> {
  final Color leftBarColor = const Color(0xff4E9BF0);
  final Color rightBarColor = const Color(0xFFF4BE37);
  final double width = 5;

  final List<String> weeks = ['','Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
  final List<String> months = ['','Jan','Feb','Mar','Apr','May','June','July','Aug','Sep','Oct','Nov','Dec'];
  List<ChartData> _expanseChartList = [];

  List<ChartData> _incomeChartList = [];


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Color earningColor = const Color(0xFF4E9BF0);
    Color comisssionColor = const Color(0xFFF4BE37).withOpacity(.5);
    return Consumer<BankInfoController>(
      builder: (context,bankInfoProvider, _) {
        List<double> earnings = [];
        List<double> commissions = [];
        if(bankInfoProvider.userCommissions!=null && bankInfoProvider.userEarnings != null){
          for(double? earn in bankInfoProvider.userCommissions!) {
            earnings.add(PriceConverter.convertAmount(earn!, context));
          }
          for(double? commission in bankInfoProvider.userEarnings!) {
            commissions.add(PriceConverter.convertAmount(commission!, context));
          }
        }


        if(earnings.length < 9){

          _expanseChartList = commissions.asMap().entries.map((e) {
            return ChartData(weeks[e.key.toInt()], e.value);
          }).toList();

          _incomeChartList = earnings.asMap().entries.map((e) {
            return ChartData(weeks[e.key.toInt()], e.value);
          }).toList();

        }else if( earnings.length < 15){
          _expanseChartList = commissions.asMap().entries.map((e) {
            return ChartData(months[e.key.toInt()], e.value);
          }).toList();

          _incomeChartList = earnings.asMap().entries.map((e) {
            return ChartData(months[e.key.toInt()], e.value);
          }).toList();
        }else{
          _expanseChartList = commissions.asMap().entries.map((e) {
            return ChartData(e.key.toString(), e.value);
          }).toList();

          _incomeChartList = earnings.asMap().entries.map((e) {
            return ChartData(e.key.toString(), e.value);
          }).toList();
        }

        return AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Row(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Container(width: Dimensions.iconSizeLarge,height: Dimensions.iconSizeLarge ,
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                          child: Image.asset(Images.monthlyEarning)),
                      const SizedBox(width: Dimensions.paddingSizeSmall,),

                      Text(getTranslated('earning_statistic', context)!, style: robotoBold.copyWith(
                          color: ColorResources.getTextColor(context),
                          fontSize: Dimensions.fontSizeDefault),),

                        const Expanded(child: SizedBox(width: Dimensions.paddingSizeExtraLarge,)),
                        Container(
                          height: 50,width: 120,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),

                          ),
                          child: DropdownButton<String>(
                            value: bankInfoProvider.revenueFilterTypeIndex == 0 ? 'this_year' : bankInfoProvider.revenueFilterTypeIndex == 1 ?  'this_month' : 'this_week',
                            items: <String>['this_year', 'this_month', 'this_week' ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(getTranslated(value, context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                              );
                            }).toList(),
                            onChanged: (value) {
                              bankInfoProvider.setRevenueFilterName(context,value, true);
                              bankInfoProvider.setRevenueFilterType(value == 'this_year' ? 0 : value == 'this_month'? 1:2, true);

                            },
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        ),

                    ],),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),

                    Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                      children: [Row(children: [
                         Icon(Icons.circle,size: Dimensions.iconSizeSmall,
                            color: earningColor),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                        Text(getTranslated('your_earnings', context)!,
                          style: robotoSmallTitleRegular.copyWith(color: ColorResources.getTextColor(context),
                        fontSize: Dimensions.fontSizeDefault),),],),

                        const SizedBox(width : Dimensions.paddingSizeSmall,),

                        Row(children: [
                          Icon(Icons.circle,size: Dimensions.iconSizeSmall,
                              color: comisssionColor),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                          Text(getTranslated('commission_given', context)!,
                               style: robotoSmallTitleRegular.copyWith(color: ColorResources.getTextColor(context),
                                   fontSize: Dimensions.fontSizeSmall),
                        ),
                           ],
                         ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 38,
                ),
                Expanded(
                  child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    primaryXAxis: const CategoryAxis(),
                    primaryYAxis: const NumericAxis(),
                    series:[
                      LineSeries<ChartData, String>(
                        color: comisssionColor,
                        dataSource: _incomeChartList,
                        xValueMapper: (ChartData data,_)=> data.x,
                        yValueMapper: (ChartData data,_)=> data.y,
                      ),
                      LineSeries<ChartData, String>(
                        color: earningColor,
                        dataSource: _expanseChartList,
                        xValueMapper: (ChartData data,_)=> data.x,
                        yValueMapper: (ChartData data,_)=> data.y,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class ChartData{
  String x;
  double y;
  ChartData(this.x,this.y);
}

List<Color> gradientColors = [
  const Color(0xFF1B7FED),
  const Color(0xff4560ad),
];

List<Color> commissionGradientColors = [
  const Color(0xFFF4BE37),
  const Color(0xFFF4BE37),
];



