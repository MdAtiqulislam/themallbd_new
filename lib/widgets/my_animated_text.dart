import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';


class MyAnimatedText extends StatefulWidget {
  final String sentence;
  final Color? color_1;
  final Color? color_2;
  final int? duration;
  final int? maxLine;
  final double fontSize;

  const MyAnimatedText({
    super.key,
    required this.sentence,
    this.color_1,
    this.color_2,
    this.duration,
    this.fontSize=12,
    this.maxLine,
  });

  @override
  State<MyAnimatedText> createState() => _MyAnimatedTextState();
}

class _MyAnimatedTextState extends State<MyAnimatedText> {
  late Timer timer;
  bool changeColor = false;

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(Duration(milliseconds: widget.duration ?? 500), (timer) {
      changeColor = !changeColor;
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BodyText(text:widget.sentence,
        color: changeColor
            ? widget.color_1??AppColors.cart_rule_text_color
            :widget.color_2??AppColors.cart_rule_text_color2,
    maxLine: widget.maxLine??4,
      align: TextAlign.start,
      size: widget.fontSize.spMin,
    );
  }
}
