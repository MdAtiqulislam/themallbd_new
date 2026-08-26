import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../constraints/app_strings.dart';
import '../../controllers/offer_list_controller.dart';
import '../../widgets/single_list_item.dart';

class MultipleSearchOfferListPage extends StatelessWidget {
  MultipleSearchOfferListPage({super.key});

  final OfferListController offerListController =
  Get.put(OfferListController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() {
        return offerListController.isLoading.value?Text("Loading"):ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
            itemCount: offerListController.offerList!.length,
            itemBuilder: (context,index){
              return InkWell(
                onTap: (){
                  /*Get.toNamed(
                      '/search_category_product',
                      arguments: "${AppStrings.searchOfferEndPoint}${offerListController.offerList![index].id}");*/

                  Get.toNamed('/test',
                      arguments:
                      ["${AppStrings.searchOfferEndPoint}${offerListController.offerList![index].id}",
                        offerListController.offerList![index].name!.toUpperCase(),
                      ]
                  );
                },
                  child: SingleListItem(image: offerListController.offerList![index].image.toString(), title: offerListController.offerList![index].name.toString()));

            });
      }),
    );
  }
}
