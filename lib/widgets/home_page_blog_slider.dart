import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../constraints/header_text.dart';
import '../../models/home_page_models/home_page_blog_model.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';

class HomePageBlogSlider extends StatelessWidget {
  final List<HomePageBlogsModel> itemList;

 const HomePageBlogSlider({super.key, required this.itemList});
 // CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 20.w),
          child: HeaderText(
            text: "BLOG",
            align: TextAlign.center,
            size: MediaQuery.of(context).orientation == Orientation.portrait
                ? 16.h
                : 16.w,
          ),
        ),
        Container(
          height:
              MediaQuery.of(Get.context!).orientation == Orientation.portrait
                  ? 250.h
                  : 180.w,
          width: Get.width,
          color: AppColors.mainColorRed,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: CarouselSlider(
                   // carouselController: carouselController,
                    items: itemList.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding:  EdgeInsets.symmetric(vertical: 10.h),
                            child: InkWell(
                              onTap: () {
                                //print(i.id);
                                Get.toNamed("/blog_view",
                                    arguments: i.id.toString());
                              },
                              child: Card(
                                clipBehavior: Clip.hardEdge,
                                //borderOnForeground: true,
                                //semanticContainer: false,
                                color: Colors.white,
                                child: Flex(
                                  direction: Axis.vertical,
                                  children: [
                                    Flexible(
                                        // flex: 5,
                                        fit: FlexFit.tight,
                                        child: Image.network(
                                          i.image.toString(),
                                          width:Get.width,
                                          fit: BoxFit.cover,
                                          frameBuilder:
                                              (_, image, loadingBuilder, __) {
                                            if (loadingBuilder == null) {
                                              return Image.asset(
                                                "assets/images/no-img.jpg",
                                                fit: BoxFit.cover,
                                              );
                                            }
                                            return image;
                                          },
                                          loadingBuilder:
                                              (context, image, loading) {
                                            if (loading == null) {
                                              return image;
                                            } else {
                                              return Image.asset(
                                                  "assets/images/no-img.jpg",
                                                  fit: BoxFit.cover
                                              );
                                            }
                                          },
                                        )

                                        /* FadeInImage(
                                          imageErrorBuilder:(context, url, error) => Image.asset('assets/images/no-img.jpg',fit: BoxFit.cover,) ,
                                          placeholderErrorBuilder:  (context, url, error) => Image.asset('assets/images/no-img.jpg',fit: BoxFit.cover,),
                                          fit: BoxFit.fill,
                                          placeholder: const AssetImage('assets/images/no-img.jpg'),
                                          image: NetworkImage(i.image.toString())),*/
                                        ),
                                    SizedBox(
                                        //flex:2,
                                        //fit: FlexFit.tight,
                                        height: 40.h,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: BodyText(
                                            text: i.title.toString(),
                                            maxLine: 2,
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      //height: height,
                      aspectRatio: 1,
                      viewportFraction:.4,
                      initialPage: 1,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      //autoPlayInterval: const Duration(seconds: 5),
                      //autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                      // autoPlayCurve: Curves.fastOutSlowIn,
                      //enlargeCenterPage: true,
                      //onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    )),
              ),
              /* Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: InkWell(
                  onTap: (){
                    carouselController.previousPage();
                  },
                  child: Icon(Icons.arrow_back_ios_outlined,size: 50,color: Colors.blue,),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: InkWell(
                  onTap: (){
                    carouselController.nextPage(duration: Duration(milliseconds: 100),curve: Curves.linearToEaseOut);
                  },
                  child:Icon(Icons.arrow_forward_ios_outlined,size: 50,color: Colors.blue,),
                ),
              ),*/
            ],
          ), /*Stack(
            children: [

              Positioned(
                left: 0,
                  top: 0,
                  bottom: 0,
                  child: Icon(Icons.arrow_back_ios_outlined,size: 50,color: Colors.blue,)),
              Positioned(
                right: 0,
                  top: 0,
                  bottom: 0,
                  child:Icon(Icons.arrow_forward_ios_outlined,size: 50,color: Colors.blue,)),
            ],
          ),*/
        ),
      ],
    );
  }
}
