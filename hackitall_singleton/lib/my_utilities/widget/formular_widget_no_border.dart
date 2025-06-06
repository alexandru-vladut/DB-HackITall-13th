import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hackitall_singleton/my_utilities/widget/custom_text.dart';

class FormulerWidgetNoBorder extends StatelessWidget {
  const FormulerWidgetNoBorder({super.key, 
    required this.image,
    required this.title,
  });

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25.h),
      child: Row(
        children: [
          Container(
            width: 100.0,
            height: 85.0,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.contain)),
          ),

          CustomText(
            title: title,
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
