import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class VacationCalenderWidget extends StatefulWidget {
  const VacationCalenderWidget({Key? key}) : super(key: key);

  @override
  State<VacationCalenderWidget> createState() => VacationCalenderWidgetState();
}

class VacationCalenderWidgetState extends State<VacationCalenderWidget> {
  String _range = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('yyyy-MM-d').format(args.value.startDate)}/'

            '${DateFormat('yyyy-MM-d').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
      } else if (args.value is List<DateTime>) {
      } else {
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    List<String> rng = _range.split('/');
    return Consumer<ShopController>(
        builder: (context,shop,_) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: MediaQuery.of(context).size.height/5),
            child: Container(
              padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
              color: Theme.of(context).canvasColor,
              child: SfDateRangePicker(
                confirmText: getTranslated('ok', context)!,
                showActionButtons: true,
                cancelText: getTranslated('cancel', context)!,
                onCancel: ()=> Navigator.pop(context),
                onSubmit: (value){
                  if(_range.isNotEmpty){
                    shop.selectDate(context, rng[0], rng[1]);
                    Navigator.pop(context);
                  }else{
                    showCustomSnackBarWidget("${getTranslated("select_date", context)}", context);
                  }

                },
                todayHighlightColor: Theme.of(context).primaryColor,
                selectionMode: DateRangePickerSelectionMode.range,
                rangeSelectionColor: Theme.of(context).primaryColor.withOpacity(.25),
                view: DateRangePickerView.month,
                startRangeSelectionColor: Theme.of(context).primaryColor,
                endRangeSelectionColor: Theme.of(context).primaryColor,
                initialSelectedRange: PickerDateRange(
                    shop.shopModel!.vacationStartDate != null? DateTime.parse(shop.shopModel!.vacationStartDate!): DateTime.now().subtract(const Duration(days: 2)),
                    shop.shopModel!.vacationEndDate != null? DateTime.parse(shop.shopModel!.vacationEndDate!): DateTime.now().add(const Duration(days: 2))),
                onSelectionChanged: _onSelectionChanged,
              ),),
          );
        }
    );
  }
}
