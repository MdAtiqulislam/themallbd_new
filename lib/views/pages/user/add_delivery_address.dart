import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constraints/app_colors.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/add_delivery_address_controller.dart';
import '../../../models/area_list_model.dart';
import '../../../models/district_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';

class AddDeliveryAddressPage extends StatelessWidget {
  AddDeliveryAddressPage({super.key});
  final AddDeliveryAddressController addDeliveryAddressController = Get.put(
    AddDeliveryAddressController(),
  );

  // final UserDetailsController userDetailsController=Get.put(UserDetailsController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          centerTitle: true,
          title: HeaderText(
            text: "Add Delivery Address",
            color: Colors.white,
          ),
        ),
        bottomNavigationBar:  CustomBottomNavigationBar(),
        body: Obx(() => bodyContent()),
      ),
    );
  }

  Widget bodyContent() {
    return Stack(
      children: [
        SingleChildScrollView(child: updateAddressForm()),
        if (addDeliveryAddressController.isLoading.value)
          Container(
            height: Get.height,
            width: Get.width,
            color: Colors.grey.withOpacity(.5),
            child: const Center(child: CircularProgressIndicator(),),
          )
      ],
    );
  }

  Widget updateAddressForm() {
    return Padding(
      padding:  EdgeInsets.all(10.r),
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(5.r),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                  child: HeaderText(
                    text: "Enter Your New Delivery Address",
                    fontWeight: FontWeight.normal,
                    size: 14,
                  ),
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
                    if (!addDeliveryAddressController.isLoadingDistrict.value)
                      Expanded(child: Container(child: cityDropDown())),
                    SizedBox(
                      width: 10.w,
                    ),
                    if (!addDeliveryAddressController.isLoadingArea.value && addDeliveryAddressController.valueChooseDistrict.value.id==1)
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
                        addDeliveryAddressController.addAddress();
                      }
                    },
                    child: AppButton(
                      alignment: MainAxisAlignment.center,
                      text: 'Done',
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
            controller: addDeliveryAddressController.firstNameController,
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
            controller: addDeliveryAddressController.lastNameController,
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
            maxLength: 11,
            controller: addDeliveryAddressController.phoneController,
            textAlignVertical: TextAlignVertical.center,
            //initialValue: userDetailsController.userData.value.phone,
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
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.mainColorPink),
              ),
              //focusedBorder: InputBorder.none,
             // enabledBorder: InputBorder.none,
             // errorBorder: InputBorder.none,
             // disabledBorder: InputBorder.none,

              hintText: "Mobile Number",
              labelStyle: TextStyle(color: Colors.black),

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
            controller: addDeliveryAddressController.addressController,
            // initialValue: userDetailsController.userData.value.address,
            validator: (value) {
              if (value!.isEmpty) {
                return "Address is required";
              } else {
                return null;
              }
            },
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
            hint: Text("City"),
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
            /*value: addDeliveryAddressController.userData.value.cityId == null
                ? null
                : userDetailsController.isLoadingDistrict.value
                    ? DistrictListModel()
                    : userDetailsController.districtList.value[
                        userDetailsController
                            .districtList.value
                            .indexWhere((element) =>
                                element.id ==
                                userDetailsController.userData.value.cityId)],*/
            onChanged: (DistrictListModel? newValue) {
              addDeliveryAddressController.valueChooseDistrict.value =
                  newValue!;
            },
            items: addDeliveryAddressController.districtList.value
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
            color:
                addDeliveryAddressController.valueChooseDistrict.value.id != 1
                    ? AppColors.bgColorOffLight
                    : AppColors.scaffoldBGColor,
            child: IgnorePointer(
              ignoring:
                  addDeliveryAddressController.valueChooseDistrict.value.id !=
                      1,
              child: DropdownButtonFormField<AreaListModel>(
                hint: Text("Area"),
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
                  color: addDeliveryAddressController
                              .valueChooseDistrict.value.id !=
                          1
                      ? Colors.grey
                      : Colors.black,
                ),
                validator: (value) {
                  if(addDeliveryAddressController.valueChooseDistrict.value.id==1) {
                    return value == null ? 'field required' : null;
                  }
                  return null;
                },
                /* value: userDetailsController.userData.value.areaId == null
                      ? null
                      : userDetailsController.isLoadingArea.value
                          ? AreaListModel()
                          : userDetailsController.areaList.value[
                              userDetailsController.areaList.value.indexWhere(
                                  (element) =>
                                      element.id ==
                                      userDetailsController
                                          .userData.value.areaId)],*/
                onChanged: (AreaListModel? newValue) {
                  addDeliveryAddressController.valueChooseArea.value =
                      newValue!;
                },
                items: addDeliveryAddressController.areaList.value
                    .map<DropdownMenuItem<AreaListModel>>(
                        (AreaListModel value) {
                  return DropdownMenuItem<AreaListModel>(
                    value: value,
                    child: Text(
                      value.name.toString(),
                      style: TextStyle(
                          color: addDeliveryAddressController
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
      ),
    );
  }
}
