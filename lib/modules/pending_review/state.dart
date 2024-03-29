import 'package:flutter/material.dart';

import '../../utils/color.dart';

class PendingReviewState {
  TextStyle? headingTextStyle;
  TextStyle? nameTextStyle;
  TextStyle? priceTextStyle;
  TextStyle? otpTextStyle;
  TextStyle? appBarTextStyle;
  TextStyle? swipeTextStyle;
  PendingReviewState() {
    ///Initialize variables
    headingTextStyle = const TextStyle(      fontWeight: FontWeight.w800, fontSize: 20, color: customTextblackColor,
    fontFamily: 'Poppins',); 
    
    
    nameTextStyle =  const TextStyle(    fontSize: 18, fontWeight: FontWeight.w700, color: customTextblackColor,
    fontFamily: 'Poppins',); 
   
    priceTextStyle =  TextStyle(       fontSize: 14,
        fontWeight: FontWeight.w700,
        color: customTextblackColor.withOpacity(0.5),
    fontFamily: 'Poppins',); 
    
 
    otpTextStyle = const TextStyle(      fontSize: 11, fontWeight: FontWeight.w600, color: customTextblackColor,
    fontFamily: 'Poppins',); 
    
  
    appBarTextStyle = const TextStyle(        fontSize: 28, fontWeight: FontWeight.w800, color: customTextblackColor,
    fontFamily: 'Poppins',); 
    
    
    swipeTextStyle = const TextStyle(      fontSize: 12,fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',); 

  }
}
