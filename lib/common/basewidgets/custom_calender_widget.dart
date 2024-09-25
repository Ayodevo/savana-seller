import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/transaction/controllers/transaction_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomCalenderWidget extends StatefulWidget {
  const CustomCalenderWidget({Key? key}) : super(key: key);

  @override
  State<CustomCalenderWidget> createState() => _CustomCalenderWidgetState();
}

class _CustomCalenderWidgetState extends State<CustomCalenderWidget> {
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
    return Consumer<TransactionController>(
      builder: (context,transactionProvider,_) {
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
                transactionProvider.selectDate(context, rng[0], rng[1]);
               Navigator.pop(context);
              },
              todayHighlightColor: Theme.of(context).primaryColor,
              selectionMode: DateRangePickerSelectionMode.range,
              rangeSelectionColor: Theme.of(context).primaryColor.withOpacity(.25),
              view: DateRangePickerView.month,
              startRangeSelectionColor: Theme.of(context).primaryColor,
              endRangeSelectionColor: Theme.of(context).primaryColor,
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 2)),
                  DateTime.now().add(const Duration(days: 2))),
              onSelectionChanged: _onSelectionChanged,
          ),),
        );
      }
    );
  }
}
