import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import 'logic.dart';
import 'state.dart';

class PhoneLoginView extends StatefulWidget {
  const PhoneLoginView({Key? key}) : super(key: key);

  @override
  _PhoneLoginViewState createState() => _PhoneLoginViewState();
}

class _PhoneLoginViewState extends State<PhoneLoginView>
    with TickerProviderStateMixin {
  final LoginLogic logic = Get.put(LoginLogic());
  final LoginState state = Get.find<LoginLogic>().state;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<LoginLogic>().updateOtpSendCheckerLogin(false);
      Get.find<LoginLogic>().phoneController.clear();
      Get.find<LoginLogic>().loginPhoneNumber = null;
    });
    Get.find<LoginLogic>().loginTimerAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 59))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {});
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginLogic>(
      builder: (_loginLogic) => GestureDetector(
        onTap: () {
          Get.find<GeneralController>().focusOut(context);
        },
        child: GetBuilder<GeneralController>(
          builder: (_generalController) => ModalProgressHUD(
            inAsyncCall: _generalController.formLoader!,
            progressIndicator: const CircularProgressIndicator(
              color: customThemeColor,
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: customThemeColor,
                    size: 25,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Image.asset(
                            "assets/logo.png",
                            width: MediaQuery.of(context).size.width * .3,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),

                        ///---phone-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xffF6F7FC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IntlPhoneField(
                              initialCountryCode: 'PK',
                              controller: _loginLogic.phoneController,
                              style: const TextStyle(
                                  fontFamily: 'Poppins', color: Colors.black),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                filled: true,
                                fillColor: const Color(0xffF6F7FC),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                counterText: '',
                                labelText: 'Phone Number',
                                labelStyle: state.labelTextStyle,
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (phone) {
                                setState(() {
                                  _loginLogic.updateOtpSendCheckerLogin(false);
                                  _loginLogic.loginPhoneNumber =
                                      phone.completeNumber;
                                });
                                log(phone.completeNumber);
                              },
                              onCountryChanged: (phone) {
                                _loginLogic.updateOtpSendCheckerLogin(false);
                                _loginLogic.phoneController.clear();
                                _loginLogic.loginPhoneNumber = null;
                                setState(() {});
                                log('Country code changed to: ' +
                                    phone.code.toString());
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class OtpTimer extends StatelessWidget {
  final state = Get.find<LoginLogic>().state;

  final AnimationController controller;
  double fontSize;
  Color timeColor = Colors.black;

  OtpTimer(this.controller, this.fontSize, this.timeColor, {Key? key})
      : super(key: key);

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    Duration? duration = controller.duration;
    return duration!;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Text(timerString, style: state.labelTextStyle);
        });
  }
}
