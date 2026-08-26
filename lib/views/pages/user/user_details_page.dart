import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../constraints/app_colors.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/user_details_controller.dart';
import '../../../models/area_list_model.dart';
import '../../../models/district_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';

class UserDetailsPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserDetailsPage({super.key});

  final UserDetailsController userDetailsController =
      Get.put(UserDetailsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: HeaderText(
            text: "USER DETAILS",
            color: Colors.white,
          ),
        ),
        bottomNavigationBar:  CustomBottomNavigationBar(),
        body: Obx(
          () => userDetailsController.isLoading.value ||
                  userDetailsController.isLoadingDistrict.value ||
                  userDetailsController.isLoadingArea.value
              ? const Center(child: CircularProgressIndicator(),)//AccountDetailPageShimmer()
              : bodyContent(),
        ),
      ),
    );
  }

  Widget bodyContent() {
    return Stack(
      children: [
    SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          children: [
            userProfileSection(),
            SizedBox(
              height: 20.h,
            ),
            if(userDetailsController.emailController.text.isNotEmpty)passwordResetSection(),
            SizedBox(
              height: 20.h,
            ),
            deliveryAddressSection(),
          ],
        ),
      ),
    ),
    if (userDetailsController.isUpdating.value)
      Container(
          color: Colors.grey.withOpacity(.5),
          height: Get.height,
          width: Get.width,
          child: const Center(
            child: CircularProgressIndicator(),
          ))
      ],
    );
  }

  Widget userProfileSection() {
    return Card(
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Form(
          key: _formKey,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Container(child: genderDropDown())),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(child: Container(child: dateOfBirthTextField())),
                ],
              ),
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
                  if (!userDetailsController.isLoadingDistrict.value)
                    Expanded(child: Container(child: cityDropDown())),
                  SizedBox(
                    width: 10.w,
                  ),
                  if (!userDetailsController.isLoadingArea.value && userDetailsController.valueChooseDistrict.value.id==1)
                    Expanded(child: Container(child: areaDropDown())),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              SizedBox(
                height: 50.h,
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      userDetailsController.updateUserInfo();
                    }
                  },
                  child: AppButton(
                    alignment: MainAxisAlignment.center,
                    text: 'Update Profile',
                    textColor: Colors.white,
                    bgColor: Colors.black,
                    align: TextAlign.center,
                    textSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            controller: userDetailsController.firstNameController,
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
            controller: userDetailsController.lastNameController,
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
            controller: userDetailsController.emailController,
            readOnly: userDetailsController.emailController.text.isNotEmpty,
            // initialValue: userDetailsController.userData.value.email,
            validator: (value) {
              if (value!.isEmpty) {
                return "E-mail is required";
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
            readOnly: userDetailsController.phoneController.text.length==11,
            controller: userDetailsController.phoneController,
            //initialValue: userDetailsController.userData.value.phone,
            textAlignVertical: TextAlignVertical.center,
            validator: (value) {
              if(value!.length>2&&
                  (value.isEmpty||
                      !value.startsWith("0")||
                      value[1]!="1"||
                      value[2]=="1"||
                      value[2]=="2"||
                      !value.isNumericOnly||
                      value.length<11) ) {
                return 'Please enter valid phone number';
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration:  InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            // focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.mainColorRed)),
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

  Widget genderDropDown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "Gender",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          color: AppColors.scaffoldBGColor,
          child: DropdownButtonFormField<String>(
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
            value: userDetailsController.gender.value.isNotEmpty
                ? userDetailsController.gender.value.toUpperCase()
                : null,
            onChanged: (String? newValue) {
              userDetailsController.gender.value = newValue!;
            },
            items: ["MALE", "FEMALE"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget dateOfBirthTextField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(
          text: "Date of Birth",
          size: 12,
          fontWeight: FontWeight.normal,
          align: TextAlign.left,
        ),
        Container(
          color: AppColors.scaffoldBGColor,
          child: TextFormField(
            readOnly: true,
            // initialValue: userDetailsController.userData.value.dob,
            controller: userDetailsController.dateInputController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Date of Birth is required";
              } else {
                return null;
              }
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Date of Birth",
              labelStyle: TextStyle(color: Colors.black),
            ),
            onTap: () async {
              userDetailsController.pickDate();
            },
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
            controller: userDetailsController.addressController,
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
            value: userDetailsController.userData.value.cityId == null
                ||userDetailsController.userData.value.cityId.toString().isEmpty
                ? null
                : userDetailsController.isLoadingDistrict.value
                    ? DistrictListModel()
                    : userDetailsController.districtList.value[
                        userDetailsController
                            .districtList.value
                            .indexWhere((element) =>
                                element.id ==
                                userDetailsController.userData.value.cityId)],
            onChanged: (DistrictListModel? newValue) {
              userDetailsController.valueChooseDistrict.value = newValue!;
            },
            items: userDetailsController.districtList.value
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

  Widget areaDropDown() {
    return Obx(() => Column(
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
              color: userDetailsController.valueChooseDistrict.value.id != 1
                  ? AppColors.bgColorOffLight
                  : AppColors.scaffoldBGColor,
              child: IgnorePointer(
                ignoring:
                    userDetailsController.valueChooseDistrict.value.id != 1,
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
                    color:
                        userDetailsController.valueChooseDistrict.value.id != 1
                            ? Colors.grey
                            : Colors.black,
                  ),
                  validator: (value) {
                    if(userDetailsController.valueChooseDistrict.value.id==1){
                      return value == null ? 'field required' : null;
                    }
                    return null;
                  },
                  value: userDetailsController.userData.value.areaId == null||
                      userDetailsController.userData.value.areaId.toString().isEmpty||
                    userDetailsController.valueChooseDistrict.value.id!=1
                      ? null
                      : userDetailsController.isLoadingArea.value
                          ? AreaListModel()
                          : userDetailsController.areaList.value[
                              userDetailsController.areaList.value.indexWhere(
                                  (element) =>
                                      element.id ==
                                      userDetailsController
                                          .userData.value.areaId)],
                  onChanged: (AreaListModel? newValue) {
                    userDetailsController.valueChooseArea.value = newValue!;
                  },
                  items: userDetailsController.areaList.value
                      .map<DropdownMenuItem<AreaListModel>>(
                          (AreaListModel value) {
                    return DropdownMenuItem<AreaListModel>(
                      value: value,
                      child: Text(
                        value.name.toString(),
                        style: TextStyle(
                            color: userDetailsController
                                        .valueChooseDistrict.value.id !=
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
        ));
  }

  Widget passwordResetSection() {
    return InkWell(
      onTap: () {
        Get.toNamed("/password_reset_page");
      },
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(15.0.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderText(
                text: "Change Your Password",
                fontWeight: FontWeight.normal,
              ),
              HeaderText(
                text: "######",
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget deliveryAddressSection() {
    return Obx(() => Card(
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.only(left: 15.w,top:10.h),
            child: HeaderText(
              text: "DELIVERY ADDRESS:",
              size: 16,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.r),
                  child: HeaderText(
                    text: "You can change your default delivery address",
                    size: 14,
                    align: TextAlign.start,
                    color: AppColors.bodyTextColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userDetailsController.addressList.value.length,
                    itemBuilder: (buildContext, index) {
                      return InkWell(
                        onTap: () async {
                          await Get.defaultDialog(
                            title: "Confirmation",
                            middleText:
                            "Are you sure you want to add this as primary address?",
                            backgroundColor: Colors.white,
                            titleStyle: const TextStyle(color: Colors.black),
                            middleTextStyle:
                            const TextStyle(color: AppColors.bodyTextColor),
                            textConfirm: "Confirm",
                            textCancel: "Cancel",
                            cancelTextColor: Colors.black,
                            confirmTextColor: Colors.black,
                            buttonColor: Colors.grey,
                            barrierDismissible: false,
                            radius: 5,
                            onConfirm: () async {
                              Get.back();
                              userDetailsController.updateDeliveryAddress(userDetailsController.addressList.value[index]);
                              userDetailsController.fetchUserData();

                            },
                            //onCancel: () => Get.back(),
                          );

                          //
                        },
                        child: singleDeliveryAddressSection(index),
                      );
                    }),
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
            ),
          )
        ],
      ),
    ));
  }

  Widget singleDeliveryAddressSection(int index) {
    return Obx(() => Container(
      decoration: BoxDecoration(
          border: const Border(
            bottom: BorderSide(color: Colors.grey, width: .5),
          ),
          color:
          userDetailsController.addressList.value[index].primaryAddress == 1
              ? Colors.grey.withOpacity(.5)
              : Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child:HeaderText(
                    text:
                    "${userDetailsController.addressList.value[index].address}"
                        "${userDetailsController.addressList.value[index].area!=null&& userDetailsController.addressList.value[index].
                    area.toString().isNotEmpty
                        ?", ${(userDetailsController.areaList.value[userDetailsController.areaList.value.indexWhere((element)=> element.id == userDetailsController.addressList.value[index].area)].name)}"
                        :""}"
                        ", ${userDetailsController.districtList.value[userDetailsController.districtList.value.indexWhere((element)
                    => element.id == userDetailsController.addressList.value[index].district)].name}",
                    fontWeight: FontWeight.normal,
                    size: 14,
                    align: TextAlign.start,
                    maxLine: 3,
                  ),


                  /* HeaderText(
                    text:
                    "${userDetailsController.addressList.value[index].address}, "
                        "${userDetailsController.areaList.value[userDetailsController.districtList.value.
                    indexWhere((element) => element.id == userDetailsController.addressList.value[index].district)].name}, "
                        "${userDetailsController.districtList.value[userDetailsController.districtList.value.
                    indexWhere((element) => element.id == userDetailsController.addressList.value[index].district)].name}",
                    fontWeight: FontWeight.normal,
                    size: 14,
                    maxLine: 2,
                    align: TextAlign.start,
                  ),*/
                ),

              ],
            ),
            Row(
              children: [
                HeaderText(
                  text:
                  "${userDetailsController.addressList.value[index].firstName} ${userDetailsController.addressList.value[index].lastName} - ",
                  fontWeight: FontWeight.normal,
                  size: 14,
                ),
                HeaderText(
                  text:
                  "${userDetailsController.addressList.value[index].phone}",
                  fontWeight: FontWeight.normal,
                  size: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
