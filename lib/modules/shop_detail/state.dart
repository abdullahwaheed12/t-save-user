import 'package:flutter/material.dart';

import '../../utils/color.dart';

class ShopDetailState {
  TextStyle? productNameStyle;
  TextStyle? productPriceStyle;
  TextStyle? productDescStyle;
  TextStyle? cartButtonStyle;
  TextStyle? headingTextStyle;
  TextStyle? descTextStyle;
  TextStyle? nameTextStyle;
  TextStyle? priceTextStyle;
  TextStyle? shopInfoLabelTextStyle;
  TextStyle? shopInfoValueTextStyle;
  ShopDetailState() {
    ///Initialize variables
    productNameStyle =const TextStyle(
    fontFamily: 'Poppins',

    fontWeight: FontWeight.w800, fontSize: 28, color: customTextblackColor);
    
    
    
    productPriceStyle = const TextStyle(
    fontFamily: 'Poppins',

      fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white);
    
     
    productDescStyle = const TextStyle(
    fontFamily: 'Poppins',

       fontWeight: FontWeight.w400, fontSize: 15, color: customTextblackColor);
    

    cartButtonStyle = const TextStyle(
    fontFamily: 'Poppins',

       fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white);
    
     

    headingTextStyle = const TextStyle(
    fontFamily: 'Poppins',

        fontWeight: FontWeight.w900, fontSize: 17, color: customTextblackColor);
    
  
    descTextStyle = const TextStyle(
    fontFamily: 'Poppins',

    fontWeight: FontWeight.w600, fontSize: 15, color: customTextblackColor);
    
     
    nameTextStyle = const TextStyle(
    fontFamily: 'Poppins',

   fontSize: 18, fontWeight: FontWeight.w700, color: customTextblackColor);
    

    priceTextStyle =  TextStyle(
    fontFamily: 'Poppins',

      fontSize: 14,
        fontWeight: FontWeight.w700,
        color: customTextblackColor.withOpacity(0.5));
  
    shopInfoLabelTextStyle = const TextStyle(
    fontFamily: 'Poppins',

        fontSize: 13, fontWeight: FontWeight.w800, color: customTextblackColor);
    
    
    shopInfoValueTextStyle = const TextStyle(
    fontFamily: 'Poppins',

       fontSize: 13, fontWeight: FontWeight.w600, color: customTextblackColor);
    

  }
}
