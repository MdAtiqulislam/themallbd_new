import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constraints/app_colors.dart';

class LoadMoreButton extends StatelessWidget {
  const LoadMoreButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20.w),
      decoration:  BoxDecoration(
        color: AppColors.mainColorRed,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: Padding(
        padding:
        EdgeInsets.only(left: 20.0.w, right: 20.w, top: 5.h, bottom: 5.h),
        child: Text(
          "SHOW MORE",
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ),
    );
  }
}
