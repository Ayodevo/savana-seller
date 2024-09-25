import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_details_model.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/refund/controllers/refund_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';

class ApprovedAndRejectWidget extends StatefulWidget {
  final RefundModel? refundModel;
  const ApprovedAndRejectWidget({Key? key, this.refundModel}) : super(key: key);

  @override
  State<ApprovedAndRejectWidget> createState() => _ApprovedAndRejectWidgetState();
}

class _ApprovedAndRejectWidgetState extends State<ApprovedAndRejectWidget> {
  bool approved = false;
  bool reject = false;
  final TextEditingController noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<RefundController>(
        builder: (context,refundReq,_) {
          if(refundReq.refundDetailsModel != null){
            List<RefundStatus>? status =[];
            status = refundReq.refundDetailsModel?.refundRequest![0].refundStatus;

            if(status!.isNotEmpty){
              if(status[status.length-1].status == 'approved'){
                approved = true;
                reject = false;
              }else if(status[status.length-1].status == 'rejected'){
                approved = false;
                reject = true;
              }
            }
          }
          return Container(height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: ThemeShadow.getShadow(context),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeSmall,vertical: Dimensions.paddingSizeSmall),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                if(!reject)
                Expanded(
                  child: CustomButtonWidget(btnTxt: getTranslated('reject', context),
                    backgroundColor: Colors.red,
                    onTap: (){
                      if(widget.refundModel!.customer == null){
                        showCustomSnackBarWidget(getTranslated('customer_account_was_deleted_you_cant_update_status', context), context);
                      }else{
                        Navigator.pop(context);
                      showDialog(context: context, builder: (BuildContext context){
                        return ConfirmationDialogWidget(icon:  Images.cross,
                            description: getTranslated('are_you_sure_want_to_reject', context),
                            note: noteController,
                            refund: true,
                            onYesPressed: () {

                              if(noteController.text.trim().isEmpty){
                                showCustomSnackBarWidget(getTranslated('note_required', context), context);
                              }else{
                                refundReq.isLoading?
                                const Center(child: CircularProgressIndicator()):refundReq.updateRefundStatus(context, widget.refundModel!.id, 'rejected', noteController.text.trim()).then((value) {
                                  if(value.response!.statusCode ==200){
                                    Provider.of<RefundController>(context, listen: false).getRefundList(context);
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            }
                        );});
                      }
                    },
                  ),
                ),
                if(!reject && !approved)
                const SizedBox(width: Dimensions.paddingSizeDefault),
                if(!approved)
                Expanded(
                  child: CustomButtonWidget(btnTxt: getTranslated('approve', context),
                    backgroundColor: Theme.of(context).primaryColor,
                    onTap: (){
                      if(widget.refundModel!.customer == null){
                        showCustomSnackBarWidget(getTranslated('customer_account_was_deleted_you_cant_update_status', context), context);
                      }else{
                        Navigator.pop(context);
                        showDialog(context: context,barrierDismissible: false, builder: (BuildContext context){
                          return ConfirmationDialogWidget(icon:  Images.okIcon,
                              description: getTranslated('are_you_sure_want_to_approve', context),
                              note: noteController,
                              refund: true,
                              onYesPressed: () {

                                if(noteController.text.trim().isEmpty){
                                  showCustomSnackBarWidget(getTranslated('note_required', context), context);
                                }else{
                                  refundReq.isLoading?
                                  const Center(child: CircularProgressIndicator()):refundReq.updateRefundStatus(context, widget.refundModel!.id, 'approved',noteController.text.trim()).then((value) {
                                    if(value.response!.statusCode ==200){
                                      Provider.of<RefundController>(context, listen: false).getRefundList(context);
                                      Navigator.pop(context);
                                      noteController.clear();
                                    }
                                  });
                                }});
                        });
                      }},
                  ),
                ),
              ],),
          );
        }
    );
  }
}
