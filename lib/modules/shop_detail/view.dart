import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tsaveuser.www/modules/shop_detail/tabs/about_shop.dart';
import 'package:com.tsaveuser.www/modules/shop_detail/tabs/booking_appointment.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import '../image_full_view/view.dart';
import 'logic.dart';
import 'state.dart';

class ShopDetailPage extends StatefulWidget {
  const ShopDetailPage({Key? key, required this.shopModel}) : super(key: key);
  final DocumentSnapshot<Map<String, dynamic>> shopModel;

  @override
  _ShopDetailPageState createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
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
    logic = Get.put(ShopDetailLogic(shopModel: widget.shopModel));
    logic.currentShop(widget.shopModel);
    state = logic.state;
    Get.find<ShopDetailLogic>().updateCenter(LatLng(
      double.parse(widget.shopModel.get('lat').toString()),
      double.parse(widget.shopModel.get('lng').toString()),
    ));
    Get.find<ShopDetailLogic>()
        .onAddMarkerButtonPressed(context, widget.shopModel.get('name'));
    Get.find<GeneralController>()
        .checkWishList(context, widget.shopModel.get('id'), checkWishList);
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
                  Get.find<GeneralController>()
                      .deleteWishList(context, widget.shopModel.get('id'));
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
                              networkImage: '${widget.shopModel.get('image')}',
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
                              // Text(
                              //   '${widget.shopModel.data()!['open_time']} - ${widget.shopModel.data()!['close_time']}',
                              //   style: state.productPriceStyle!.copyWith(
                              //       color: customTextblackColor, fontSize: 14),
                              // ),
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
                  BookginAppointment(shopModel: widget.shopModel),
                if (_shopDetailLogic.tabIndex == 1)
                  AboutShop(shopModel: widget.shopModel)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
