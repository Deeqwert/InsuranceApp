import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/user/dataModel/is_user_data_model.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:insurance/utils/user_text_validator.dart';

class ProfileScreen extends BaseScreen {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseScreenState<ProfileScreen> {
  ISUserDataModel userData = ISUserManager.sharedInstance.currentUser!;
  UserTextValidator? validator;
  final edtName = TextEditingController();
  final edtUsername = TextEditingController();
  final edtEmail = TextEditingController();
  final edtPhone = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (ISUserManager.sharedInstance.currentUser == null) return;
    edtName.text = userData.szName;
    edtUsername.text = userData.szUserName;
    edtEmail.text = userData.szEmail;
    edtPhone.text = ISUtilsString.beautifyPhoneNumber(userData.szPhone);
  }

  bool validationCheck() {
    if (validator == null) validator = new UserTextValidator();
    if (edtName.text.toString().isEmpty) {
      showToast("Please input Name");
      return false;
    }
    if (edtUsername.text.toString().isEmpty) {
      showToast("Please input username");
      return false;
    }
    if (edtEmail.text.toString().isEmpty) {
      showToast("Please input email address.");
      return false;
    }
    String phoneNumber = edtPhone.text.toString().replaceAll("[^\\d]", "");
    if (phoneNumber.length < 10) {
      showToast("Please input valid phone number.");
      return false;
    }
    return true;
  }

  _requestSave() {
    if (!validationCheck()) return;
    showProgressHUD();
    Map<String, dynamic> params = {};

    String phoneNumber = edtPhone.text.toString().replaceAll("[^\\d]", "");
    params["name"] = edtName.text.toString();
    params["username"] = edtUsername.text.toString();
    params["email"] = edtEmail.text.toString();
    params["phone"] = phoneNumber;

    ISUserManager.sharedInstance.requestUpdateUserWithDictionary(params,
            (responseDataModel) {
          hideProgressHUD();
          if (responseDataModel.isSuccess()) {

          } else {
            hideProgressHUD();
            if (responseDataModel.errorMessage.isNotEmpty) {
              showToast(responseDataModel.getBeautifiedErrorMessage());
            } else {
              showToast("Sorry, we've encountered an error");
            }
          }
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
                child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/background_image.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                        margin: EdgeInsets.only(top: Platform.isIOS ? 30 : 20),
                        padding: AppDimens.activity_margin_large,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Image.asset(
                                        'assets/images/ic_back_gray.png',
                                        width: 15,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(),
                                  Expanded(
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            AppStrings.menu_profile,
                                            style: AppStyles.textLarge.copyWith(
                                                color:
                                                    AppColors.font_white_color),
                                          ))),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: AppDimens.activity_margin_large,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.background_white_transparent_85,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(AppStrings.name,
                                      style: AppStyles.normalText),
                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left, right: AppDimens.activity_margin.right),
                                    padding: AppDimens.padding_edit_text,
                                    child: TextFormField(
                                        controller: edtName,
                                        textInputAction: TextInputAction.done,
                                        style: AppStyles.inputTextStyle,
                                        obscureText: false,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration:
                                            AppStyles.textInputDecoration),
                                  ),
                                  SizedBox(height: 5),
                                  Text(AppStrings.userName,
                                      style: AppStyles.normalText),
                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left, right: AppDimens.activity_margin.right),
                                    padding: AppDimens.padding_edit_text,
                                    child: TextFormField(
                                        enabled: false,
                                        controller: edtUsername,
                                        textInputAction: TextInputAction.done,
                                        style: AppStyles.inputTextStyle,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration: AppStyles
                                            .DisabledtextInputDecoration),
                                  ),
                                  SizedBox(height: 5),
                                  Text(AppStrings.email,
                                      style: AppStyles.normalText),
                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left, right: AppDimens.activity_margin.right),
                                    padding: AppDimens.padding_edit_text,
                                    child: TextFormField(
                                        enabled: false,
                                        controller: edtEmail,
                                        textInputAction: TextInputAction.done,
                                        style: AppStyles.inputTextStyle,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration: AppStyles
                                            .DisabledtextInputDecoration),
                                  ),
                                  SizedBox(height: 5),
                                  Text(AppStrings.phone,
                                      style: AppStyles.normalText),
                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left, right: AppDimens.activity_margin.right),
                                    padding: AppDimens.padding_edit_text,
                                    child: TextFormField(
                                        controller: edtPhone,
                                        textInputAction: TextInputAction.done,
                                        style: AppStyles.inputTextStyle,
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            AppStyles.textInputDecoration),
                                  ),
                                  SizedBox(height: 50),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _requestSave();
                                      },
                                      style: AppStyles.buttonSquareGreen
                                          .copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      AppColors.blue_button)),
                                      child: Text(
                                        AppStrings.save_btn,
                                        textAlign: TextAlign.center,
                                        style: AppStyles.buttonTextStyle,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )))),
          )),
    );
  }
}
