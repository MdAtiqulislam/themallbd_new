import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

import '../../constraints/app_colors.dart';

class ImageSlider extends StatelessWidget {
  final List images;
  final bool autoPlay;
  final double height;
  final bool showInnerDotIndicator;

  ImageSlider(
      {Key? key,
      this.autoPlay = true,
      this.height = 400.0,
      required this.images,
      this.showInnerDotIndicator = true})
      : super(key: key);
  var dotPosition = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
                items: images.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          color: Colors.white,
                          width: Get.width,
                          child: Image.network(
                            i ?? "",
                            fit: BoxFit.cover,
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
                          )

                          /* FadeInImage(
                          fadeInDuration: Duration(milliseconds: 100),
                          fadeOutDuration: Duration(milliseconds: 100),
                          imageErrorBuilder:(context, url, error) => Image.asset('assets/images/no-img.jpg',fit: BoxFit.cover,) ,

                          placeholderErrorBuilder:  (context, url, error) => Image.asset('assets/images/no-img.jpg',fit: BoxFit.cover,),
                          fit: BoxFit.cover,
                            placeholder: const AssetImage('assets/images/no-img.jpg'),
                            image: NetworkImage(i??""),),*/
                          );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  onPageChanged: (i, r) {
                    dotPosition.value = i;
                  },
                  height: height,
                  // aspectRatio: 0,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: autoPlay,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  //enlargeCenterPage: true,
                  //onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                )),
            Positioned(
              bottom: 0,
              width: Get.width,
              child: Visibility(
                  visible: showInnerDotIndicator, child: dotIndicator_2()),
            )
          ],
        ),
        Visibility(visible: !showInnerDotIndicator, child: dotIndicator()),
      ],
    );
  }

  Widget dotIndicator_2() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: DotsIndicator(
            mainAxisAlignment: MainAxisAlignment.center,
            dotsCount: images.isEmpty ? 1 : images.length,
            position: dotPosition.toDouble(),
            decorator: DotsDecorator(
              activeColor: AppColors.mainColorRed,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget dotIndicator() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: DotsIndicator(
              mainAxisAlignment: MainAxisAlignment.center,
              dotsCount: images.isEmpty ? 1 : images.length,
              position: dotPosition.toDouble(),
              decorator: DotsDecorator(
                activeColor: AppColors.mainColorRed,
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
