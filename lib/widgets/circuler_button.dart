import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CircularButton extends StatelessWidget {
  final Color circleColor;
  final Color? bgColor;
  Widget child;

  CircularButton({
    Key? key,
    this.circleColor = Colors.transparent,
    this.bgColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0.r),
          side: BorderSide(width: 1, color: circleColor),),
      child: CircleAvatar(
        backgroundColor: bgColor,
        radius: 20.r,
        child: child,
      ),
    );
  }
}
