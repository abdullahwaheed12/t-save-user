import 'package:flutter/material.dart';

import '../../../utils/color.dart';

class AllOrdersState {
  TextStyle? appBarTextStyle;
  TextStyle? nameTextStyle;
  TextStyle? priceTextStyle;
  TextStyle? otpTextStyle;
  AllOrdersState() {
    ///Initialize variables
    appBarTextStyle =const TextStyle(color: customTextblackColor, fontSize: 28, fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',);
    
  
    nameTextStyle = const TextStyle(color: customTextblackColor, fontSize: 18, fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',);
    priceTextStyle = const TextStyle(color: customTextblackColor, fontSize: 14, fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',);
   
    otpTextStyle = const TextStyle(color: customTextblackColor, fontSize: 14, fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',);
    
   
  }
}
