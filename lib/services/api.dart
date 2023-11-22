class Api {
  Map<String, String> staticHeaders({required bool isAuth, String token = ""}) {
    if (isAuth) {
      return {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      };
    } else {
      return {
        'Content-Type': 'application/json; charset=UTF-8',
      };
    }
  }

  // static const fileBaseUrl = "http://192.168.1.51:3000"; //localhost
  static const fileBaseUrl = ""; //development
  // static const fileBaseUrl = ""; //production
  static const apiBaseUrl = "$fileBaseUrl/api";

  //country
  static const apiListCountries = "$apiBaseUrl/country/listApp";
  static const apiCountryDetails = "$apiBaseUrl/country/details";

  //state
  static const apiListStates = "$apiBaseUrl/state/list";
  static const apiStateDetails = "$apiBaseUrl/state/details";

  //international country
  static const apiListInternationalCountries = "$apiBaseUrl/internationalShipment/customerList";
  static const apiDetailsInternationalCountry = "$apiBaseUrl/internationalShipment/details";

  //product category
  static const apiListCategories = "$apiBaseUrl/productCategory/list";
  static const apiListFeaturedCategories = "$apiBaseUrl/productCategory/featuredCategories";

  //product
  static const apiListFeaturedProducts = "$apiBaseUrl/product/featuredList";
  static const apiListProducts = "$apiBaseUrl/product/list";
  static const apiListProductsByCategoryId = "$apiBaseUrl/product/listByCategory";
  static const apiListNewArrivalProducts = "$apiBaseUrl/product/newArrivalList";
  static const apiListProductsForShopPage = "$apiBaseUrl/product/shopList";

  //coupon
  static const apiListCoupons = "$apiBaseUrl/coupon/list";
  static const apiCouponDetailsByCouponCode = "$apiBaseUrl/coupon/couponDetails";

  //user
  static const apiRegisterGuest = "$apiBaseUrl/user/registerGuest";
  static const apiLogin = "$apiBaseUrl/user/login";
  static const apiRegister = "$apiBaseUrl/user/register";
  static const apiAccountVerification = "$apiBaseUrl/user/verify";
  static const apiResendVerificationOtp = "$apiBaseUrl/user/resendOtp";
  static const apiForgotPassword = "$apiBaseUrl/user/forgotPassword";
  static const apiVerifyForgotPasswordOtp = "$apiBaseUrl/user/verifyForgotPasswordOtp";
  static const apiResetPassword = "$apiBaseUrl/user/resetPassword";
  static const apiUserDetails = "$apiBaseUrl/user/details";
  static const apiUpdateUser = "$apiBaseUrl/user/update";

  //cart
  static const apiAddCart = "$apiBaseUrl/cart/add";
  static const apiListCart = "$apiBaseUrl/cart/list";
  static const apiDeleteCart = "$apiBaseUrl/cart/delete";
  static const apiClearCart = "$apiBaseUrl/cart/clear";

  //tax
  static const apiTaxDetailsByCountryId = "$apiBaseUrl/tax/detailsByCountryId";

  //address
  static const apiListCustomerAddresses = "$apiBaseUrl/customerAddresses/list";
  static const apiAddCustomerAddresses = "$apiBaseUrl/customerAddresses/add";
  static const apiSetDefaultAddress = "$apiBaseUrl/customerAddresses/setDefault";
  static const apiDeleteAddress = "$apiBaseUrl/customerAddresses/delete";

  //order
  static const apiCreateOrder = "$apiBaseUrl/order/create";
  static const apiUpdateOrder = "$apiBaseUrl/order/update";
  static const apiOrderList = "$apiBaseUrl/order/app/list";

  //file
  static const apiUploadFile = "$apiBaseUrl/file/upload";
  static const apiDeleteFile = "$apiBaseUrl/file/delete";
}
