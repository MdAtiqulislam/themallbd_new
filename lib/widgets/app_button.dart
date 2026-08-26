import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constraints/header_text.dart';



class AppButton extends StatelessWidget {
 final double textSize;
 final double radius;
  final String text;
  final Icon? icon;
  final Color bgColor;
  final Color textColor;
 final FontWeight fontWeight;
 final Border? border;
 final MainAxisAlignment alignment;
 final TextAlign align;

  const AppButton(
      {super.key,
      required this.text,
        this.icon,
        this.radius=5.0,
        this.border,
        this.fontWeight=FontWeight.bold,
        this.alignment=MainAxisAlignment.start,
        this.textSize=13.0,
        this.align=TextAlign.start,
      required this.bgColor,
      required this.textColor,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.all(
          Radius.circular(radius.r),
        ),
        color: bgColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 5.0.w),
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            if(icon!=null)icon!,
            HeaderText(text: text, align: align,color: textColor,size: textSize,fontWeight: fontWeight,),
          ],
        ),
      ),
    );
  }
}
