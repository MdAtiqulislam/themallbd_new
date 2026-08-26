import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constraints/app_colors.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.bodyTextColor.withOpacity(.2),
        border: Border.all(width: 1, color: AppColors.bodyTextColor),
       ),
      child: InkWell(
        onTap: (){
          Get.toNamed('/search_page');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            children:  [
              Icon(Icons.search,color: Colors.black,size: 18.sp,),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text("SEARCH",style: TextStyle(color: Colors.black,fontSize: 14.sp,fontFamily:'Cabin',fontWeight: FontWeight.w600),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
