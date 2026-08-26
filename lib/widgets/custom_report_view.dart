import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:themallbd_new/constraints/app_strings.dart';
import 'package:themallbd_new/models/report_reasons_model.dart';
import 'package:themallbd_new/services/local_services.dart';
import 'package:themallbd_new/services/remote_services.dart';
import 'package:themallbd_new/utils/show_snack_bar.dart';

import '../constraints/app_colors.dart';
import '../constraints/header_text.dart';
import '../models/reviews_model.dart';

class CustomReportView extends StatelessWidget {
  final List<ReportReasonModel> reportReason;
  final ReviewsModel review;

  CustomReportView({required this.review,required this.reportReason, super.key});

  var selectedReason = ReportReasonModel();
  var isLoading=false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Stack(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                color: AppColors.mainColorRed,
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderText(
                      text: "Report Abuse",
                      align: TextAlign.start,
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  children: [
                    reasonsDropDown(),
                    SizedBox(height: 16.h,),
                    additionalNoteTextField(),
                    SizedBox(height: 32.h,),
                    MaterialButton(
                      onPressed: (){
                        submitReport();
                      },
                      color: AppColors.mainColorRed,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r),),
                      child: HeaderText(text: "Submit Report",color: Colors.white,),

                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        if(isLoading.value)const Center(child: CircularProgressIndicator(),)
      ],
    ));
  }

  Widget reasonsDropDown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "Report Reason",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          color: AppColors.scaffoldBGColor,
          child: DropdownButtonFormField<ReportReasonModel>(
            isExpanded: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              labelStyle: TextStyle(color: Colors.black),
            ),
            icon: const Icon(Icons.arrow_drop_down),
            validator: (value) => value == null ? 'field required' : null,
            value: selectedReason.id == null ? reportReason[0] : selectedReason,
            onChanged: (ReportReasonModel? newValue) {
              selectedReason = newValue!;
            },
            items: reportReason.map<DropdownMenuItem<ReportReasonModel>>(
                (ReportReasonModel value) {
              return DropdownMenuItem<ReportReasonModel>(
                value: value,
                child: Text(value.name.toString()),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget additionalNoteTextField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "Additional Note",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          color: AppColors.scaffoldBGColor,
          child: TextFormField(
            // controller: checkOutController.emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            maxLines: 10,
            minLines: 5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Additional note",
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

  void submitReport()async {
    isLoading.value=true;
    var token=await LocalServices.getToken();
    var body={
      "review_id":review.id.toString(),
      "report":selectedReason.name??reportReason[0].name
    };
    var header={'Authorization': 'Bearer $token'};

    var endPoint=AppStrings.storeReportEndPoint;
    try {
      var response=await RemoteServices.postRequest(endPoint, body, header);
      if(response!=null){
        Get.back();
        ShowSnackBar(
          msg: response["msg"],
            isSuccess: true,
        ).showSnackBar();
        selectedReason=ReportReasonModel();
      }else{
        ShowSnackBar(
          msg: "Something went wrong. Please try again later.",
          isSuccess: true,
        ).showSnackBar();
      }
    } finally {
      isLoading.value=false;
    }


  }
}
