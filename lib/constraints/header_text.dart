import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderText extends StatelessWidget {
  final String text;
  TextAlign align;
  Color? color;
  int maxLine;
  double size;
  final bool resize;
  TextOverflow textOverflow;
  FontWeight fontWeight;

  HeaderText({super.key,
    required this.text,
    this.color=const Color(0xFF333333),
    this.size=16,
    this.resize=true,
    this.textOverflow=TextOverflow.ellipsis,
    this.fontWeight=FontWeight.bold,
    this.align=TextAlign.center,
    this.maxLine=1
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
        fontSize:resize?size.spMin:size, //MediaQuery.of(context).orientation==Orientation.portrait?size.sp:size.sp/2:size,
        fontWeight: fontWeight,
      ),
    );
  }
}