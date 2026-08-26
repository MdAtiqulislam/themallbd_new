import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart'as dom;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../constraints/header_text.dart';
import '../../../controllers/blogs/blog_view_controller.dart';

class BlogView extends StatelessWidget {
  BlogView({super.key});
 //final String searchKey = Get.arguments.toString();

  final BlogViewController blogViewController = Get.put(BlogViewController());

  @override
  Widget build(BuildContext context) {
   // blogViewController.key.value = searchKey;
   // blogViewController.fetchData();
    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          title: Obx(() => HeaderText(text: blogViewController.blogViewData.value.blog?.title??"",color: Colors.white,),)
        ),
        body: Obx(
          () => blogViewController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: Get.width,
                        child: /*FadeInImage(
                          fit: BoxFit.cover,
                          placeholder:
                              const AssetImage("assets/images/no-img.jpg"),
                          image: NetworkImage(blogViewController
                              .blogViewData.value.blogImageUrl
                              .toString()),
                        ),*/
                        Image.network(blogViewController.blogViewData.value.blogImageUrl??"",

                          fit: BoxFit.fill,
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
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderText(text: blogViewController.blogViewData.value.blog!.title.toString(),size: 20,maxLine: 3,align: TextAlign.start,),
                            SizedBox(height: 20.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 50.h,
                                    child: Image.network(blogViewController.blogViewData.value.authorImage.toString(),),),
                                SizedBox(width: 10.w,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HeaderText(text: blogViewController.blogViewData.value.authorName.toString(),),
                                    Text(DateFormat('dd MMM yyyy').format(
                                        blogViewController.blogViewData.value.blog!.createdAt ??
                                            DateTime.now()),),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 15.h,),
                            Html(
                              data: blogViewController.blogViewData.value.blog!.description,
                                onLinkTap: (String? url, //RenderContext context,
                                    Map<String, String> attributes, dom.Element? element) async{

                                  final Uri _url = Uri.parse(url!);
                                  if (!await launchUrl(_url,mode: LaunchMode.externalApplication)) {
                                    throw 'Could not launch $_url';
                                  }
                                }
                            ),
                            Row(
                              children: [
                                HeaderText(text: "SHARE",fontWeight: FontWeight.bold,size: 22,),
                                SizedBox(width: 20.w,),
                                IconButton(
                                  onPressed: (){
                                    blogViewController.shareWith(btnClicked: 'facebook');
                                  },
                                  icon: Image.asset(
                                    "assets/icon/facebook-app-symbol.png",
                                    height:20.h,

                                  )
                                  ,),
                                IconButton(
                                    onPressed:
                                        (){
                                          blogViewController.shareWith(btnClicked: 'twitter');
                                        },
                                  icon: Image.asset(
                                    "assets/icon/twitter.png",
                                    height:20.h,

                                  ),),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
