import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constraints/app_colors.dart';
import '../../constraints/header_text.dart';
import '../../controllers/user_controllers/add_review_controller.dart';
import '../../widgets/app_button.dart';

class AddReview extends StatelessWidget {
  String? page;
  String proId;
  AddReview({Key? key, this.page,required this.proId}) : super(key: key);
  var ratings=5.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 // final ProductDetailsController productDetailsController=Get.put(ProductDetailsController());
  final AddReviewController addReviewController=Get.put(AddReviewController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 10.h,),
            RatingBar(
              initialRating: 5,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              ratingWidget: RatingWidget(
                full: const Icon(Icons.star,color: AppColors.mainColorPink,),
                half: const Icon(Icons.star_half),
                empty: const Icon(Icons.star_border_outlined,color: Colors.grey,),
              ),
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              onRatingUpdate: (rating) {
                ratings.value=rating.toInt();
              },
            ),
            SizedBox(height: 10.h,),
            Obx(() => HeaderText(text: "Rating: $ratings"),),
            SizedBox(
              height: 10.h,
            ),
            Container(height: 1,color: Colors.grey,),
            SizedBox(
              height: 10.h,
            ),
            titleTextField(),
            SizedBox(height: 10.h,),
            reeviewTextField(),
            SizedBox(height: 10.h,),
            SizedBox(
              height: 50.h,
              width: 150.w,
              child: InkWell(
                onTap: () {
                  if(_formKey.currentState!.validate()) {



                    addReviewController.rating.value=ratings.value;
                    addReviewController.proId.value=proId;
                    addReviewController.addReview(page:page);
                  }
                  // Get.toNamed('/user_info_page');
                },
                child: AppButton(
                  alignment: MainAxisAlignment.center,
                  text: 'SUBMIT',
                  textColor: Colors.white,
                  bgColor: Colors.black.withOpacity(.8),
                  align: TextAlign.center,
                  textSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget titleTextField() {
    return Column(
      children: [
        Container(
          color: Colors.white.withOpacity(.8),
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Title is Required";
              } else {
                return null;
              }
            },
           // controller: productDetailsController.titleController,
            controller: addReviewController.titleController,
            keyboardType: TextInputType.name,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, bottom: 10),
              /*  border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),*/
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.mainColorRed),
              ),
              // prefixIcon: Icon(Icons.account_circle_rounded),
              // labelText: "Enter Your First Name",
              hintText: "Title",
              labelText: "Title",
              labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.red,
              hoverColor: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  Widget reeviewTextField() {
    return Column(
      children: [
        Container(
          color: Colors.white.withOpacity(.8),
          child: TextFormField(
            maxLines: 20,
            minLines: 5,
            controller: addReviewController.reviewController,
           // controller: productDetailsController.reviewController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Review is Required";
              }
              return null;
            },
            keyboardType: TextInputType.multiline,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, bottom: 10),
              /*border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),*/
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              //prefixIcon: Icon(Icons.account_circle_rounded),
              // labelText: "Enter Your Last Name",
              hintText: "Review",
              labelText: "Review",
              labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.red,
              hoverColor: Colors.red,
            ),
          ),
        )
      ],
    );
  }
}
