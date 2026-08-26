import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:themallbd_new/widgets/search_button.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SizedBox(
        width: 100,
        child: InkWell(
          onTap: (){
            Get.toNamed("\home_page");
          },
          child: const Image(image: AssetImage("assets/logo/logo.jpg",),
            fit: BoxFit.contain,
          ),
        ),
      ),
      bottomOpacity: 1,
      primary: true,
      actions:  const [
        SearchButton()
      ],
      actionsIconTheme: const IconThemeData(color: Colors.black),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
