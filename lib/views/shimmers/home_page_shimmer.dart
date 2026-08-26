import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:themallbd_new/views/shimmers/product_grid_shimmer.dart';
import 'package:themallbd_new/views/shimmers/shimmer_skeleton.dart';



import '../../constraints/header_text.dart';

class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                ShimmerSkeleton(width: Get.width, height: 250.h,
                ),
                Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: SizedBox(

                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.r),),),
                          ),
                          SizedBox(width: 10.w,),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50.r),),),
                          ),
                          SizedBox(width: 10.w,),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50.r),),),
                          ),
                          SizedBox(width: 10.w,),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50.r),),),
                          ),
                          SizedBox(width: 10.w,),
                        ],
                      ),
                    ))
              ],
            ),
            Container(
              color: Colors.tealAccent.withOpacity(.2),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).orientation == Orientation.portrait
                      ? 40.h
                      : 20.w,
                ),
                child: HeaderText(
                  text: 'SHOP BY SKIN TYPE',
                  align: TextAlign.center,
                  size: MediaQuery.of(context).orientation == Orientation.portrait
                      ? 16.h
                      : 16.w,
                ),
              ),
            ),
            Container(
              color: Colors.tealAccent.withOpacity(.2),
              child: GridView.builder(
                  padding:
                      const EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 30),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                            child: ShimmerSkeleton(
                          height: 100.w,
                          width: 100.w,
                        )),
                        SizedBox(
                          height: 5.h,
                        ),
                        ShimmerSkeleton(
                          width: 70.w,
                          height: 20.h,
                        ),
                      ],
                    );
                  }),
            ),
            Container(
              color: Colors.white,
              child: GridView.builder(
                  padding:
                      EdgeInsets.only(left: 20.w, right: 20.w, top: 30.h, bottom: 30.h),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    //childAspectRatio: .7

                    /*
                               */ /*MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.3)*/
                  ),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Card(
                          child: ShimmerSkeleton(width: 80, height: 80),
                        )),
                      ],
                    );
                  }),
            ),
            const ProductGridShimmer(text:"Back In Stock"),
            const ProductGridShimmer(text: "New Arrival"),
            const ProductGridShimmer(text: "BestSeller"),
            const ProductGridShimmer(text: "Baby Care"),
            const ProductGridShimmer(text: "Life Style"),
            const ProductGridShimmer(text: "Exclusive Sale"),
          ],
        ),
      ),
    );
  }

  Widget productList(BuildContext c, String s) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20.0.h),
          child: Center(
            child: HeaderText(
              text: s,
              align: TextAlign.center,
              size: MediaQuery.of(c).orientation == Orientation.portrait
                  ? 16.h
                  : 16.w,
            ),
          ),
        ),
        Stack(
          children: [
            //image
            SizedBox(
              width: MediaQuery.of(c).size.width,
              child: Image.asset(
                "assets/images/no-img.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: MediaQuery.of(c).orientation == Orientation.portrait
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
