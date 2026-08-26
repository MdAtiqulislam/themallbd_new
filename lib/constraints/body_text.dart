import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BodyText extends StatelessWidget {
  final String text;
  TextAlign align;
  Color? color;
  double size;
  int maxLine;
  final bool resize;
  TextOverflow textOverflow;
  FontWeight fontWeight;
  BodyText({super.key,
    required this.text,
    this.color=const Color(0xff626262),
    this.size=12,
    this.resize=true,
    this.textOverflow=TextOverflow.ellipsis,
    this.fontWeight=FontWeight.normal,
    this.align=TextAlign.center,
    this.maxLine=3,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      overflow: textOverflow,
      textAlign: align,
      style: TextStyle(
        color: color,
        //fontSize:resize? MediaQuery.of(context).orientation==Orientation.portrait?size.sp:size.sp/2:size,
        fontSize:resize?size.spMin:size,// MediaQuery.of(context).orientation==Orientation.portrait?size.sp:size.sp/2:size,
        fontWeight: fontWeight,
      ),
    );
  }
}