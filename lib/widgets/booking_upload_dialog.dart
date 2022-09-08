import 'package:com.tsaveuser.www/modules/shop_detail/logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.tsaveuser.www/utils/color.dart';

class UploadDialog extends StatelessWidget {
  const UploadDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return GetBuilder<ShopDetailLogic>(builder: (controller) {
    return Dialog(
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextFormField(
                maxLines: 3,
                controller: controller.textEditingController,
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: "Enter your problem",
                  border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.5))),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.5))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: customThemeColor)),
                  errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Field Required';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: InkWell(
                    onTap: controller.sendRequest,
                    child: Container(
                      height: 55,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: customThemeColor,
                      ),
                      child: Center(
                        child: Text(
                          "Send Request",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: InkWell(
                    onTap: () async {
                      Get.back();
                      Get.back();
                    },
                    child: Container(
                      height: 55,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: customThemeColor,
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  
    },);
  
  }
}
