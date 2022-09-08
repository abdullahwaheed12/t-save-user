import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tsaveuser.www/modules/shop_detail/view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_detail_model.dart';
import '../../utils/text_style.dart';

class ServiceProvidersListPage extends StatefulWidget {
  const ServiceProvidersListPage({Key? key, required this.categoryName})
      : super(key: key);
  final String categoryName;

  @override
  State<ServiceProvidersListPage> createState() =>
      _ServiceProvidersListPageState();
}

class _ServiceProvidersListPageState extends State<ServiceProvidersListPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),

          ///---heading
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 30, 0),
                    child: Text(
                      widget.categoryName,
                      style: kTopHeadingStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('shop')
                  .where(
                    'service_type',
                    isEqualTo: widget.categoryName,
                  )
                  .where(
                    'isActive',
                    isEqualTo: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No Record Found'));
                  }
                  return SizedBox(
                    width: size.width,
                    child: Center(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemExtent: 140,
                        itemCount: snapshot.data?.docs.length,
                        padding: EdgeInsets.all(16),
                        itemBuilder: (BuildContext context, int index) {
                          QueryDocumentSnapshot<Map<String, dynamic>>
                              documentSnapshot = snapshot.data!.docs[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () {
                               
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => ShopDetailPage(
                                        shopModel: documentSnapshot),
                                  ),
                                );
                              },
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                '${snapshot.data?.docs[index].data()['image']}',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                snapshot.data?.docs[index]
                                                    .data()['name'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                snapshot.data?.docs[index]
                                                    .data()['address'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                snapshot.data?.docs[index]
                                                    .data()['service_type'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}

Future<List<ProductDetailModel>> getProductList() async {
  var listOfProductModel = <ProductDetailModel>[];

  var snapshot = await FirebaseFirestore.instance
      .collection('service_provider_user_data')
      .get();

  for (var e in snapshot.docs) {
    var querySnapshot =
        await e.reference.collection('user_products_listings').get();

    for (var element in querySnapshot.docs) {
      // print('productlist $querySnapshot');

      var productDetailModel = ProductDetailModel.fromMap(element.data());
      listOfProductModel.add(productDetailModel);
    }
  }
  print(
      '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
  print(listOfProductModel);
  return listOfProductModel;
}
