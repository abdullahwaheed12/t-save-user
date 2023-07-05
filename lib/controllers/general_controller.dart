// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:com.tsaveuser.www/controllers/auth_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:system_settings/system_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart' as geo_locator;

import '../utils/color.dart';

class GeneralController extends GetxController {
  GetStorage boxStorage = GetStorage();
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  DocumentReference<Map<String, dynamic>>? tableBookingDocumentReference;
  focusOut(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  bool? formLoader = false;
  updateFormLoader(bool? newValue) {
    formLoader = newValue;
    update();
  }

  Future<void> makePhoneCall(String? phoneNumber) async {
    final uri = 'tel:$phoneNumber';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  checkWishList(BuildContext context, String? id, Function? checkChange) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('wishList')
          .where("uid",
              isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
          .get();

      if (query.docs.isNotEmpty) {
        for (var element in query.docs) {
          if (element.get('w_id').toString() == id) {
            checkChange!(true);
            update();
          }
        }
      } else {}
    } on FirebaseException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      log(e.toString());
    }
  }

  deleteWishList(
    BuildContext context,
    String? id,
  ) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('wishList')
          .where('w_id', isEqualTo: id)
          .get();
      if (query.docs.isNotEmpty) {
        for (var element in query.docs) {
          FirebaseFirestore.instance
              .collection('wishList')
              .doc(element.id)
              .delete();
        }
      }
    } on FirebaseException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      log(e.toString());
    }
  }

  addToWishList(BuildContext context, String? id, String? type) async {
    try {
      bool? forNew = true;
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('wishList')
          .where("uid",
              isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
          .get();

      if (query.docs.isNotEmpty) {
        for (var element in query.docs) {
          if (element.get('w_id').toString() == id) {
            forNew = false;
            update();
            Get.snackbar(
              'Already Added',
              '',
              colorText: Colors.white,
              backgroundColor: customThemeColor.withOpacity(0.7),
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(15),
            );
          }
        }
        if (forNew!) {
          FirebaseFirestore.instance.collection('wishList').doc().set({
            'w_id': id,
            'uid': Get.find<GeneralController>().boxStorage.read('uid'),
            'type': type
          });
          Get.snackbar(
            'Added To Favorites',
            '',
            colorText: Colors.white,
            backgroundColor: customThemeColor.withOpacity(0.7),
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(15),
          );
        }
      } else {
        FirebaseFirestore.instance.collection('wishList').doc().set({
          'w_id': id,
          'uid': Get.find<GeneralController>().boxStorage.read('uid'),
          'type': type
        });
        Get.snackbar(
          'Added To Favorites',
          '',
          colorText: Colors.white,
          backgroundColor: customThemeColor.withOpacity(0.7),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
        );
      }
    } on FirebaseException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      log(e.toString());
    }
  }

  ///------------------------------------LOCATION----START-----------------
  geo_locator.Position? currentPosition;
  double? latitude;
  double? longitude;
  String? currentAddress;
  String? currentArea;
  String? currentCity;
  String? currentCountry;

  Future<bool> _requestPermission(Permission permission) async {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  requestLocationPermission(BuildContext context) async {
    if (Platform.isIOS) {
      await [
        Permission.location,
        Permission.locationWhenInUse,
      ].request();
      await Permission.locationWhenInUse.request();
      ServiceStatus serviceStatus = await Permission.location.serviceStatus;
      bool enabled = (serviceStatus == ServiceStatus.enabled);

      if (enabled) {
        log('IOS permission--->> $enabled');
      } else {
        getCurrentLocation();
      }
    } else {
      var granted = await _requestPermission(Permission.location);
      if (granted != true) {
        var granted1 = await _requestPermission(Permission.locationAlways);
        if (granted1 != true) {
          requestLocationPermission(context);
        }
        requestLocationPermission(context);
      } else {
        // _gpsService();
        getCurrentLocation();
      }
      debugPrint('requestLocationPermission $granted');
      return granted;
    }
  }

  getCurrentLocation() {
    geo_locator.Geolocator.getCurrentPosition(
            desiredAccuracy: geo_locator.LocationAccuracy.high)
        .then((geo_locator.Position position) {
      currentPosition = position;
      longitude = currentPosition!.longitude;
      latitude = currentPosition!.latitude;
      log("longitude : $longitude");
      log("latitude : $latitude");
      log("address : $currentPosition");

      update();
      if (currentPosition == null) {
        getCurrentLocation();
      }
      getAddressFromLatLng();
    }).catchError((e) {
      _gpsService();
      log('ERROR LOCATION${e.toString()}');
    });
  }

  enableLocation() async {
    await SystemSettings.location();
  }

  Future _gpsService() async {
    if (!(await geo_locator.Geolocator.isLocationServiceEnabled())) {
      enableLocation();
      return null;
    } else {
      return true;
    }
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> p = await GeocodingPlatform.instance
          .placemarkFromCoordinates(
              currentPosition!.latitude, currentPosition!.longitude);
      Placemark place = p[0];
      currentAddress =
          '${place.name}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';

      currentArea = "${place.thoroughfare}";
      currentCity = place.subAdministrativeArea.toString();
      currentCountry = place.country.toString();
      log('CURRENT-ADDRESS--->>${currentAddress.toString()}');
      log('ADMINISTRATIVE--->>${place.administrativeArea.toString()}');
      log('SUB-ADMINISTRATIVE--->>${place.subAdministrativeArea.toString()}');
      log('SUB-ADMINISTRATIVE--->>${place.country.toString()}');
      log('THROUGH_FAIR--->>${place.thoroughfare.toString()}');
      log('COMPLETE_PLACE--->>${place.toJson().toString()}');
      // Get.find<GeneralController>().updateFormLoader(false);
      update();
    } catch (e) {
      // Get.find<GeneralController>().updateFormLoader(false);
      log(e.toString());
    }
  }

  ///------------------------------------LOCATION----END-----------------
  ///----------------------------update address----------------------------

  updateAdress() async {
    User? currentUserForFcm = FirebaseAuth.instance.currentUser;
    if (currentUserForFcm == null) return;
    Future.delayed(Duration(seconds: 5)).then((value) {
      print('address update $currentAddress');

      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserForFcm.uid)
          .update({'address': currentAddress});
    });
  }
}
