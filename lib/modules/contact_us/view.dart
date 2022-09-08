
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:com.tsaveuser.www/controllers/general_controller.dart';
import 'package:com.tsaveuser.www/utils/color.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logic.dart';
import 'state.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final HelpLogic logic = Get.put(HelpLogic());

  final HelpState state = Get.find<HelpLogic>().state;

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
          'Contact Us',
          style: state.appBarTextStyle,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: customThemeColor.withOpacity(0.19),
                        blurRadius: 40,
                        spreadRadius: 0,
                        offset:
                            const Offset(0, 22), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      launch('mailto:admin@T-Save.com');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Got a question that can't be answered via the FAQ page?  Email us at",
                          style: state.contentTextStyle,
                        ),
                        Text(
                          'admin@T-Save.com',
                          style: state.contentTextStyle!
                              .copyWith(color: customThemeColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
           
            // Phone no
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: InkWell(
                onTap: (){
                  Get.find<GeneralController>().makePhoneCall('03040586858');
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: customThemeColor.withOpacity(0.19),
                          blurRadius: 40,
                          spreadRadius: 0,
                          offset:
                              const Offset(0, 22), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact us at',
                          style: state.contentTextStyle,
                        ),
                        Text(
                          '03040586858',
                          style: state.contentTextStyle!
                              .copyWith(color: customThemeColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
             //feedback
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: customThemeColor.withOpacity(0.19),
                        blurRadius: 40,
                        spreadRadius: 0,
                        offset:
                            const Offset(0, 22), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      launch('mailto:feedback@bookabite.app');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share feedback to help us improve our services at',
                          style: state.contentTextStyle,
                        ),
                        Text(
                          'feedback@T-Save.com',
                          style: state.contentTextStyle!
                              .copyWith(color: customThemeColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
           //facebook page
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: customThemeColor.withOpacity(0.19),
                        blurRadius: 40,
                        spreadRadius: 0,
                        offset:
                            const Offset(0, 22), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      launch(
                          'https://www.facebook.com/');
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/FacebookOctDenoiserBeauty_001 copy.png',
                          height: 90,
                          width: 90,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'T-Save Facebook',
                                style: state.contentTextStyle,
                              ),
                              Text(
                                '@T-Save',
                                style: state.contentTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Instagram
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: customThemeColor.withOpacity(0.19),
                        blurRadius: 40,
                        spreadRadius: 0,
                        offset:
                            const Offset(0, 22), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      launch('http://www.instagram.com/');
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/InstagramOctDenoiserBeauty_001 copy.png',
                          height: 90,
                          width: 90,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'T-Save Instagram',
                                style: state.contentTextStyle,
                              ),
                              Text(
                                '@T-Save',
                                style: state.contentTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Twitter
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: customThemeColor.withOpacity(0.19),
                        blurRadius: 40,
                        spreadRadius: 0,
                        offset:
                            const Offset(0, 22), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      launch('http://www.twitter.com/');
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/TwitterOctDenoiserBeauty_001 copy.png',
                          height: 90,
                          width: 90,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'T-Save Twitter',
                                style: state.contentTextStyle,
                              ),
                              Text(
                                '@T-Save',
                                style: state.contentTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
           
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
