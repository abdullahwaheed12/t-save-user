import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart' as geo_locator;
import 'package:permission_handler/permission_handler.dart';
import 'package:system_settings/system_settings.dart';
import '../../controllers/general_controller.dart';
import 'state.dart';

class SignUpLogic extends GetxController {
  final state = SignUpState();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  File? userImage;
  String? downloadURL;
  String? longitudeString;
  String? latitudeString;

  AnimationController? loginTimerAnimationController;

  bool? otpSendCheckerLogin = false;
  updateOtpSendCheckerLogin(bool? newValue) {
    otpSendCheckerLogin = newValue;
    update();
  }

  ///------------------------------------OTP----START-----------------
  String? phoneNumber;

  ///------------------------------------OTP----END-----------------
  Future<firebase_storage.UploadTask?> uploadFile(BuildContext context) async {
    if (userImage == null) {
      Get.find<GeneralController>().updateFormLoader(false);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));

      return null;
    }

    firebase_storage.UploadTask uploadTask;

    final String pictureReference =
        "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(pictureReference);

    uploadTask = ref.putFile(userImage!);

    downloadURL = await (await uploadTask).ref.getDownloadURL();
    log('URL---->>$downloadURL');

    return Future.value(uploadTask);
  }

  ///------------------------------------LOCATION----START-----------------

  geo_locator.Position? currentPosition;
  double? latitude;
  double? longitude;
  String? currentAddress;
  String? currentArea;
  String? currentCity;
  String? currentCountry;
  saveData({String? latLong, String? place}) async {
    var data = await json.decode(latLong!);
    addressController.text = place!;
    longitudeString = data['lng'].toString();
    latitudeString = data['lat'].toString();
    latitude = double.parse(latitudeString.toString());
    longitude = double.parse(longitudeString.toString());
    center = LatLng(latitude!, longitude!);
    lastMapPosition = center;
    final GoogleMapController controller1 = await controller.future;
    controller1.moveCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: center)));
    onCameraMove(CameraPosition(target: center));
    update();
    log("Center--->>> $center");
    log("LatLong--->>> $data");
    log("LatLong Place--->>> $place");
  }

  saveLocation() async {
    List<Placemark> p = await GeocodingPlatform.instance
        .placemarkFromCoordinates(center.latitude, center.longitude);
    Placemark place = p[0];
    String getAddress =
        '${place.name}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
    addressController.text = getAddress;
    longitudeString = center.longitude.toString();
    latitudeString = center.latitude.toString();
    update();
    Get.back();
    log('getAddress--->>${getAddress.toString()}');
  }

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

      if (!enabled) {
        log('IOS permission--->> $enabled');
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return CustomDialogBox(
        //         title: '${'location'.tr}!',
        //         titleColor: customDialogInfoColor,
        //         descriptions: 'please_turn_on_your_location'.tr,
        //         text: 'ok'.tr,
        //         functionCall: () {
        //           Navigator.pop(context);
        //           AppSettings.openLocationSettings();
        //         },
        //         img: 'assets/dialog_Info.svg',
        //       );
        //     });
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
      center = LatLng(latitude!, longitude!);
      lastMapPosition = center;
      log("longitude : $longitude");
      log("latitude : $latitude");
      log("address : $currentPosition");

      update();
      if (currentPosition == null) {
        getCurrentLocation();
      }
      getAddressFromLatLng();
    }).catchError((e) {
      // Get.find<GeneralController>().updateFormLoader(false);
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
      // if (addressController.text.isEmpty) {
      //   addressController.text = currentAddress!;
      // }
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

  ///------------------------------------MAP-DATA----START-----------------
  late LatLng center;
  Completer<GoogleMapController> controller = Completer();

  Set<Marker> markers = {};

  late LatLng lastMapPosition = center;
  Future<void> onCameraMove(CameraPosition position) async {
    lastMapPosition = position.target;
    center = lastMapPosition;

    onAddMarkerButtonPressed();
    update();
  }

  void onAddMarkerButtonPressed() {
    markers = {};
    markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(lastMapPosition.toString()),
      position: lastMapPosition,
      infoWindow: InfoWindow(
        title: addressController.text,
        snippet: '',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    update();
  }

  ///------------------------------------MAP-DATA----END-----------------
}
