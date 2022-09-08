
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:com.tsaveuser.www/widgets/custom_drawer.dart';

import '../../controllers/general_controller.dart';
import '../../models/categories_model.dart';
import '../../utils/color.dart';
import '../serviceprovider_list_page/view.dart';
import 'logic.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeLogic _homeLogic =   Get.put(HomeLogic());
  final _generalController = Get.find<GeneralController>();

  @override
  void initState() {

    _homeLogic.currentUser(context);
    _homeLogic.updateToken();
    super.initState();
  }

  final auth = FirebaseAuth.instance;

  List<CategoriesModel> categoryModelList = [
    CategoriesModel(
      categoryName: 'Ac Operator',
      categoryImagePath:
          'https://img.freepik.com/free-vector/air-conditioning-refrigeration-services-abstract-concept-illustration-installation-repair-maintenance-air-conditioners-climate-control-systems-equipment_335657-704.jpg?w=740&t=st=1658051991~exp=1658052591~hmac=e9d4f582c2928cf9789d973c3dd47edccb5e55f171db554f485b6d2edb45c2b6',
    ),
    CategoriesModel(
      categoryName: 'Parlour',
      categoryImagePath:
          "https://img.freepik.com/free-vector/cosmetic-wreath-design-with-eyelash-curler-eyeliner-brush_83728-1850.jpg?w=740&t=st=1658052230~exp=1658052830~hmac=d846f42e682aac321fee6d483ce9fe01354b2ceb3d5faf512883958cebfe3425",
    ),
    CategoriesModel(
      categoryName: 'Home decorators',
      categoryImagePath:
          'https://img.freepik.com/free-photo/wedding-cake-decor-made-two-rocking-chairs_8353-1725.jpg?w=740&t=st=1658052288~exp=1658052888~hmac=82fccd12d070e1071fe12444c541d13e5a72fcd98383e29f6e7e692b97414a1d',
    ),
    CategoriesModel(
      categoryName: 'Plumber',
      categoryImagePath:
          'https://img.freepik.com/free-vector/colorful-plumbing-round-composition_1284-40766.jpg?w=740&t=st=1658052341~exp=1658052941~hmac=042be5f186c069c18bdee60b73e30d3fa3a74375e64c10fd2f2fef99f9069e35',
    ),
    CategoriesModel(
      categoryName: 'Photographer',
      categoryImagePath: 'https://img.freepik.com/free-psd/side-view-digital-camera-photo-studio_23-2148530161.jpg?w=740&t=st=1658052393~exp=1658052993~hmac=9a909171fcca916d66d604007e521791b8567b56a6c4cbc7df43d2b10a60cb59',
    ),
  ];

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      body: Stack(
        children: [
          ///---gradient
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                customThemeColor.withOpacity(0.3),
                customThemeColor.withOpacity(0.8),
                customThemeColor
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )),
          ),

           AdvancedDrawer(
                backdropColor: Colors.transparent,
                controller: _homeLogic.advancedDrawerController,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 300),
                childDecoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                drawer: const MyCustomDrawer(),
                child: GestureDetector(
                  onTap: () {
                    _generalController.focusOut(context);
                  },
                  child: Stack(
                    children: [
                      Scaffold(
                        appBar: AppBar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          elevation: 0,
                          leading: InkWell(
                            onTap: () {
                              _homeLogic.handleMenuButtonPressed();
                            },
                            child: ValueListenableBuilder<AdvancedDrawerValue>(
                              valueListenable:
                                  _homeLogic.advancedDrawerController,
                              builder: (_, value, __) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 5, 5, 5),
                                  child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: value.visible
                                          ? const Icon(
                                              Icons.arrow_back,
                                              size: 25,
                                              color: customTextblackColor,
                                            )
                                          : SvgPicture.asset(
                                              'assets/drawerIcon.svg')),
                                );
                              },
                            ),
                          ),
                        ),
                        body: Center(
                          child: Container(
                            width: size.width,
                            height: size.height,
                            child: GridView.builder(
                              itemCount: categoryModelList.length,
                              padding: EdgeInsets.all(16),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                maxCrossAxisExtent: size.width * 0.5,
                                mainAxisExtent: size.height * 0.3,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                CategoriesModel categoriesModel =
                                    categoryModelList[index];

                                return Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ServiceProvidersListPage(
                                              categoryName:
                                                  categoriesModel.categoryName,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        categoriesModel
                                                            .categoryImagePath,),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${categoriesModel.categoryName.toUpperCase()}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: (MediaQuery.of(context).size.width / 2) -
                            (MediaQuery.of(context).size.width * .3 / 2),
                        child: ValueListenableBuilder<AdvancedDrawerValue>(
                          valueListenable:
                              Get.find<HomeLogic>().advancedDrawerController,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: value.visible
                                  ? const SizedBox()
                                  : SafeArea(
                                      child: InkWell(
                                        onTap: () {
                                          // Get.toNamed(PageRoutes.map);
                                        },
                                        child: Container(
                                          height: 44,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .3,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: [
                                                // BoxShadow(
                                                //   color: customThemeColor
                                                //       .withOpacity(0.19),
                                                //   blurRadius: 5,
                                                //   spreadRadius: 0,
                                                //   offset: const Offset(0,
                                                //       5), // changes position of shadow
                                                // ),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Home',
                                                  style: _homeLogic.state.homeSubHeadingTextStyle,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          
        ],
      ),
    );
  }
}

//---------------------category button-------------

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onPressed;
  final bool isSelected;

  const CategoryButton(
      {Key? key,
      required this.icon,
      required this.color,
      required this.onPressed,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        onPressed.call();
      },
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      fillColor: isSelected ? color.withAlpha(100) : kLightGrey,
      constraints: const BoxConstraints.tightFor(
        width: 60,
        height: 60,
      ),
      child: Icon(
        icon,
        size: 30,
        color: color,
      ),
    );
  }
}
