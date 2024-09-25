import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CustomContainerWidget extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const CustomContainerWidget({Key? key, required this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap,
      child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraLarge),
        child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          height: 45,decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              border: Border.all(width: .35, color: Theme.of(context).hintColor)
          ),child: Row(children: [
            Expanded(child: Text(title, style: robotoRegular,)),
            const Icon(Icons.arrow_drop_down,)
          ],),),
      ),
    );
  }
}