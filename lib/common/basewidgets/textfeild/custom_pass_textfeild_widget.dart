import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CustomPasswordTextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintTxt;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool border;
  final String? prefixIconImage;
  final Function? onChanged;


  const CustomPasswordTextFieldWidget({Key? key, this.controller, this.hintTxt, this.focusNode, this.nextNode, this.textInputAction, this.border = false, this.prefixIconImage, this.onChanged}) : super(key: key);

  @override
  CustomPasswordTextFieldWidgetState createState() => CustomPasswordTextFieldWidgetState();
}

class CustomPasswordTextFieldWidgetState extends State<CustomPasswordTextFieldWidget> {
  bool _obscureText = true;
  void _toggle() {
    setState(() { _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(height: 50, width: double.infinity,
      decoration: BoxDecoration(
        border:widget.border? Border.all(width: 1, color: Theme.of(context).hintColor.withOpacity(.35)):null,
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        boxShadow: [
          BoxShadow(color: Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).primaryColor.withOpacity(0):
          Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1)) // changes position of shadow
        ],
      ),
      child: ClipRRect( borderRadius: BorderRadius.circular(6),
        child: TextFormField(
          cursorColor: Theme.of(context).primaryColor,
          controller: widget.controller,
          obscureText: _obscureText,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          onFieldSubmitted: (v) {
            setState(() {
              widget.textInputAction == TextInputAction.done ? FocusScope.of(context).consumeKeyboardToken()
                  : FocusScope.of(context).requestFocus(widget.nextNode);
            });
            },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(
              prefixIconConstraints: const BoxConstraints( minWidth: 20, minHeight: 20),
              prefixIcon: widget.prefixIconImage != null ?
              Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration( color: Theme.of(context).primaryColor.withOpacity(.135)),
                  child: Image.asset(widget.prefixIconImage!,width: 20, height: 20,)):const SizedBox(),

              suffixIcon: GestureDetector(onTap: _toggle,
                  child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, size: 20,)),
              suffixIconConstraints:  const BoxConstraints( minWidth: 50, minHeight: 20,),
              hintText: widget.hintTxt ?? '',
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
              isDense: true,
              filled: true,
              focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor)),
              fillColor: Theme.of(context).highlightColor,
              hintStyle: titilliumRegular.copyWith(color: Theme.of(context).hintColor),
              border: InputBorder.none),
          onChanged: widget.onChanged as void Function(String)?,
        ),
      ),
    );
  }
}
