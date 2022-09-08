// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import 'state.dart';

class HomeLogic extends GetxController {
  final state = HomeState();

//-currentUserData

  DocumentSnapshot? currentUserData;
  currentUser(BuildContext context) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where("uid",
            isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
        .get();
    if (query.docs.isNotEmpty) {
      log('USER---->>>${query.docs[0].get('name')}');
      if (query.docs[0].get('name').toString() == 'guest' ||
          query.docs[0].get('name').toString() == 'Guest') {
        nameSaveDialog(context, query.docs[0].id);
      }
      if (query.docs[0].get('phone').toString() == '') {
        phonNoSaveDialog(context, query.docs[0].id);
      }
      currentUserData = query.docs[0];
      update();
    } else {
      print('-------------->  ${currentUserData}');
    }
  }

//-name saving dialog
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  nameSaveDialog(BuildContext context1, String? id) {
    return showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context1,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
        transitionBuilder: (BuildContext context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///---header
                      Container(
                        height: 66,
                        decoration: BoxDecoration(
                          color: const Color(0xffFFA500).withOpacity(.21),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 10, 15, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  'Enter Your Name',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: customTextblackColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                                fontFamily: 'Poppins', color: customThemeColor),
                            border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customTextblackColor)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customTextblackColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customThemeColor)),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field Required';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),

                      ///---footer
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 20, 0, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      Get.find<GeneralController>()
                                          .updateFormLoader(true);
                                      Navigator.pop(context);
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(id)
                                          .update(
                                              {'name': nameController.text});
                                      // nameController.dispose();
                                      //for phone dialog
                                      QuerySnapshot query =
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .where("uid",
                                                  isEqualTo: Get.find<
                                                          GeneralController>()
                                                      .boxStorage
                                                      .read('uid'))
                                              .get();
                                      if (query.docs[0]
                                              .get('phone')
                                              .toString() ==
                                          '') {
                                        phonNoSaveDialog(
                                            context, query.docs[0].id);
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: customThemeColor,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Text(
                                          'SAVE',
                                          style: GoogleFonts.jost(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

//-phoneNoSaving

  final GlobalKey<FormState> _phonNoFormKey = GlobalKey();
  TextEditingController phoneNoController = TextEditingController();
  phonNoSaveDialog(BuildContext context1, String? id) {
    return showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context1,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
        transitionBuilder: (BuildContext context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _phonNoFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///---header
                      Container(
                        height: 66,
                        decoration: BoxDecoration(
                          color: const Color(0xffFFA500).withOpacity(.21),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 10, 15, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  'Enter Your Number',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: customTextblackColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: TextFormField(
                          controller: phoneNoController,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                                fontFamily: 'Poppins', color: customThemeColor),
                            border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customTextblackColor)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customTextblackColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customThemeColor)),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field Required';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),

                      ///---footer
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 20, 0, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (_phonNoFormKey.currentState!
                                        .validate()) {
                                      Get.find<GeneralController>()
                                          .updateFormLoader(true);
                                      Navigator.pop(context);
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(id)
                                          .update({
                                        'phone': phoneNoController.text
                                      });
                                      // phoneNoController.dispose();
                                    }
                                  },
                                  child: Container(
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: customThemeColor,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Text(
                                          'SAVE',
                                          style: GoogleFonts.jost(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

//-drawerController
  AdvancedDrawerController advancedDrawerController =
      AdvancedDrawerController();
  void handleMenuButtonPressed() {
    advancedDrawerController.showDrawer();
    update();
  }

  ScrollController scrollController = ScrollController();

  int? tabIndex = 0;
  updateTabIndex(int? newValue) {
    tabIndex = newValue;
    update();
  }

 
  ///----------------------------update token----------------------------
  User? currentUserForFcm;
  String? fcmToken;
  updateToken() async {
    currentUserForFcm = FirebaseAuth.instance.currentUser;
    if (!Get.find<GeneralController>().boxStorage.hasData('fcmToken')) {
      await FirebaseMessaging.instance.getToken().then((value) {
        fcmToken = value;
        Get.find<GeneralController>().boxStorage.write('fcmToken', 'Exist');
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserForFcm!.uid)
          .update({'token': fcmToken});
    }
  }

  
}


