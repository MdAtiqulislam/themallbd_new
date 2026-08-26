import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/header_text.dart';

class CartRuleDetailsDialog extends StatelessWidget {
  final String description;

  const CartRuleDetailsDialog({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          //height: 300,
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HeaderText(text: "Cart Rule Details"),
              const SizedBox(
                height: 10,
              ),
              BodyText(
                text: description,
                maxLine: 50,
                color: AppColors.mainColorPink,
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: AppColors.mainColorRed,
                  textColor: Colors.white,
                onPressed: (){
                    Get.back();
                },
                  child: HeaderText(text: "Back",color: Colors.white,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
