import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../constraints/body_text.dart';
import '../../constraints/header_text.dart';
import '../../widgets/app_button.dart';

class EmptyCard extends StatelessWidget {
  final String title;
  final String bodyText;
  final String? buttonText;
  final String? bottomText;
  final String image;
  final VoidCallback? onTap;
  final bool showButton;


   const EmptyCard(
      {Key? key,
      required this.title,
      required this.bodyText,
       this.buttonText,
       this.bottomText,
        this.showButton=true,
        this.image="",
        this.onTap
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 40.0.w,right: 40.0.w, top: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
              visible: image.isNotEmpty,
              child: Image(image: AssetImage(image),),),
          HeaderText(
            text: title,
            size: 18,
            //fontWeight: FontWeight.w500,
          ),
           Center(
            child: Text(
              bodyText,
              textAlign: TextAlign.center,
            ),
          ),
         if(showButton) Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                //width: 200,
                height: 50.h,
                child: InkWell(
                  onTap: onTap,
                  child: AppButton(
                    alignment: MainAxisAlignment.center,
                    text: buttonText??"",
                    bgColor: Colors.black,
                    textColor: Colors.white,
                    textSize: 18,
                  ),
                ),
              ),
              BodyText(
                text: bottomText??"",
                align: TextAlign.center,
                size: 10,
              )
            ],
          )
        ],
      ),
    );
  }
}
