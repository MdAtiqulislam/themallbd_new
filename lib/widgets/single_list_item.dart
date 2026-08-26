import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../constraints/app_colors.dart';
import '../constraints/header_text.dart';
import 'my_animated_text.dart';

class SingleListItem extends StatelessWidget {
  final String image;
  final String title;
  final Widget trailing;
  final String? subTitle;


  const SingleListItem(
      {super.key,
      required this.image,
      required this.title,
      this.trailing = const Text(""),
      this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 80.h,
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.mainColorRed,
              backgroundImage: CachedNetworkImageProvider(image),
            ),

            /*CachedNetworkImage(
              imageUrl: image,
              imageBuilder: (context, imageProvider) => Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.fill),
                ),
              ),
              placeholder: (context, url) => Image.asset("assets/images/lazy.png"),
              errorWidget: (context, url, error) => Image.asset("assets/images/lazy.png"),
            ),*/
            /*onForegroundImageError: (o,c)=>AssetImage("assets/images/lazy.png"),
              foregroundImage: CachedNetworkImageProvider(image),),*/
            title: HeaderText(
              text: title,
              align: TextAlign.start,
            ),
            subtitle: (subTitle != null)
                ? MyAnimatedText(sentence: subTitle??"")/*BodyText(
                    text: subTitle ?? "",
                    color: AppColors.cart_rule_text_color,
                    align: TextAlign.start,
                  )*/
                : null,
            trailing: trailing,
          ),
        ),
      ),
    );
  }
}
