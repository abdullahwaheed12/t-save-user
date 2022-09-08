import 'dart:developer';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tsaveuser.www/modules/shop_detail/view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import 'logic.dart';
import 'state.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final FavouritesLogic logic = Get.put(FavouritesLogic());

  final FavouritesState state = Get.find<FavouritesLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: true,
        title: Text(
          'Favourites',
          style: state.appBarTextStyle,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            ///---wishlist-list for only current user
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('wishList')
                    .where('uid',
                        isEqualTo: Get.find<GeneralController>()
                            .boxStorage
                            .read('uid'))
                    .snapshots(),
                builder: (context, wishListSnapshot) {
                  if (wishListSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    log('Waiting');
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(18, 15, 18, 5),
                      child: SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: SkeletonLoader(
                          period: const Duration(seconds: 2),
                          highlightColor: Colors.grey,
                          direction: SkeletonDirection.ltr,
                          builder: Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    );
                  } else if (wishListSnapshot.hasData) {
                    if (wishListSnapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'Record not found',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      );
                    } else {
                      return Wrap(
                        children: List.generate(
                            wishListSnapshot.data!.docs.length, (index) {
                          //shops wish list
                          return StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('shop')
                                  .where('id',
                                      isEqualTo: wishListSnapshot
                                          .data!.docs[index]
                                          .get('w_id'))
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  log('Waiting');
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        18, 15, 18, 5),
                                    child: SizedBox(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width,
                                      child: SkeletonLoader(
                                        period: const Duration(seconds: 2),
                                        highlightColor: Colors.grey,
                                        direction: SkeletonDirection.ltr,
                                        builder: Container(
                                          height: 120,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasData) {
                                  return FadedSlideAnimation(
                                    child: Wrap(
                                      children: List.generate(
                                          snapshot.data!.docs.length, (index) {
                                        log('length  ${snapshot.data!.docs.length}');

                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 30, 15, 0),
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(ShopDetailPage(
                                                  shopModel: snapshot
                                                      .data!.docs[index]));
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(19),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Row(
                                                  children: [
                                                    ///---image
                                                    Hero(
                                                      tag:
                                                          '${snapshot.data!.docs[index].get('image')}',
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: Container(
                                                          height: 80,
                                                          width: 80,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .grey,
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            child:
                                                                Image.network(
                                                              '${snapshot.data!.docs[index].get('image')}',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    ///---detail
                                                    Expanded(
                                                        child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ///---name
                                                            Text(
                                                                '${snapshot.data!.docs[index].get('name')}',
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color:
                                                                        customTextblackColor)),
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .01,
                                                            ),

                                                            ///---timings
                                                            Text(
                                                                '${snapshot.data!.docs[index].get('open_time')} - ${snapshot.data!.docs[index].get('close_time')}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: customTextblackColor
                                                                        .withOpacity(
                                                                            0.5))),
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .01,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                ///---distance
                                                                Text(
                                                                    '${(Geolocator.distanceBetween(Get.find<GeneralController>().latitude!, Get.find<GeneralController>().longitude!, double.parse(snapshot.data!.docs[0].get('lat').toString()), double.parse(snapshot.data!.docs[0].get('lng').toString())) ~/ 1000)}km',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: customTextblackColor
                                                                            .withOpacity(0.5))),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    beginOffset: const Offset(0.3, 0.2),
                                    endOffset: const Offset(0, 0),
                                    slideCurve: Curves.linearToEaseOut,
                                  );
                                } else {
                                  return Text(
                                    'Record not found',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  );
                                }
                              });
                        }),
                      );
                    }
                  } else {
                    return Text(
                      'Record not found',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    );
                  }
                }),

            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
          ],
        ),
      ),
    );
  }
}
