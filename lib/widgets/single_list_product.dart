import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:themallbd_new/constraints/header_text.dart';

import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';

class SingleListProduct extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String rating;
  final String reviews;
  final int oldPrice;
  final int newPrice;
  final VoidCallback? onTap; // Callback function

  const SingleListProduct({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.oldPrice,
    required this.newPrice,
    this.onTap, // Accept callback as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger callback when the card is tapped
      child: Card(
        color: AppColors.bgColorOffLight,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  height: 100,
                  width: 100,
                  errorWidget: (buildContext, s, d) =>
                      Image.asset('assets/images/no-image_card.jpg'),
                  placeholder: (context, url) =>
                      Image.asset('assets/images/no-image_card.jpg'),
                  imageUrl:imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    HeaderText(
                      text: title,
                      maxLine: 2,
                      align: TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    // Rating and Reviews
                    Padding(
                      padding:
                      EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
                      child: Row(
                        children: [
                          RatingBarIndicator(
                            rating: (5).toDouble(),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: AppColors.mainColorPink,
                            ),
                            itemCount: 5,
                            itemSize: 10.0.sp,
                            direction: Axis.horizontal,
                          ),
                          BodyText(
                              text: "(${5} Reviews)", align: TextAlign.start)
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Row(
                      children: [
                       if(oldPrice!=newPrice) Text(
                          "৳$oldPrice",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "৳$newPrice",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
