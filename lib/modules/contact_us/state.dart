import 'package:flutter/material.dart';
import 'package:com.tsaveuser.www/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpState {
  TextStyle? appBarTextStyle;
  TextStyle? contentTextStyle;
  HelpState() {
    ///Initialize variables
    appBarTextStyle = GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: customTextblackColor);
    contentTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w700, color: customTextblackColor);
  }
}
