import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSkeleton extends StatelessWidget {
 final double? width;
  final double? height;

 const ShimmerSkeleton({Key? key,  this.width,  this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffd9d9d9),
      highlightColor: const Color(0xfff2f2f2),
      child: Container(

        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.r),),),
      ),
    );
  }
}
