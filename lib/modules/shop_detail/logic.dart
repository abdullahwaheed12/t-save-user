import 'dart:async';
import 'dart:developer';

import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tsaveuser.www/controllers/fcm_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:com.tsaveuser.www/modules/home/logic.dart';
import 'package:com.tsaveuser.www/utils/color.dart';
import 'package:com.tsaveuser.www/widgets/booking_upload_dialog.dart';
import 'dart:math' as math;

import 'state.dart';

class ShopDetailLogic extends GetxController {
  ShopDetailLogic({required this.shopModel});
  //--------------------------------booking logic start----------------------------
  //-------
  final DocumentSnapshot<Map<String, dynamic>> shopModel;

  //-------
  final now = DateTime.now();
  GetStorage boxStorage = GetStorage();
  late BookingService newBooking;

  ///---random-string-start

  String charsForOtp = '1234567890';
  math.Random rnd = math.Random();
  String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  String getRandomOtp(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => charsForOtp.codeUnitAt(rnd.nextInt(charsForOtp.length))));
  String? get getOtp => getRandomOtp(5);

  ///---random-string-end
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  List<DateTimeRange> converted = [];

  @override
  void onInit() {
    super.onInit();
    print('on init call');

    // var closingDate = DateFormat('h:mm a').parse('8:45 AM');
    // var opningDate = DateFormat('h:mm a').parse('8:45 PM');
    //!--- if ending time greater then starting time then it wil be error
    newBooking = BookingService(
        serviceName: 'Booking',
        serviceDuration: 60,
        bookingEnd: DateTime(now.year, now.month, now.day, 16, 45),
        bookingStart: DateTime(now.year, now.month, now.day, 8, 45));
  }

  //convert stream into list of dateTimeRange
  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    if (streamResult == null) {
      print('stream is null');
    } else {
      print('stream is not null');

      var s = streamResult as QuerySnapshot<Map<String, dynamic>>;
      s.docs.forEach((event) {
        print('in the for each');
        converted.add(DateTimeRange(
            start:
                DateTime.fromMicrosecondsSinceEpoch(event.get('bookingStart')),
            end: DateTime.fromMicrosecondsSinceEpoch(event.get('bookingEnd'))));
      });
    }
    print(converted);
    return converted;
  }

  //download booking stream
  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return FirebaseFirestore.instance
        .collection('booking')
        .where('shop', isEqualTo: shopModel.get('name'))
        .snapshots();
  }

  //upload booking slot
  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking,
      required BuildContext context}) async {
    converted.add(DateTimeRange(
        start: newBooking.bookingStart, end: newBooking.bookingEnd));

    showAnimatedDialog(
        animationType: DialogTransitionType.size,
        curve: Curves.fastOutSlowIn,
        duration: Duration(seconds: 1),
        context: context,
        builder: (ctx) {
          return UploadDialog();
        });

    print('booking has been uploaded');
  }

  //send request
  void sendRequest() {
    if (formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('booking').add({
        'bookingStart': newBooking.bookingStart.microsecondsSinceEpoch,
        'bookingEnd': newBooking.bookingEnd.microsecondsSinceEpoch,
        'customerName': Get.find<HomeLogic>().currentUserData!.get('name'),
        'Customerphone': Get.find<HomeLogic>().currentUserData!.get('phone'),
        'uid': Get.find<HomeLogic>().currentUserData!.get('uid'),
        'problem': textEditingController.text,
        'otp': getOtp,
        'date_time': DateTime.now(),
        'id': getRandomString(5),
        'status': 'Pending',
        'review_status': 'Pending',
        'shop': shopModel.get('name'),
        'shopPhone': shopModel.get('phone'),
        'shop_id': shopModel.get('id'),
        'shop_image': shopModel.get('image'),
      }).then((value) async {
        FirebaseFirestore.instance
            .collection('users')
            .doc(shopModel.id)
            .get()
            .then((userDoc) {
          print('token is ${userDoc.get('token')}');
          sendNotificationCall(userDoc.get('token'), 'Booking Alert',
              'New booking has been arived please check out the t-save-app');
        });

        Get.snackbar(
          'Request Send Successfull',
          'Wait for the response',
          colorText: Colors.white,
          backgroundColor: customThemeColor.withOpacity(0.7),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
        );
      });

      Get.back();
      Get.back();
    }
  }

  //--------------------------------booking logic end------------------------------

  final state = ShopDetailState();
  double? averageRating = 0;
  currentShop(DocumentSnapshot? productModel) async {
    for (int i = 0; i < productModel!.get('ratings').length; i++) {
      averageRating = productModel.get('ratings')[i] + averageRating;
    }
    averageRating = (averageRating!) / productModel.get('ratings').length;
    if (averageRating.toString() == 'NaN') {
      averageRating = 0.0;
      log('averageRating--->>$averageRating');
    }
  }

  int? tabIndex = 0;
  updateTabIndex(int? newValue) {
    tabIndex = newValue;
    update();
  }

  ///-------MAP------

  final Completer<GoogleMapController> _controller = Completer();

  LatLng? center;
  updateCenter(LatLng? newValue) {
    center = newValue;
    update();
  }

  final Set<Marker> markers = {};

  final MapType currentMapType = MapType.normal;

  Future<void> onAddMarkerButtonPressed(
      BuildContext context, String name) async {
    markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(center.toString()),
      position: center!,
      infoWindow: InfoWindow(
        title: name,
        // snippet: '...',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    ));
    update();
  }

  void onCameraMove(CameraPosition position) {
    center = position.target;
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
}
