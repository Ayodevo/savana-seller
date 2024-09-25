import 'package:flutter/cupertino.dart';

abstract class SplashServiceInterface {
  Future<dynamic> getConfig();
  void initSharedData();
  String getCurrency();
  void setCurrency(String currencyCode);
  void setShippingType(String shippingType);
  Future<dynamic> getShippingTypeList(BuildContext context, String type);
}