import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constraints/app_colors.dart';
import '../../constraints/body_text.dart';
import '../../constraints/header_text.dart';
import '../../controllers/check_out_controller.dart';
import '../../controllers/internet_controller.dart';
import '../../models/area_list_model.dart';
import '../../models/district_list_model.dart';
import '../../models/user_models/delivery_address_model.dart';

import '../../utils/show_snack_bar.dart';
import '../../widgets/app_button.dart';
import '../../widgets/my_animated_text.dart';
import 'no_internet_page.dart';

class CheckOutPage extends StatelessWidget {
  CheckOutPage({super.key});

  final CheckOutController checkOutController = Get.put(CheckOutController());

  /* final UserDetailsController userDetailsController =
      Get.put(UserDetailsController());*/
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCoupon = GlobalKey<FormState>();
  final InternetConnectionController internetConnectionController =
      Get.put(InternetConnectionController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //checkOutController.fetchUserData();
    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: HeaderText(
            text: "Quick Check Out",
            color: Colors.white,
            //color: Colors.white,
          ),
        ),
        // bottomNavigationBar: submitButton(),
        body: Obx(() => internetConnectionController.connectionStatus.value ==
                ConnectivityResult.none
            ? const NoInternetConnectionPage()
            : checkoutBodyContent()),
      ),
    );
  }

  Widget bodyContent() {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userProfileSection(),
                  SizedBox(
                    height: 10.h,
                  ),
                  //  deliveryAddressSection(),
                  /* SizedBox(
                    height: 10.h,
                  ),*/
                  shippingMethods(),
                  SizedBox(
                    height: 10.h,
                  ),
                  paymentMethod(),
                  SizedBox(
                    height: 10.h,
                  ),
                  orderSummarySection(),
                  SizedBox(
                    height: 10.h,
                  ),
                  if(checkOutController.myCartList.value.couponData?.total<checkOutController.minimumEMIAmount)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyAnimatedText(sentence: "Purchase ৳ ${checkOutController.minimumEMIAmount-checkOutController.myCartList.value.couponData?.total} more to avail EMI",fontSize: 14.sp,),
                    ),
                  if(checkOutController.myCartList.value.couponData?.total>=checkOutController.minimumEMIAmount)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyAnimatedText(sentence: "You are now eligible for EMI",fontSize: 14.sp,),
                    ),

                  SizedBox(
                    height: 10.h,
                  ),


                  couponSection(),
                  SizedBox(
                    height: 10.h,
                  ),
                  orderNoteSection(),
                  SizedBox(
                    height: 10.h,
                  ),
                  termsAndConditionsSection(),
                  SizedBox(
                    height: 50.h,
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: submitButton(),
        ),
        Positioned(
          bottom: 160.h,
          right: 15.w,
          child: InkWell(
            onTap: () => scrollUp(),
            child: Image.asset(
              "assets/icon/up_arrow.png",
              height: 40,
              width: 40,
            ),
          ),
        ),
        Positioned(
          bottom: 100.h,
          right: 15.w,
          child: InkWell(
            onTap: () => scrollDown(),
            child: Image.asset(
              "assets/icon/down_arrow.png",
              height: 40,
              width: 40,
            ),
          ),
        ),
        if (checkOutController.isUpdating.value)
          Container(
            color: Colors.grey.withAlpha(128),
            height: Get.height,
            width: Get.width,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }

  Widget userProfileSection() {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: "Address",
              size: 18,
            ),
            if (checkOutController.addressList.isNotEmpty)
              SizedBox(
                height: 15.h,
              ),
            if (checkOutController.addressList.isNotEmpty) addressDropDown(),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Container(child: firstNameTextField())),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(child: Container(child: lastNameTextField())),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            phoneTextField(),
            SizedBox(
              height: 15.h,
            ),
            addressTextField(),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!checkOutController.isLoadingDistrict.value)
                  Expanded(child: Container(child: cityDropDown())),
                SizedBox(
                  width: 10.w,
                ),
                if (!checkOutController.isLoadingArea.value &&
                    checkOutController.valueChooseDistrict.value.id == 1)
                  Expanded(child: Container(child: areaDropDown())),
              ],
            ),
          ],
        ),
      ),
    );
  }

//v-10.0.9 should keep backup

  /*Widget userProfileSection() {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Container(child: firstNameTextField())),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(child: Container(child: lastNameTextField())),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            emailTextField(),
            SizedBox(
              height: 15.h,
            ),
            phoneTextField(),
            SizedBox(
              height: 15.h,
            ),
            addressTextField(),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!checkOutController.isLoadingDistrict.value)
                  Expanded(child: Container(child: cityDropDown())),
                SizedBox(
                  width: 10.w,
                ),
                if (!checkOutController.isLoadingArea.value)
                  Expanded(child: Container(child: areaDropDown())),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }*/

  Widget firstNameTextField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "First Name",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          color: AppColors.scaffoldBGColor,
          child: TextFormField(
            //initialValue:userDetailsController.userData.value.firstName,
            validator: (value) {
              if (value!.isEmpty) {
                return "First Name Field is Required";
              } else {
                return null;
              }
            },
            controller: checkOutController.firstNameController,
            keyboardType: TextInputType.name,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "First Name",
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

  Widget lastNameTextField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "Last Name",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          color: AppColors.scaffoldBGColor,
          child: TextFormField(
            controller: checkOutController.lastNameController,
            //initialValue: userDetailsController.userData.value.lastName,
            validator: (value) {
              if (value!.isEmpty) {
                return "Last Name Field is Required";
              } else {
                return null;
              }
            },
            //  controller: registrationController.firstNameController,
            keyboardType: TextInputType.name,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Last Name",
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

  Widget emailTextField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "E-mail",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          color: AppColors.scaffoldBGColor,
          child: TextFormField(
            readOnly: checkOutController.emailController.text.isNotEmpty,

            controller: checkOutController.emailController,
            // initialValue: userDetailsController.userData.value.email,
            /*validator: (value) {
              if (value!.isEmpty) {
                return "E-mail is required";
              } else {
                return null;
              }
            },*/
            //  controller: registrationController.firstNameController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Your E-mail",
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

  Widget phoneTextField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "Mobile Number",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          color: AppColors.scaffoldBGColor,
          child: TextFormField(
            controller: checkOutController.phoneController,
            //initialValue: userDetailsController.userData.value.phone,
            textAlignVertical: TextAlignVertical.center,
            // readOnly: checkOutController.phoneController.text.length == 11,
            validator: (value) {
              if (value!.length > 2 &&
                  (value.isEmpty ||
                      !value.startsWith("0") ||
                      value[1] != "1" ||
                      value[2] == "1" ||
                      value[2] == "2" ||
                      !value.isNumericOnly ||
                      value.length < 11)) {
                return 'Please enter valid phone number';
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Mobile Number",
              labelStyle: const TextStyle(color: Colors.black),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                        height: 24.h,
                        image: const AssetImage("assets/icon/flag.png")),
                    SizedBox(
                      width: 20.w,
                    ),
                    HeaderText(
                      text: "+88 ",
                      align: TextAlign.start,
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget addressTextField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "Address",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          color: AppColors.scaffoldBGColor,
          child: TextFormField(
            controller: checkOutController.addressController,
            // initialValue: userDetailsController.userData.value.address,
            validator: (value) {
              if (value!.isEmpty) {
                return "Address is required";
              } else {
                return null;
              }
            },
            //  controller: registrationController.firstNameController,
            keyboardType: TextInputType.name,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Address",
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

  Widget cityDropDown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "City",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          color: AppColors.scaffoldBGColor,
          child: DropdownButtonFormField<DistrictListModel>(
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
            value: checkOutController.valueChooseDistrict.value.id == null
                ? null
                : checkOutController.isLoadingDistrict.value
                    ? DistrictListModel()
                    : checkOutController.valueChooseDistrict.value,
            /*checkOutController.userData.value.cityId == null
                ? null
                : checkOutController.isLoadingDistrict.value
                ? DistrictListModel()
                : checkOutController.districtList.value[checkOutController
                .districtList.value
                .indexWhere((element) =>
            element.id ==
                checkOutController.userData.value.cityId)],*/

            onChanged: (DistrictListModel? newValue) {
              checkOutController.valueChooseDistrict.value = newValue!;
              checkOutController.fetchShippingMethodId();
              checkOutController.fetchMyCartData();
            },
            items: checkOutController.districtList.value
                .map<DropdownMenuItem<DistrictListModel>>(
                    (DistrictListModel value) {
              return DropdownMenuItem<DistrictListModel>(
                value: value,
                child: Text(value.name.toString()),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

/*  Widget cityDropDown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "City",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          color: AppColors.scaffoldBGColor,
          child: DropdownButtonFormField<DistrictListModel>(
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
            value: checkOutController.userData.value.cityId == null
                ? null
                : checkOutController.isLoadingDistrict.value
                    ? DistrictListModel()
                    : checkOutController.districtList.value[checkOutController
                        .districtList.value
                        .indexWhere((element) =>
                            element.id ==
                            checkOutController.userData.value.cityId)],
            onChanged: (DistrictListModel? newValue) {
              checkOutController.valueChooseDistrict.value = newValue!;
              checkOutController.fetchShippingMethodId();
              checkOutController.fetchMyCartData();
            },
            items: checkOutController.districtList.value
                .map<DropdownMenuItem<DistrictListModel>>(
                    (DistrictListModel value) {
              return DropdownMenuItem<DistrictListModel>(
                value: value,
                child: Text(value.name.toString()),
              );
            }).toList(),
          ),
        )
      ],
    );
  }*/

  Widget addressDropDown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "Select Delivery Address",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          height: 51,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: AppColors.scaffoldBGColor,
          ),
          child: DropdownButtonFormField<DeliveryAddressModel>(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 15),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              labelStyle: const TextStyle(color: Colors.black),
            ),
            icon: const Icon(Icons.arrow_drop_down),
            //validator: (value) => value == null ? 'field required' : null,
            value: checkOutController.addressList.isEmpty
                ? null
                : checkOutController.addressList[0],
            /*checkOutController.addressList.value.isEmpty
                ? null
                : checkOutController.isLoadingDistrict.value
                ? DeliveryAddressModel()
                : checkOutController.districtList.value[checkOutController
                .districtList.value
                .indexWhere((element) =>
            element.id ==
                checkOutController.userData.value.cityId)],*/
            onChanged: (DeliveryAddressModel? newValue) {
              //checkOutController..value = newValue!;
              // checkOutController.fetchShippingMethodId();
              // checkOutController.fetchMyCartData();
              checkOutController.setDeliveryAddressFields(
                  deliveryAddress: newValue ?? DeliveryAddressModel());
            },
            items: checkOutController.addressList.value
                .map<DropdownMenuItem<DeliveryAddressModel>>(
                    (DeliveryAddressModel value) {
              return DropdownMenuItem<DeliveryAddressModel>(
                value: value,
                child: Text(
                  "${value.firstName} ${value.lastName}, "
                  "${value.address},"
                  " ${value.phone},"
                  "${value.area != null ? "${checkOutController.areaList[checkOutController.areaList.indexWhere((element) => element.id == value.area)].name}," : ""}"
                  "${value.district != null ? "${checkOutController.districtList[checkOutController.districtList.indexWhere((element) => element.id == value.district)].name}" : ""}",
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget areaDropDown() {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(
            text: "Area",
            size: 12,
            fontWeight: FontWeight.normal,
            align: TextAlign.left,
          ),
          Container(
            color: checkOutController.valueChooseDistrict.value.id != 1
                ? AppColors.bgColorOffLight
                : AppColors.scaffoldBGColor,
            child: IgnorePointer(
              ignoring: checkOutController.valueChooseDistrict.value.id != 1,
              child: DropdownButtonFormField<AreaListModel>(
                isExpanded: true,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelStyle: TextStyle(color: Colors.black),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: checkOutController.valueChooseDistrict.value.id != 1
                      ? Colors.grey
                      : Colors.black,
                ),
                validator: (value) {
                  if (checkOutController.valueChooseDistrict.value.id == 1) {
                    return value == null ? 'field required' : null;
                  }
                  return null;
                },
                value: checkOutController.valueChooseArea.value.id == null
                    ? null
                    : checkOutController.isLoadingDistrict.value
                        ? AreaListModel()
                        : checkOutController.valueChooseArea.value,

                //checkOutController.valueChooseArea.value.id==null?null:checkOutController.valueChooseArea.value,

                /*checkOutController.userData.value.areaId == null ||
                    checkOutController.valueChooseDistrict.value.id != 1
                    ? null
                    : checkOutController.isLoadingArea.value
                    ? AreaListModel()
                    : checkOutController.areaList.value[checkOutController
                    .areaList.value
                    .indexWhere((element) =>
                element.id ==
                    checkOutController.userData.value.areaId)],*/
                onChanged: (AreaListModel? newValue) {
                  checkOutController.valueChooseArea.value = newValue!;

                  checkOutController.fetchShippingMethodId();
                  checkOutController.fetchMyCartData();
                },
                items: checkOutController.areaList.value
                    .map<DropdownMenuItem<AreaListModel>>(
                        (AreaListModel value) {
                  return DropdownMenuItem<AreaListModel>(
                    value: value,
                    child: Text(
                      value.name.toString(),
                      style: TextStyle(
                          color:
                              checkOutController.valueChooseDistrict.value.id !=
                                      1
                                  ? Colors.grey
                                  : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  /*Widget areaDropDown() {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(
            text: "Area",
            size: 12,
            fontWeight: FontWeight.normal,
            align: TextAlign.left,
          ),
          Container(
            color: checkOutController.valueChooseDistrict.value.id != 1
                ? AppColors.bgColorOffLight
                : AppColors.scaffoldBGColor,
            child: IgnorePointer(
              ignoring: checkOutController.valueChooseDistrict.value.id != 1,
              child: DropdownButtonFormField<AreaListModel>(
                isExpanded: true,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelStyle: TextStyle(color: Colors.black),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: checkOutController.valueChooseDistrict.value.id != 1
                      ? Colors.grey
                      : Colors.black,
                ),
                validator: (value) {
                  if (checkOutController.valueChooseDistrict.value.id == 1) {
                    return value == null ? 'field required' : null;
                  }
                  return null;
                },
                value: checkOutController.userData.value.areaId == null ||
                        checkOutController.valueChooseDistrict.value.id != 1
                    ? null
                    : checkOutController.isLoadingArea.value
                        ? AreaListModel()
                        : checkOutController.areaList.value[checkOutController
                            .areaList.value
                            .indexWhere((element) =>
                                element.id ==
                                checkOutController.userData.value.areaId)],
                onChanged: (AreaListModel? newValue) {
                  checkOutController.valueChooseArea.value = newValue!;

                  checkOutController.fetchShippingMethodId();
                  checkOutController.fetchMyCartData();
                },
                items: checkOutController.areaList.value
                    .map<DropdownMenuItem<AreaListModel>>(
                        (AreaListModel value) {
                  return DropdownMenuItem<AreaListModel>(
                    value: value,
                    child: Text(
                      value.name.toString(),
                      style: TextStyle(
                          color:
                              checkOutController.valueChooseDistrict.value.id !=
                                      1
                                  ? Colors.grey
                                  : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }*/

  Widget deliveryAddressSection() {
    return Card(
      elevation: 5,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            activeColor: AppColors.headerTextColor,
            value: checkOutController.isDeliveryAddress.value,
            onChanged: (newValue) {
              checkOutController.isDeliveryAddress.value = newValue!;
              if (!newValue) checkOutController.resetAreaOrCityId();
              checkOutController.fetchShippingMethodId();
              checkOutController.fetchMyCartData();
            },
            controlAffinity: ListTileControlAffinity.leading,
            title: HeaderText(
              text: "I want to set another address for my delivery",
              maxLine: 5,
              align: TextAlign.start,
            ),
          ),
          if (checkOutController.isDeliveryAddress.value) shippingAddresses(),
        ],
      ),
    );
  }

  Widget singleDeliveryAddressSection(int index) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: HeaderText(
                  text: "${checkOutController.addressList.value[index].address}"
                      "${checkOutController.addressList.value[index].area != null && checkOutController.addressList.value[index].area.toString().isNotEmpty ? ", ${(checkOutController.areaList.value[checkOutController.areaList.value.indexWhere((element) => element.id == checkOutController.addressList.value[index].area)].name)}" : ""}"
                      ", ${checkOutController.districtList.value[checkOutController.districtList.value.indexWhere((element) => element.id == checkOutController.addressList.value[index].district)].name}",
                  fontWeight: FontWeight.normal,
                  size: 14,
                  align: TextAlign.start,
                  maxLine: 3,
                ),
              ),

/**/

              /*HeaderText(
                text:
                    "${checkOutController.areaList.value[checkOutController.districtList.value.indexWhere((element)
                    => element.id == checkOutController.addressList.value[index].district)].name}, ",
                fontWeight: FontWeight.normal,
                size: 14,
              ),
              HeaderText(
                text:
                    "${checkOutController.districtList.value[checkOutController.districtList.value.indexWhere((element) => element.id == checkOutController.addressList.value[index].district)].name}",
                fontWeight: FontWeight.normal,
                size: 14,
              ),*/
            ],
          ),
          Row(
            children: [
              Flexible(
                child: HeaderText(
                  text:
                      "${checkOutController.addressList.value[index].firstName} ${checkOutController.addressList.value[index].lastName} - ${checkOutController.addressList.value[index].phone}",
                  fontWeight: FontWeight.normal,
                  size: 14,
                  maxLine: 5,
                  align: TextAlign.start,
                ),
              ),
              /*HeaderText(
                text: "${checkOutController.addressList.value[index].phone}",
                fontWeight: FontWeight.normal,
                size: 12,
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  Widget shippingAddresses() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(15.r),
            child: checkOutController.addressList.value.isNotEmpty
                ? HeaderText(
                    text: "Please select shipping address",
                    size: 14,
                    align: TextAlign.start,
                    color: AppColors.bodyTextColor,
                    fontWeight: FontWeight.normal,
                  )
                : Column(
                    children: [
                      HeaderText(
                        text: "You have no delivery address yet!",
                        size: 15.sp,
                        align: TextAlign.start,
                        color: AppColors.bodyTextColor,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderText(
                        text:
                            "You can add one or more delivery addresses from here...",
                        size: 9.sp,
                        align: TextAlign.start,
                        color: AppColors.bodyTextColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  )),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: checkOutController.addressList.value.length,
          itemBuilder: (buildContext, index) {
            return Obx(
              () => RadioListTile(
                activeColor: AppColors.headerTextColor,
                value: index,
                groupValue: checkOutController.radioAddressValue.value,
                onChanged: (ind) {
                  checkOutController.radioAddressValue.value = ind as int;
                  checkOutController.fetchShippingMethodId();
                  checkOutController.fetchMyCartData();
                },
                title: singleDeliveryAddressSection(index),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: const Divider(
                thickness: .5,
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: const Divider(
            thickness: .5,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15.0.r),
          child: InkWell(
            onTap: () {
              Get.toNamed("/add_delivery_address");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppColors.headerTextColor,
                  size: 16.sp,
                ),
                SizedBox(
                  width: 10.w,
                ),
                HeaderText(
                  text: "ADD MORE ADDRESS",
                  fontWeight: FontWeight.normal,
                  size: 14,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget shippingMethods() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderText(
              text: "Shipping Methods",
              size: 18,
            ),
            SizedBox(
              height: 15.h,
            ),
            ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (buildContext, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HeaderText(
                        text:
                            "${checkOutController.shippingMethods.value[index].name}",
                        fontWeight: FontWeight.normal,
                        maxLine: 5,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      BodyText(
                        text:
                            "${checkOutController.shippingMethods.value[index].title}",
                        maxLine: 5,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      HeaderText(
                        text:
                            "(BDT ${checkOutController.shippingMethods.value[index].amount})",
                        fontWeight: FontWeight.normal,
                        size: 9,
                      ),
                    ],
                  );
                },
                separatorBuilder: (buildContext, index) {
                  return const Divider(
                    thickness: 1,
                  );
                },
                itemCount: checkOutController.shippingMethods.value.length)
          ],
        ),
      ),
    );
  }

  Widget paymentMethod() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: "Payment Methods",
              size: 18,
            ),
            SizedBox(
              height: 15.h,
            ),
            ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (buildContext, index) {
                  return Obx(
                    () =>RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(checkOutController.paymentMethod[index]
                                ['name']
                            .toString()),
                        secondary: Image.asset(
                          checkOutController.paymentMethod[index]['image_1']
                              .toString(),
                        ),
                        value: index,
                        groupValue: checkOutController.paymentMethodRadio.value,
                        onChanged: (nValue) {
                          print(nValue);

                          checkOutController.paymentMethodRadio.value =
                              nValue as int;
                          checkOutController.selectedPaymentMethod.value =
                              checkOutController.paymentMethod[index]['id'];
                          print(checkOutController.selectedPaymentMethod.value);

                          checkOutController.isUpdating.value = true;
                          checkOutController.loadCartData();
                        })
                  );
                },
                separatorBuilder: (buildContext, index) {
                  return const Divider(
                    thickness: 1,
                  );
                },
                itemCount: checkOutController.paymentMethod.length),

            if(checkOutController.myCartList.value.couponData?.total>checkOutController.minimumEMIAmount)const Divider(),
            if(checkOutController.myCartList.value.couponData?.total>checkOutController.minimumEMIAmount)RadioListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(checkOutController.paymentMethodEMI["name"].toString()),
                secondary: Image.asset(
                  checkOutController.paymentMethodEMI['image']
                      .toString(),
                ),
                value: checkOutController.paymentMethod.length,
                groupValue: checkOutController.paymentMethodRadio.value,
                onChanged: (nValue) {
                  checkOutController.paymentMethodRadio.value =
                  nValue as int;
                  checkOutController.selectedPaymentMethod.value =checkOutController.paymentMethodEMI["id"] as int;
                  checkOutController.isUpdating.value = true;
                  checkOutController.loadCartData();
                })
          ],
        ),
      ),
    );
  }

  Widget orderSummarySection() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: "Order Summary",
              size: 18,
            ),
            SizedBox(
              height: 15.h,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (buildContext, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //order summary products
                          Container(
                            margin: EdgeInsets.all(10.r),
                            width: 50.w,
                            child: Image.network(
                              checkOutController
                                      .myCartList.value.cart![index].image ??
                                  "",
                              fit: BoxFit.fill,
                              frameBuilder: (_, image, loadingBuilder, __) {
                                if (loadingBuilder == null) {
                                  return Image.asset(
                                    "assets/images/no-img.jpg",
                                    fit: BoxFit.cover,
                                  );
                                }
                                return image;
                              },
                              loadingBuilder: (context, image, loading) {
                                if (loading == null) {
                                  return image;
                                } else {
                                  return Image.asset("assets/images/no-img.jpg",
                                      fit: BoxFit.cover);
                                }
                              },
                              errorBuilder: (_, __, ___) {
                                return Image.asset("assets/images/no-img.jpg",
                                    fit: BoxFit.cover);
                              },
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (checkOutController.myCartList.value
                                            .cart![index].status ==
                                        0)
                                    ? HeaderText(
                                        text: "Not Available",
                                        color: Colors.red,
                                        size: 15,
                                      )
                                    : (checkOutController.myCartList.value
                                                .cart![index].available ==
                                            0)
                                        ? HeaderText(
                                            text: "Out of stock",
                                            color: Colors.red,
                                            size: 15,
                                          )
                                        : const Text(""),
                                HeaderText(
                                  text: checkOutController
                                      .myCartList.value.cart![index].name
                                      .toString(),
                                  maxLine: 10,
                                  align: TextAlign.start,
                                  size: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 50.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              HeaderText(
                                text:
                                    "৳${((checkOutController.myCartList.value.cart?[index].pPrice!.toDouble())! * (checkOutController.myCartList.value.cart![index].quantity!.toDouble())).toStringAsFixed(2)}",
                                size: 14,
                              ),
                              if (checkOutController.myCartList.value
                                      .cart![index].oldPriceStatus ==
                                  1)
                                Text(
                                  "৳${checkOutController.myCartList.value.cart?[index].price!.toStringAsFixed(2) ?? 0}",
                                  style: TextStyle(
                                      color: AppColors.bodyTextColor,
                                      fontSize: 12.sp,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              BodyText(
                                text:
                                    " (৳${checkOutController.myCartList.value.cart?[index].pPrice!.toStringAsFixed(2) ?? 0}"
                                    " x ${checkOutController.myCartList.value.cart![index].quantity})",
                                size: 12,
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (buildContext, index) => const Divider(
                      thickness: 1,
                    ),
                itemCount:
                    checkOutController.myCartList.value.cart?.length ?? 0),
            if ((checkOutController.myCartList.value.couponData?.name ?? "")
                .isNotEmpty)
              Column(
                children: [
                  const Divider(
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10.r),
                        width: 50.w,
                        child: Image.network(
                          checkOutController
                                  .myCartList.value.couponData?.image ??
                              "",
                          fit: BoxFit.fill,
                          frameBuilder: (_, image, loadingBuilder, __) {
                            if (loadingBuilder == null) {
                              return Image.asset(
                                "assets/images/no-img.jpg",
                                fit: BoxFit.cover,
                              );
                            }
                            return image;
                          },
                          loadingBuilder: (context, image, loading) {
                            if (loading == null) {
                              return image;
                            } else {
                              return Image.asset("assets/images/no-img.jpg",
                                  fit: BoxFit.cover);
                            }
                          },
                          errorBuilder: (_, __, ___) {
                            return Image.asset("assets/images/no-img.jpg",
                                fit: BoxFit.cover);
                          },
                        ),
                      ),
                      Flexible(
                        child: HeaderText(
                          text: checkOutController
                                  .myCartList.value.couponData?.name ??
                              "".toString(),
                          maxLine: 10,
                          align: TextAlign.start,
                          fontWeight: FontWeight.normal,
                          size: 13,
                        ),
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      HeaderText(
                        text: "Free",
                        color: AppColors.mainColorRed,
                      )
                    ],
                  ),
                ],
              ),

            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 20.h,
            ),

            //Cart Rule Section
            if (((checkOutController.myCartList.value.cartRules ?? [])
                    .isNotEmpty) ||
                (checkOutController.cartOfferProductsModule.isNotEmpty))
              cartRuleSection(),

            summarySection()
          ],
        ),
      ),
    );
  }

  Widget summarySection() {
    return Obx(
      () => Container(
        color: Colors.white,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Sub Total",
                  fontWeight: FontWeight.normal,
                  size: 14,
                ),
                HeaderText(
                  text:
                      "৳${checkOutController.myCartList.value.couponData?.subTotal?.toStringAsFixed(2) ?? 0}",
                  fontWeight: FontWeight.normal,
                  size: 14,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: checkOutController.myCartList.value.couponData?.vip == 1
                      ? "Discount (VIP)"
                      : checkOutController.myCartList.value.couponData?.loyal ==
                              1
                          ? "Discount (Loyal)"
                          : "Discount (Regular)",
                  fontWeight: FontWeight.normal,
                ),
                HeaderText(
                  text:
                      "- ৳${checkOutController.myCartList.value.couponData?.regularDiscount?.toStringAsFixed(2) ?? '0.00'}",
                  fontWeight: FontWeight.normal,
                  size: 14,
                ),
              ],
            ),
            if ((checkOutController
                        .myCartList.value.couponData?.couponDiscount ??
                    0) >
                0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderText(
                    text: "Discount (Coupon)",
                    fontWeight: FontWeight.normal,
                    size: 14,
                  ),
                  HeaderText(
                    text:
                        "- ৳${checkOutController.myCartList.value.couponData?.couponDiscount?.toStringAsFixed(2) ?? '0.00'}",
                    fontWeight: FontWeight.normal,
                    size: 14,
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Mobile App Special Discount",
                  fontWeight: FontWeight.normal,
                  size: 14,
                ),
                HeaderText(
                  text:
                      "- ৳${checkOutController.myCartList.value.couponData?.mobileAppSpecialDiscount?.toStringAsFixed(2) ?? '0.00'}",
                  fontWeight: FontWeight.normal,
                  size: 14,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Delivery Charge",
                  fontWeight: FontWeight.normal,
                  size: 14,
                ),
                HeaderText(
                  text:
                      "+ ৳${checkOutController.myCartList.value.couponData?.shipping?.toStringAsFixed(2) ?? '0.00'}",
                  fontWeight: FontWeight.normal,
                  size: 14,
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: .5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Total",
                  fontWeight: FontWeight.bold,
                  size: 22,
                  color: AppColors.mainColorRed,
                ),
                HeaderText(
                  text:
                      "৳${checkOutController.myCartList.value.couponData?.total?.toStringAsFixed(2) ?? '0.00'}",
                  fontWeight: FontWeight.bold,
                  size: 22,
                  color: AppColors.mainColorRed,
                ),
              ],
            ),
            /*SizedBox(
                height: 10.h,
              )*/
          ],
        ),
      ),
    );
  }

  Widget couponSection() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Form(
          key: _formKeyCoupon,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.scaffoldBGColor,
              boxShadow: [
                BoxShadow(
                  color: checkOutController.couponId.isNotEmpty
                      ? AppColors.mainColorRed.withOpacity(.5)
                      : Colors.transparent,
                  spreadRadius: 5,
                  blurRadius: 5,
                  //offset: Offset(3, 3), // changes position of shadow
                ),
              ],
            ),
            child: TextFormField(
              readOnly: checkOutController.couponId.isNotEmpty,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Field must not empty";
                } else {
                  return null;
                }
              },
              controller: checkOutController.couponCodeController,
              // keyboardType: TextInputType.name,
              cursorColor: Colors.green,
              cursorWidth: .5,
              decoration: InputDecoration(
                suffixIcon: checkOutController.couponId.isNotEmpty
                    ? SizedBox(
                        height: 50,
                        width: 120,
                        child: InkWell(
                          onTap: () {
                            if (_formKeyCoupon.currentState!.validate()) {
                              checkOutController.removeCoupon();
                            }
                          },
                          child: const AppButton(
                            radius: 0,
                            text: "Remove Coupon",
                            bgColor: AppColors.mainColorRed,
                            textColor: Colors.white,
                            alignment: MainAxisAlignment.center,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 50,
                        width: 120,
                        child: InkWell(
                          onTap: () {
                            if (_formKeyCoupon.currentState!.validate()) {
                              checkOutController.applyCoupon();
                            }
                          },
                          child: const AppButton(
                            radius: 0,
                            text: "Apply Coupon",
                            bgColor: Colors.green,
                            textColor: Colors.white,
                            //align: TextAlign.center,
                            alignment: MainAxisAlignment.center,
                          ),
                        ),
                      ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                    borderSide: checkOutController.couponId.isNotEmpty
                        ? const BorderSide(
                            color: AppColors.mainColorRed, width: 1.5)
                        : const BorderSide(color: Colors.green, width: 1.5)),
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "Coupon Code",
                labelStyle: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget orderNoteSection() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BodyText(
              text:
                  "If you would like to add any notes or comments about your order please enter them below. ",
              size: 14,
              align: TextAlign.start,
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              color: AppColors.scaffoldBGColor,
              child: TextFormField(
                controller: checkOutController.orderNoteController,
                keyboardType: TextInputType.name,
                cursorColor: AppColors.mainColorRed,
                minLines: 5,
                maxLines: 20,
                cursorWidth: .5,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Order Note",
                  labelStyle: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget termsAndConditionsSection() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 15.w, top: 10.h, bottom: 5.h),
        child: Column(
          children: [
            Html(data: """
            
                <ul>
                <li><p>Security policy (Use a genuine Email Address to avoid any problem and prevent problems while logging in)</p></li>
                <li><p>Delivery policy (Inside Dhaka delivery within 24hrs, Outside Dhaka delivery within 72hrs)</p></li>
                
                <li>Return policy (A user may return any unopened or defective item within 24 hours of receiving the item.)</li>
                </ul>
           """),
            CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.headerTextColor,
                title: Text(
                  "I have read and agree to the terms and conditions",
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 14.sp),
                ),
                subtitle: checkOutController.termsANDConditionCB.value
                    ? BodyText(
                        text: "",
                      )
                    : BodyText(
                        text: "Please Accept Terms & Conditions",
                        color: Colors.red,
                        size: 12,
                        align: TextAlign.start,
                      ),
                value: checkOutController.termsANDConditionCB.value,
                onChanged: (nValue) {
                  checkOutController.termsANDConditionCB.value = nValue!;
                })
          ],
        ),
      ),
    );
  }

  Widget submitButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 50.h,
      child: InkWell(
        onTap: () {
          if (_formKey.currentState!.validate() &&
              checkOutController.termsANDConditionCB.value) {
            checkOutController.saveOrder();
          } else {
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linearToEaseOut);
            ShowSnackBar(msg: 'Some Fields are required.', isSuccess: false)
                .showSnackBar();
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20.r),
            ),
            color: Colors.black,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeaderText(
                text: "Proceed To Confirm",
                color: Colors.white,
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget checkoutBodyContent() {
    return checkOutController.isLoading.value ||
            checkOutController.isLoadingDistrict.value ||
            checkOutController.isLoadingArea.value ||
            (checkOutController.myCartList.value.cart?.length ?? 0) <= 0
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : bodyContent();
  }

  Widget cartRuleSection() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(
            text: "Cart Offers",
            size: 18,
            align: TextAlign.start,
          ),
          SizedBox(
            height: 20.h,
          ),
          if (checkOutController.cartOfferProductsModule.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: checkOutController.cartOfferProductsModule.length,
              itemBuilder: (buildContext, index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10.r),
                          width: 50.w,
                          child: Image.network(
                            checkOutController.cartOfferProductsModule
                                    .value[index].image ??
                                "",
                            fit: BoxFit.fill,
                            frameBuilder: (_, image, loadingBuilder, __) {
                              if (loadingBuilder == null) {
                                return Image.asset(
                                  "assets/images/no-img.jpg",
                                  fit: BoxFit.cover,
                                );
                              }
                              return image;
                            },
                            loadingBuilder: (context, image, loading) {
                              if (loading == null) {
                                return image;
                              } else {
                                return Image.asset("assets/images/no-img.jpg",
                                    fit: BoxFit.cover);
                              }
                            },
                            errorBuilder: (_, __, ___) {
                              return Image.asset("assets/images/no-img.jpg",
                                  fit: BoxFit.cover);
                            },
                          ),
                        ),
                        Flexible(
                          child: HeaderText(
                            text: checkOutController
                                .cartOfferProductsModule[index].name
                                .toString(),
                            maxLine: 10,
                            align: TextAlign.start,
                            fontWeight: FontWeight.normal,
                            size: 13,
                          ),
                        ),
                        SizedBox(
                          width: 50.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            HeaderText(
                              text:
                                  "৳${((checkOutController.cartOfferProductsModule[index].salesPrice?.toDouble()) * (checkOutController.cartOfferProductsModule[index].quantity?.toDouble())).toStringAsFixed(2)}",
                              size: 14,
                            ),
                            Text(
                              "৳${checkOutController.cartOfferProductsModule[index].priceTaxInc?.toStringAsFixed(2) ?? 0}",
                              style: TextStyle(
                                  color: AppColors.bodyTextColor,
                                  fontSize: 12.sp,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            BodyText(
                              text:
                                  " (৳${checkOutController.cartOfferProductsModule[index].salesPrice.toStringAsFixed(2) ?? 0}"
                                  " x ${checkOutController.cartOfferProductsModule[index].quantity})",
                              size: 12,
                            )
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                  ],
                );
              },
            ),
          if ((checkOutController.myCartList.value.cartRules ?? []).isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              itemCount:
                  checkOutController.myCartList.value.cartRules?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (buildContext, index) {
                return Column(
                  children: [
                    Obx(
                      () => CheckboxListTile(
                          activeColor: Colors.blue,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          title: MyAnimatedText(
                            sentence: checkOutController
                                    .myCartList.value.cartRules?[index].title ??
                                "",
                          ),
                          value: checkOutController.selectedCartRuleIds
                              .contains(checkOutController
                                  .myCartList.value.cartRules?[index].id),
                          onChanged: (value) {
                            print(checkOutController
                                .myCartList.value.cartRules?.length);
                            //  checkOutController.isModifiedCartRule = true;
                            if (value ?? true) {
                              checkOutController.removedCartRuleIds.remove(
                                  checkOutController
                                      .myCartList.value.cartRules?[index].id);

                              //  print(myCartController.removedCardRuleIds);

                              checkOutController.selectedCartRuleIds.add(
                                  checkOutController
                                      .myCartList.value.cartRules?[index].id);
                              checkOutController.fetchMyCartData();
                            } else {
                              checkOutController.removedCartRuleIds.add(
                                  checkOutController
                                      .myCartList.value.cartRules?[index].id);
                              checkOutController.selectedCartRuleIds.remove(
                                  checkOutController
                                      .myCartList.value.cartRules?[index].id);
                              checkOutController.fetchMyCartData();
                            }
                          }),
                    ),
                    const Divider(thickness: 1)
                  ],
                )

                    /*Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: .5),
                  ),
                ),
                child: Obx(
                  () => CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: MyAnimatedText(sentence:checkOutController
                          .myCartList.value.cartRules?[index].title ??
                          "" ,),
                      value: checkOutController.selectedCartRuleIds.contains(
                          checkOutController
                              .myCartList.value.cartRules?[index].id),
                      onChanged: (value) {
                        //  checkOutController.isModifiedCartRule = true;
                        if (value ?? true) {
                          checkOutController.removedCartRuleIds.remove(
                              checkOutController
                                  .myCartList.value.cartRules?[index].id);

                          //  print(myCartController.removedCardRuleIds);

                          checkOutController.selectedCartRuleIds.add(
                              checkOutController
                                  .myCartList.value.cartRules?[index].id);
                          checkOutController.fetchMyCartData();
                        } else {
                          checkOutController.removedCartRuleIds.add(
                              checkOutController
                                  .myCartList.value.cartRules?[index].id);
                          checkOutController.selectedCartRuleIds.remove(
                              checkOutController
                                  .myCartList.value.cartRules?[index].id);
                          checkOutController.fetchMyCartData();
                        }
                      }),
                ),
              )*/
                    ;
              },
            )

          /*ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (buildContext, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: checkOutController.otherModule[index].title ?? "",
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                    maxLine: 10,
                    size: 13,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              );
            },
            itemCount: checkOutController.otherModule.length,
          ),*/
        ],
      ),
    );
  }

  scrollDown() {
    _scrollController.animateTo(_scrollController.position.pixels + 200.h,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  scrollUp() {
    _scrollController.animateTo(_scrollController.position.pixels - 200.h,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }
}
