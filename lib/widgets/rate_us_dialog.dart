import 'package:flutter/material.dart';
import '../../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/header_text.dart';
import 'custom_network_image.dart';

class RateUsDialog extends StatelessWidget {

  final String image;
  final VoidCallback? onTapRateUs;
  final VoidCallback? onTapLater;
  final VoidCallback? onTapAlreadyRated;

  const RateUsDialog({
    required this.image,
    required this.onTapAlreadyRated,
    required this.onTapLater,
    required this.onTapRateUs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: SizedBox(
          //height: 300,
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (image.isNotEmpty)
                Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: AppColors.mainColorRed.withOpacity(.2),
                          blurRadius: 15,
                          offset: const Offset(0, .2))
                    ]),
                    child: CustomNetworkImage(
                      image: image,
                      width: 280,
                    )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/logo/logo.jpg",
                     // height: 60,
                      width: 100,
                    ),
                    const SizedBox(height: 10,),
                    HeaderText(
                      text: "Post a review!".toUpperCase(),
                      size: 20,
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    BodyText(
                      text:
                          "How satisfied are you with the product variety and shopping experience at The Mall?",
                      maxLine: 20,
                      size: 14,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      color: AppColors.mainColorPink,
                      child: InkWell(
                        onTap: onTapRateUs,
                        //splashColor: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 5),
                          //color: AppColors.mainColorPink,
                          child: Column(
                            children: [
                              HeaderText(
                                text: "Rate Us!".toUpperCase(),
                                size: 18,
                                color: Colors.white,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.star_rounded,
                                    color: AppColors.cart_rule_nav_text_color,
                                    size: 14,
                                  ),
                                  Icon(
                                    Icons.star_rounded,
                                    color: AppColors.cart_rule_nav_text_color,
                                    size: 14,
                                  ),
                                  Icon(
                                    Icons.star_rounded,
                                    color: AppColors.cart_rule_nav_text_color,
                                    size: 14,
                                  ),
                                  Icon(
                                    Icons.star_rounded,
                                    color: AppColors.cart_rule_nav_text_color,
                                    size: 14,
                                  ),
                                  Icon(
                                    Icons.star_rounded,
                                    color: AppColors.cart_rule_nav_text_color,
                                    size: 14,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: onTapLater,
                          child: SizedBox(
                           // height: 30,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HeaderText(text: "Later".toUpperCase(),size: 14,),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: onTapAlreadyRated,
                          child: SizedBox(
                           // height: 30,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: HeaderText(
                                    text: "Already Rated".toUpperCase(),size: 14,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
