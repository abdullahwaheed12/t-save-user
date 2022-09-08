import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tsaveuser.www/modules/shop_detail/logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookginAppointment extends StatelessWidget {
  const BookginAppointment({super.key, required this.shopModel});
  final DocumentSnapshot<Map<String, dynamic>> shopModel;

  @override
  Widget build(BuildContext context) {
    var shopDetailLogic = Get.find<ShopDetailLogic>();
    return SizedBox(
        height: 650,
        child: Center(
          child: BookingCalendar(
            availableSlotColor: Colors.green,
            bookingGridCrossAxisCount: 3,
            bookingGridChildAspectRatio: 1,
            bookingService: shopDetailLogic.newBooking,
            bookingButtonColor: Colors.green,
            bookingButtonText: 'Book Now',
            formatDateTime: (dateTime) {
              var dt = DateFormat.jm().format(dateTime);
              return '${dt}';
            },
            convertStreamResultToDateTimeRanges:
                shopDetailLogic.convertStreamResultMock,
            getBookingStream: shopDetailLogic.getBookingStreamMock,
            uploadBooking: ({required newBooking}) async {
              return shopDetailLogic.uploadBookingMock(
                  newBooking: newBooking, context: context);
            },
          ),
        ));
  }
}
