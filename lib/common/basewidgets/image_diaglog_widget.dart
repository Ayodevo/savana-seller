import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';



class ImageDialogWidget extends StatelessWidget {
  final String imageUrl;
  const ImageDialogWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,surfaceTintColor: Colors.transparent,
      child: Stack(clipBehavior: Clip.none, children: [
          CustomImageWidget(image: imageUrl,),
          Positioned(top: 0, right: 0,
            child:  InkWell(onTap: ()=> Navigator.of(context).pop(),splashColor: Colors.transparent,highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(decoration: BoxDecoration(color: Theme.of(context).hintColor,
                    borderRadius: BorderRadius.circular(100)),
                    child: Icon(Icons.clear, color: Theme.of(context).cardColor,size: 25,)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
