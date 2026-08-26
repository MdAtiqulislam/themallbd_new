import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constraints/app_colors.dart';
import '../../../constraints/body_text.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/blogs/beauty_feed_pagination_controller.dart';
import '../../../controllers/blogs/blog_view_controller.dart';
import '../../../widgets/circuler_button.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';
import '../../../widgets/custom_drawer.dart';
import 'blog_auto_scroll_slider.dart';

class BeautyFeedPagination extends StatelessWidget {
  BeautyFeedPagination({super.key});
  final BeautyFeedPaginationController beautyFeedController =
      Get.put(BeautyFeedPaginationController());

  var selectedIndex = 0.obs;
  var showClearFilter = 0.obs;
  final ScrollController _scrollController = ScrollController();
  var currentPosition=0.0.obs;

  @override
  Widget build(BuildContext context) {
    selectedIndex.value = -1;
    _scrollController.addListener(() {
      loadMoreData();
    });
    return portrait();
  }

  Widget headerSlider() {
    return Obx(
      () => Container(
        //height: 0.h,
        child: beautyFeedController.isLoadingBlogAutoScrollData.value
            ? const Text("")
            : BlogAutoScrollSlider(
                itemList: beautyFeedController.autoScrollSliderData ?? [],
              ),
      ),
    );
  }

  Widget blogCategories() {
    return SizedBox(
      height: 60,
      child: Obx(
        () => beautyFeedController.isLoadingBlogCategoryData.value
            ? const Text("")
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        selectedIndex.value = -1;
                        showClearFilter.value = 0;
                        beautyFeedController.fetchBlogData();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: AnimatedContainer(
                          decoration: selectedIndex.value == -1
                              ? BoxDecoration(
                                  color: Colors.white,
                                  border: const Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 5), // changes position of shadow
                                    ),
                                  ],
                                )
                              : const BoxDecoration(
                                  color: AppColors.scaffoldBGColor),
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(milliseconds: 500),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0.w, vertical: 15.h),
                            child: const Center(
                              child: Text("Home"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          beautyFeedController.blogCategoriesData?.length ?? 0,
                      itemBuilder: (builderContext, index) {
                        return InkWell(
                          onTap: () {
                            selectedIndex.value = index;
                          },
                          child: Obx(
                            () => Row(
                              children: [
                                if (index > 0 &&
                                    index <
                                        beautyFeedController
                                            .blogCategoriesData!.length)
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0.h),
                                    child: Container(
                                      width: .5,
                                      color: Colors.grey,
                                    ),
                                  ),
                                InkWell(
                                  onTap: () {
                                    selectedIndex.value = index;
                                    showClearFilter.value = 1;
                                    beautyFeedController.key.value =
                                        beautyFeedController
                                            .blogCategoriesData![index].slug
                                            .toString();
                                    beautyFeedController
                                        .fetchFilteredBlogData();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: AnimatedContainer(
                                      decoration: index == selectedIndex.value
                                          ? BoxDecoration(
                                              color: Colors.white,
                                              border: const Border(
                                                bottom: BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            )
                                          : const BoxDecoration(
                                              color: AppColors.scaffoldBGColor),
                                      curve: Curves.fastOutSlowIn,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0.w, vertical: 15.h),
                                        child: Center(
                                          child: Text(
                                            beautyFeedController
                                                .blogCategoriesData![index].name
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget filterSection() {
    return Obx(
      () => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: .5),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (beautyFeedController.isLoadingBlogData.value)
                  ? const Text("")
                  : HeaderText(
                      text:
                          "${beautyFeedController.blogData.value.length} of ${beautyFeedController.blogPaginationModel.value.total} Articles",
                      color: Colors.grey,
                    ),
              if (showClearFilter.value == 1)
                InkWell(
                  onTap: () {
                    showClearFilter.value = 0;
                    selectedIndex.value = -1;
                    beautyFeedController.fetchBlogData();
                  },
                  child: HeaderText(
                    text: "Clear Filter",
                    color: AppColors.mainColorRed,
                    fontWeight: FontWeight.normal,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget blogDataPortrait() {
    return Obx(
      () => beautyFeedController.isLoadingBlogData.value
          ? const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (buildContext, index) {
                  return Card(
                    margin:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () {
                        Get.put(BlogViewController()).key.value=beautyFeedController.blogData.value[index].slug!;
                        Get.find<BlogViewController>().fetchData();
                        Get.toNamed('/blog_view');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*FadeInImage(
                            placeholder:
                                const AssetImage("assets/images/no-img.jpg"),
                            image: NetworkImage(
                              beautyFeedController.blogData.value[index].image
                                  .toString(),
                            ),
                          ),*/
                          Image.network(beautyFeedController.blogData.value[index].image??"",

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
                          Padding(
                            padding: EdgeInsets.all(20.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  beautyFeedController
                                      .blogData.value[index].categoryName
                                      .toString(),
                                  style: const TextStyle(
                                      color: AppColors.mainColorRed),
                                  textAlign: TextAlign.start,
                                ),
                                HeaderText(
                                  text: beautyFeedController
                                      .blogData.value[index].title
                                      .toString(),
                                  size: 20,
                                  align: TextAlign.start,
                                  maxLine: 4,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                childCount: beautyFeedController.blogData.value.length,

              ),
            ),
    );
  }

  Widget blogDataLandScape() {
    return Obx(
      () => beautyFeedController.isLoadingBlogData.value
          ? const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (buildContext, index) {
                  return Card(
                    margin:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed("/blog_view",
                            arguments:
                            beautyFeedController.blogData.value[index].id);
                      },
                      child: Flex(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        direction: Axis.horizontal,
                        children: [
                          /*FadeInImage(
                            width: Get.width * .6,
                            fit: BoxFit.cover,
                            placeholder:
                                const AssetImage("assets/images/no-img.jpg"),
                            image: NetworkImage(
                              beautyFeedController.blogData.value[index].image
                                  .toString(),
                            ),
                          ),*/
                          Image.network(beautyFeedController.blogData.value[index].image??"",

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
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.all(10.0.r),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    beautyFeedController
                                        .blogData.value[index].categoryName
                                        .toString(),
                                    style: const TextStyle(
                                        color: AppColors.mainColorRed),
                                    textAlign: TextAlign.start,
                                  ),
                                  HeaderText(
                                    text: beautyFeedController
                                        .blogData.value[index].title
                                        .toString(),
                                    size: 20,
                                    align: TextAlign.start,
                                    maxLine: 4,
                                  ),
                                  BodyText(
                                    text: beautyFeedController
                                        .blogData.value[index].title
                                        .toString(),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: MaterialButton(
                                        onPressed: () {
                                          Get.toNamed("/blog_view",
                                              arguments: beautyFeedController
                                                  .blogData.value[index].id);
                                        },
                                        color: AppColors.mainColorRed,
                                        textColor: Colors.white,
                                        child: const Text("Read More"),
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                childCount: beautyFeedController.blogData.value.length,

              ),
            ),
    );
  }

  Widget bodyContent() {
    return Obx(() => CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            width: Get.width,
            child: Image.asset("assets/images/beautyfeed_images.jfif"),
          ),
        ),
        SliverToBoxAdapter(child: headerSlider()),
        SliverToBoxAdapter(child: blogCategories()),
        SliverToBoxAdapter(child: filterSection()),
        blogDataPortrait(),
      ],
    ));
  }

  Widget landscape() {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        title: Center(
          child: HeaderText(
            text: "Beauty Feed",
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        /*actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],*/
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              width: Get.width,
              child: Image.asset(
                "assets/images/beautyfeed_images.jfif",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(child: headerSlider()),
          SliverToBoxAdapter(child: blogCategories()),
          SliverToBoxAdapter(child: filterSection()),
          blogDataLandScape(),
         /* if (beautyFeedController.isLoadingMore.value)
            SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColorRed,
                ),
              ),
            )*/
        ],
      ),
    );
  }

  Widget portrait() {
    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
         /*backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: HeaderText(
            text: "Beauty Feed",
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
          /* actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ))
          ],*/
        ),
        drawer: CustomDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    color:Colors.red,
                    width: Get.width,
                    child: Image.asset("assets/images/beautyfeed_images.jfif",fit: BoxFit.cover,),
                  ),
                ),
                SliverToBoxAdapter(child: headerSlider()),
                SliverToBoxAdapter(child: blogCategories()),
                SliverToBoxAdapter(child: filterSection()),
                blogDataPortrait(),
                SliverToBoxAdapter(child: loadingIndicator(),),
      
                /*if (beautyFeedController.isLoadingMore.value)
                  SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.mainColorRed,
                      ),
                    ),
                  )*/
              ],
            ),
            Obx(() => Visibility(
              visible: currentPosition.value>Get.height*10,
              child: Positioned(
                bottom: 10,
                right: 10,
                child: InkWell(
                  onTap: ()=>goToTop(),
                  child: CircularButton(
                    circleColor: AppColors.mainColorRed,
                    bgColor: AppColors.mainColorRed,
                    child: Icon(Icons.arrow_drop_up_outlined,size: 36.sp,),),
                ),),
            ))
          ],
        ),
      ),
    );
  }

  void loadMoreData() {
    currentPosition.value=_scrollController.position.pixels;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {

      if (beautyFeedController.blogPaginationModel.value.currentPage !=
              beautyFeedController.blogPaginationModel.value.lastPage &&
          !beautyFeedController.isLoadingMore.value) {
        beautyFeedController.isLoadingMore.value = true;

        beautyFeedController.loadMoreData(beautyFeedController
            .blogPaginationModel.value.nextPageUrl
            .toString());
      }
    }
  }

 Widget loadingIndicator() {
    return Obx(() => beautyFeedController.isLoadingMore.value
        ?const Center(child: CircularProgressIndicator(),)
    :const Text(""));
 }

  void goToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInToLinear);
  }

}
