import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tsaveuser.www/controllers/general_controller.dart';
import 'package:com.tsaveuser.www/modules/shop_detail/logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
class AboutShop extends StatelessWidget {
  const AboutShop({super.key, required this.shopModel});
  final DocumentSnapshot<Map<String, dynamic>> shopModel;

  @override
  Widget build(BuildContext context) {
    var _shopDetailLogic = Get.find<ShopDetailLogic>();
    var state = _shopDetailLogic.state;

    return Column(
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
                child: Text('${shopModel.get('about')}',
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
            Text('Phone Number', style: state.shopInfoLabelTextStyle),
            const SizedBox(
              width: 50,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Get.find<GeneralController>()
                        .makePhoneCall('${shopModel.get('phone')}');
                  },
                  child: Text('${shopModel.get('phone')}',
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
            Text('Website', style: state.shopInfoLabelTextStyle),
            const SizedBox(
              width: 50,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    // ignore: deprecated_member_use
                    launch('${shopModel.get('website_address')}');
                  },
                  child: Text('${shopModel.get('website_address')}',
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
            Text('Address', style: state.shopInfoLabelTextStyle),
            const SizedBox(
              width: 50,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    MapsLauncher.launchCoordinates(
                        double.parse(shopModel.get('lat').toString()),
                        double.parse(shopModel.get('lng').toString()),
                        'Here');
                  },
                  child: Text('${shopModel.get('address')}',
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
    );
  }
}
