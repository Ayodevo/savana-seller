import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'custom_toast.dart';

enum SnackBarType {
  error,
  warning,
  success,
}

void showCustomSnackBarWidget(String? message, BuildContext? context, {bool isError = true, bool isToaster = false, SnackBarType sanckBarType = SnackBarType.success}) {
    final scaffold = ScaffoldMessenger.of(Get.context!);
    scaffold.showSnackBar(
      SnackBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        content: CustomToast(text: message ?? '', sanckBarType: sanckBarType),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );



    // Fluttertoast.showToast(
    //     msg: message??'',
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: isError ? const Color(0xFFFF0014) : const Color(0xFF1E7C15),
    //     textColor: Colors.white,
    //     fontSize: Dimensions.fontSizeExtraSmall
    // );

}