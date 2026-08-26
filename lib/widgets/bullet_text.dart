import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constraints/header_text.dart';

class BulletText extends StatelessWidget {
final  List<String> textList;
  const BulletText({Key? key,required this.textList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: textList.length,
        itemBuilder: (buildContext, index) {
          return singlePointText(index);
        });
  }
  Widget singlePointText(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: ListTile(
        horizontalTitleGap: 0,
        minLeadingWidth: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Icon(
                Icons.circle_rounded,
                size: 8.sp,
                color: Colors.black,
              ),
            ),
            Flexible(
                child: HeaderText(
                  text: textList[index],
                  maxLine: 20,
                  align: TextAlign.start,
                  fontWeight: FontWeight.normal,
                )),
          ],
        ),
      ),
    );
  }
}
