import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:themallbd_new/views/shimmers/shimmer_skeleton.dart';
import '../../constraints/header_text.dart';

class ProductGridShimmer extends StatelessWidget {
 final String text;
 final bool image;
   const ProductGridShimmer({super.key,required this.text,this.image=true});

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       if(text.isNotEmpty) Padding(
          padding: EdgeInsets.all(20.0.h),
          child: Center(
            child: HeaderText(
              text: text,
              align: TextAlign.center,
              size: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 16.h
                  : 16.w,
            ),
          ),
        ),
        Stack(
          children: [
            //image
            if(image)SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/images/no-img.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(image)SizedBox(
                    height: MediaQuery.of(context).orientation == Orientation.portrait
                        ? 167.h
                        : 167.w),
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.w),
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          childAspectRatio: .5),
                      itemCount: 20,
                      //homePageDataController.homePageBackInStock.value.products!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Flex(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            direction: Axis.vertical,
                            children: [
                              const Flexible(
                                  flex: 10,
                                  fit: FlexFit.tight,
                                  child: ShimmerSkeleton()),
                              Flexible(
                                flex: 9,
                                fit: FlexFit.tight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ShimmerSkeleton(
                                        height: 20,
                                        width: 100.w,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ShimmerSkeleton(
                                        height: 20,
                                        width: 130.w,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ShimmerSkeleton(
                                        height: 20,
                                        width: 150.w,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ShimmerSkeleton(
                                        height: 20,
                                        width: 120.w,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
