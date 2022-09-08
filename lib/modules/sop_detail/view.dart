// ignore_for_file: deprecated_member_use

import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tsaveuser.www/modules/shop_detail/logic.dart';
import 'package:com.tsaveuser.www/modules/shop_detail/state.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import '../image_full_view/view.dart';

class shopDetailPage extends StatefulWidget {
  const shopDetailPage({Key? key, required this.shopModel})
      : super(key: key);
  final DocumentSnapshot<Map<String, dynamic>> shopModel;

  @override
  _shopDetailPageState createState() => _shopDetailPageState();
}

class _shopDetailPageState extends State<shopDetailPage> {
  late final ShopDetailLogic logic;
  late final ShopDetailState state;
  bool? favourites = false;
  checkWishList(bool? newValue) {
    favourites = newValue;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    logic =
        Get.put(ShopDetailLogic(shopModel: widget.shopModel));
    logic.currentShop(widget.shopModel);
    state = logic.state;
    Get.find<ShopDetailLogic>().updateCenter(LatLng(
      double.parse(widget.shopModel.get('lat').toString()),
      double.parse(widget.shopModel.get('lng').toString()),
    ));
    Get.find<ShopDetailLogic>()
        .onAddMarkerButtonPressed(context, widget.shopModel.get('name'));
    Get.find<GeneralController>().checkWishList(
        context, widget.shopModel.get('id'), checkWishList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopDetailLogic>(
      builder: (_shopDetailLogic) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 15,
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                if (!favourites!) {
                  Get.find<GeneralController>().addToWishList(
                      context, widget.shopModel.get('id'), 'shops');
                  setState(() {
                    favourites = true;
                  });
                } else {
                  Get.find<GeneralController>().deleteWishList(
                      context, widget.shopModel.get('id'));
                  setState(() {
                    favourites = false;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
                child: Icon(
                  favourites! ? Icons.favorite : Icons.favorite_border,
                  color: favourites! ? Colors.red : Colors.black,
                  size: 20,
                ),
              ),
            )
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
            child: ListView(
              children: [
                ///---image
                Hero(
                    tag: '${widget.shopModel.get('image')}',
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.to(ImageViewScreen(
                              networkImage:
                                  '${widget.shopModel.get('image')}',
                            ));
                          },
                          child: Container(
                            height: 220,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                '${widget.shopModel.get('image')}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ))),

                ///---name
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Text('${widget.shopModel.get('name')}',
                      textAlign: TextAlign.center,
                      style: state.productNameStyle),
                ),

                ///---rating-discount
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.shopModel.get('open_time')} - ${widget.shopModel.get('close_time')}',
                                style: state.productPriceStyle!.copyWith(
                                    color: customTextblackColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.star,
                              color: customThemeColor,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: Text(
                                _shopDetailLogic.averageRating == 0.0
                                    ? 'Not Rated'
                                    : _shopDetailLogic.averageRating!
                                        .toStringAsPrecision(2),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 1,
                                style: state.productPriceStyle!.copyWith(
                                    color: customTextblackColor, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${(Geolocator.distanceBetween(Get.find<GeneralController>().latitude!, Get.find<GeneralController>().longitude!, double.parse(widget.shopModel.get('lat').toString()), double.parse(widget.shopModel.get('lng').toString())) ~/ 1000)}km',
                              style: state.productPriceStyle!.copyWith(
                                  color: customTextblackColor, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ///---tabs
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Center(
                    child: DefaultTabController(
                        length: 2, // length of tabs
                        initialIndex: 0,
                        child: TabBar(
                          isScrollable: true,
                          labelStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                          labelColor: Colors.white,
                          unselectedLabelColor: customThemeColor,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: customThemeColor,
                          ),

                          onTap: (int? currentIndex) {
                            _shopDetailLogic.updateTabIndex(currentIndex);
                          },
                          //TABS USED
                          tabs: const [
                            Tab(text: 'Book the appointment'),
                            Tab(text: 'About'),
                          ],
                        )),
                  ),
                ),

                if (_shopDetailLogic.tabIndex == 0)
                  SizedBox(
                      height: 650,
                      child: Center(
                        child: BookingCalendar(
                          availableSlotColor: Colors.green,
                          bookingGridCrossAxisCount: 3,
                          bookingGridChildAspectRatio: 1,
                          bookingService:
                              _shopDetailLogic.newBooking,
                          bookingButtonColor: Colors.green,
                          bookingButtonText: 'Book Now',
                          formatDateTime: (dateTime) {
                            var dt = DateFormat.jm().format(dateTime);
                            return '${dt}';
                          },
                          convertStreamResultToDateTimeRanges:
                              _shopDetailLogic.convertStreamResultMock,
                          getBookingStream:
                              _shopDetailLogic.getBookingStreamMock,
                          uploadBooking: ({required newBooking}) async {
                            return _shopDetailLogic.uploadBookingMock(
                                newBooking: newBooking, context: context);
                          },
                        ),
                      )),

                if (_shopDetailLogic.tabIndex == 1)
                  Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),

                      ///---about
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  '${widget.shopModel.get('about')}',
                                  style: state.shopInfoValueTextStyle),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 17,
                      ),

                      ///---phone
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Phone Number',
                              style: state.shopInfoLabelTextStyle),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Get.find<GeneralController>().makePhoneCall(
                                      '${widget.shopModel.get('phone')}');
                                },
                                child: Text(
                                    '${widget.shopModel.get('phone')}',
                                    style: state.shopInfoValueTextStyle),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 17,
                      ),

                      ///---website
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Website',
                              style: state.shopInfoLabelTextStyle),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  launch(
                                      '${widget.shopModel.get('website_address')}');
                                },
                                child: Text(
                                    '${widget.shopModel.get('website_address')}',
                                    style: state.shopInfoValueTextStyle),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 17,
                      ),

                      ///---address
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Address',
                              style: state.shopInfoLabelTextStyle),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  MapsLauncher.launchCoordinates(
                                      double.parse(widget.shopModel
                                          .get('lat')
                                          .toString()),
                                      double.parse(widget.shopModel
                                          .get('lng')
                                          .toString()),
                                      'Here');
                                },
                                child: Text(
                                    '${widget.shopModel.get('address')}',
                                    textDirection: TextDirection.ltr,
                                    style: state.shopInfoValueTextStyle),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      ///---map
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                            onMapCreated: _shopDetailLogic.onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _shopDetailLogic.center!,
                              zoom: 15.0,
                            ),
                            mapType: _shopDetailLogic.currentMapType,
                            markers: _shopDetailLogic.markers,
                            onCameraMove: _shopDetailLogic.onCameraMove,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
