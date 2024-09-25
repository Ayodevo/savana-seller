import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import '../../../utill/dimensions.dart';

class AddProductSectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> childrens;
  const AddProductSectionWidget({super.key, required this.title, required this.childrens});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Text(title, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge))),

        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D1B7FED), // 0x0D is the hex value for 5% opacity
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: -3,
                ),
                BoxShadow(
                  color: Color(0x0D1B7FED), // 0x0D is the hex value for 5% opacity
                  offset: Offset(0, -6),
                  blurRadius: 12,
                  spreadRadius: -3,
                ),
              ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: childrens,
          ),
        ),
      ],
    );
  }
}
