
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:get/get.dart';

class AppStrings {
  static const String searchByCategoryEndPoint = "collection/filtering?category_id=";
  static const String searchByCategoryWithSlugEndPoint = "collection/filtering?cat_slug=";
  static const String filterByProductTypeEndPoint =
      "collection/filtering?product_type=";
  static const String searchSkinTypeEndPoint =
      "collection/filtering?skin_type=";
  static const String searchBrandEndPoint = "collection/filtering?brand_id=";
  static const String searchBrandWithSlugEndPoint = "collection/filtering?brand_slug=";
  static const String searchOfferEndPoint = "collection/filtering?offer_id=";
  static const String searchOfferWithSlugEndPoint = "collection/filtering?offer_slug=";


  static const String getOTPEndPoint = "auth/otp-login";
  static const String socialLoginEndpoint = "auth/social-login";
  static const String getSignUpEndPoint = "auth/sign-up";
  static const String getOTPVerifyEndPoint = "auth/verify-otp-login";
  static const String emailLoginEndpoint="auth/email-login";
  //static const String blogViewEndPoint="blog-view/";
  static const String blogViewEndPoint="blog-view-v2/";
  static const String getBlogEndPoint="get-blog";
  static const String getBlogAutoScrollSliderEndPoint="footer-slider";
  static const String blogCategoriesEndPoint="blog-categories";
  static const String getFilterBlogEndPoint="get-blog?search=";
  static const String getFilterBlogPaginationEndPoint="get-blog-v2?search=";
  static const String orderHistoryEndPoint="auth/order-list";
 // static const String wishListEndpoint="auth/wish-list";
  static const String wishListEndpoint="auth/wish-list-v2";
  static const String reviewListEndpoint="auth/review-list";
  static const String  addWishListEndpoint="auth/add-wish-list";
  static const String  deleteWishListEndpoint="auth/remove-wish-list/";
  static const String  addReviewEndpoint="auth/review-store";
  static const String  categoryEndpoint="get-category";
  static const String  offerDataEndPoint="get-offers";
  static const String  brandListEndPoint="get-brand";
  static const String  homePageDataEndPoint="app-home-api/";
  static const String  orderDetailsEndPoint="auth/order-details/";
  static const String  userInfoEndpoint="auth/user-info";
  static const String  updateUserInfoEndpoint="auth/user-update";
  static const String  areaListEndpoint="auth/area";
  static const String  districtListEndpoint="auth/districts";
  static const String  resetPasswordEndPoint="auth/password-reset-link";
  static const String  deliveryAddressEndPoint="auth/get-delivery-address";
  static const String  updateDeliveryAddressEndPoint="auth/update-delivery-address/";
  static const String  addDeliveryAddressEndPoint="auth/save-delivery-address";
  static const String  vipPrivilegesCategoryEndPoint="vip-category";
  static const String  vipPrivilegesCategoryShopEndPoint="vip-category-shop/";
  static const String  vipPrivilegesAllCategoryShopEndPoint="all-privilege";
  static const String  vipPrivilegesTrendingOffersEndpoint="trending-offers";
  static const String  userPrivilegesEndPoint="auth/privileges";
  static const String  privilegeDetailsEndpoint="privilege-details/";
  static const String  dynamicPageListEndPoint="dynamic-pages";
  static const String  dynamicPageDetailsEndPoint="dynamic-page-details/";
  static const String  addSingleCartItemEndPoint="add-to-cart/";
  static const String  addAllCartItemsEndPoint="multiple-add-to-cart";
  static const String  myCartEndPoint="my-cart";
  static const String  updateCartEndPoint="cart-update/";
  static const String  removeFromCartEndPoint="remove-cart-item/";
  static const String  shippingMethodsEndPoint="shipping-method";
  //static const String  placeOrderEndPoint="place-order";
  static const String  placeOrderEndPoint="place-order-v5";
  static const String  applyCouponEndPoint="apply-coupon";
  static const String  oldTokenEndPoint="auth/old-auth-token";
  static const String  lifeStyleProductDetailsEndPointWithID="lifestyle-product-details-v2/";
  static const String  lifeStyleProductDetailsEndPoint="lifestyle-product-details-v3/";
  static const String  searchProductEndpoint="collection/filtering?search_key=";
  static const String  noticeEndPoint="get-notice";
  static const String  getVersionEndPoint="app-version";
  static const String  getAppReviewImageEndPoint="get-rate-us-image";
  static const String  multipleItemsRemoveFromCartEndPoint="multiple-items-remove/";
  static const String  reviewProductListEndpoint="auth/my-review-product-list";
  static const String  getBlogPaginationEndPoint="get-blog-v2";
  static const String  deleteAccountEndPoint="auth/delete-user-account";
  static const String getReportReasonEndpoint="auth/report-list";
  static const String storeReportEndPoint="auth/store-report";


  static var httpResponseMSG = "".obs;
  static var getNoticeMsg ="".obs;

  static var chekVipPrivilegeEndPoint="check-vip-privilege";






























  static Future<String> encryptedMSG() async {
    var salt10 = await FlutterBcrypt.saltWithRounds(rounds: 10);
    var value = await FlutterBcrypt.hashPw(password: r'otp-login-request-token-#@&**#&$*#', salt: salt10);
    return value;
  }

/*  static Future<String> encryptedMSG() async {
    const secret = r'otp-login-request-token-#@&**#&$*#';
    // You can optionally include a salt (for SHA-256, just append it to the message)
    const salt = 's0m3Rand0mS@lt';
    final bytes = utf8.encode(secret + salt); // combine message + salt
    final digest = sha256.convert(bytes); // hash using SHA-256

    return digest.toString(); // return hex string
  }*/


}
