import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constraints/body_text.dart';


class NoInternetConnectionPage extends StatelessWidget {
  const NoInternetConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/offline.gif"),
                  BodyText(text: "There seems tobe a problem with your network connection...",maxLine: 10,size: 16,),
                  BodyText(text: "Please check your network & try again.",maxLine: 10,size: 12,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
