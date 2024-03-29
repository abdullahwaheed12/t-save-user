import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/color.dart';

class CustomDialogBox extends StatefulWidget {
  final String? title, descriptions, text;
  final String? img;
  final Color? titleColor;
  final functionCall;

  const CustomDialogBox(
      {Key? key,
      this.title,
      this.descriptions,
      this.text,
      this.img,
      this.titleColor,
      this.functionCall})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              widget.title == null
                  ? const SizedBox()
                  : Text(
                      widget.title!,
                      style: GoogleFonts.jost(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: widget.titleColor),
                    ),
              widget.title == null
                  ? const SizedBox()
                  : const SizedBox(
                      height: 15,
                    ),
              Text(
                widget.descriptions!,
                style: GoogleFonts.jost(
                    fontSize: 14, color: const Color(0xff3E3E3E)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () => widget.functionCall(),
                    child: Container(
                      height: 47,
                      width: MediaQuery.of(context).size.width * .5,
                      decoration: BoxDecoration(
                          color: widget.titleColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          widget.text!,
                          style: GoogleFonts.jost(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Constants.avatarRadius)),
                child: SvgPicture.asset('${widget.img}')),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}

showProgress(){
  Get.dialog( const Center(child: CircularProgressIndicator(color: customThemeColor,),));
}

dissmissProgress(){
  if(Get.isDialogOpen!){
    Get.back();
  }

}



showToast(String data, {double fontsize = 16.0,}) {

  Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: fontsize);
}