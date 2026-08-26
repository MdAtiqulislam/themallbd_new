import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/blog_models/blog_auto_scroo_slider_model.dart';

class BlogAutoScrollSlider extends StatelessWidget {
  final List<BlogAutoScrollSliderModel> itemList;

  const BlogAutoScrollSlider({super.key, required this.itemList});
 // CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height:MediaQuery.of(Get.context!).orientation==Orientation.portrait? 50.h:50.w,
          width: Get.width,
          child: CarouselSlider(
            //  carouselController: carouselController,
              items: itemList.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () async {
                        //print(i.id);



                      //  String url="fb://facewebmodal/f?href=https://www.facebook.com/sharer/sharer.php?u=${blogViewData.value.shareUrl}";
                        final Uri _url = Uri.parse(i.url??"");
                        try {
                          if (!await launchUrl(_url,mode: LaunchMode.externalApplication)) {
                        throw 'Could not launch $_url';
                        }
                        } on Exception catch (e) {
                        if (kDebugMode) {
                        print(e);
                        }
                        }





                       // Get.toNamed("/blog_view", arguments: i.id.toString());
                      },
                      child: Image.network(
                        i.image.toString(),
                        fit:BoxFit.cover,
                        frameBuilder: (_, image, loadingBuilder, __) {
                          if (loadingBuilder == null) {
                            return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
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

                      /*FadeInImage(
                          imageErrorBuilder:(context, url, error) => Image.asset('assets/images/no-img.jpg',fit: BoxFit.cover,) ,
                          placeholderErrorBuilder:  (context, url, error) => Image.asset('assets/images/no-img.jpg',fit: BoxFit.cover,),
                          fit: BoxFit.fill,
                          placeholder: const AssetImage('assets/images/no-img.jpg'),
                          image: NetworkImage(i.image.toString()))*/
                      ,
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
               // aspectRatio: .1,
                viewportFraction: Get.width>400&&MediaQuery.of(Get.context!).orientation!=Orientation.landscape?0.08:0.12,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                autoPlayCurve: Curves.fastOutSlowIn,
                //enlargeCenterPage: true,
                //onPageChanged: callbackFunction,
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.antiAlias
              )), /*Stack(
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
