import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insurance/isModel/communications/is_network_reachability_manager.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:insurance/screens/base/main_screen.dart';
import 'package:insurance/utils/user_text_validator.dart';


class RegistrationScreen extends BaseScreen {
  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends BaseScreenState<RegistrationScreen> {
  bool isSignUpButtonEnable = false;

  final edtFirstName = TextEditingController();
  final edtLastname = TextEditingController();
  final edtEmail = TextEditingController();
  final edtPhone = TextEditingController();
  final edtPassword = TextEditingController();
  final edtConfirmPassword = TextEditingController();
  UserTextValidator? validator;
  @override
  void initState() {
    super.initState();
    _updateSignInButton();
  }

  _gotoMainScreen() {
    Navigator.push(
      context,
      createRoute(const MainScreen()),
    );
  }

  _updateSignInButton() {
    if (edtFirstName.text.toString().length == 0 ||
        edtLastname.text.toString().length == 0 ||
        edtEmail.text.toString().length == 0 ||
        edtPhone.text.toString().length == 0 ||
        edtPassword.text.toString().length == 0 ||
        edtConfirmPassword.text.toString().length == 0) {
      setState(() {
        isSignUpButtonEnable = false;
      });
    } else {
      setState(() {
        isSignUpButtonEnable = true;
      });
    }
  }

  _requestSignUp() {
    if (!isSignUpButtonEnable) return;

    final firstName = edtFirstName.text;
    final lastName = edtLastname.text;
    final email = edtEmail.text;
    final phone = edtPhone.text;
    final password = edtPassword.text;

    if (validator == null) validator = new UserTextValidator();

    if (!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
      showToast("No internet connection available.");
      return;
    }

    if (validator!.validateUserName(edtFirstName) &&
        validator!.validateUserName(edtLastname) &&
        validator!.validateEmail(edtEmail) &&
        validator!.validatePhoneNumber(edtPhone) &&
        validator!.validatePassword(edtPassword) &&
        validator!.validateRepiatPassword(edtPassword, edtConfirmPassword)) {

      showProgressHUD();
      ISUserManager.sharedInstance.requestUserSignup(
          firstName, lastName, email, phone, password, (responseDataModel) {
        hideProgressHUD();
        if (responseDataModel.isSuccess()) {
          showToast("You are logged in as " + email.toString());
          _gotoMainScreen();
        } else {
          showToast(responseDataModel.getBeautifiedErrorMessage());
        }
      });
    }
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
                                            AppStrings.register,
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
                                  SizedBox(height: 30),
                                  Text(AppStrings.first_name,
                                      style: TextStyle(
                                          color: AppColors.grey_text_view)),
                                  Container(
                                    height: AppDimens.editTextHeight,
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                    padding: AppDimens.padding_edit_text,
                                    child: TextFormField(
                                        controller: edtFirstName,
                                        onChanged: (text) {
                                          _updateSignInButton();
                                        },
                                        textInputAction: TextInputAction.done,
                                        style: AppStyles.inputTextStyle,
                                        obscureText: false,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration:
                                            AppStyles.textInputDecoration),
                                  ),
                                  SizedBox(height: 5),
                                  Text(AppStrings.last_name,
                                      style: TextStyle(
                                          color: AppColors.grey_text_view)),
                                  Container(
                                    height: AppDimens.editTextHeight,
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left,right: AppDimens.activity_margin.right),
                                    padding: AppDimens.padding_edit_text,
                                    child: TextFormField(
                                        controller: edtLastname,
                                        onChanged: (text) {
                                          _updateSignInButton();
                                        },
                                        textInputAction: TextInputAction.done,
                                        style: AppStyles.inputTextStyle,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration:
                                            AppStyles.textInputDecoration),
                                  ),
                                  SizedBox(height: 5),
                                  Text(AppStrings.email,
                                      style: TextStyle(
                                          color: AppColors.grey_text_view)),
                                  Container(
                                    height: AppDimens.editTextHeight,
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left,right: AppDimens.activity_margin.right),
                                    padding: AppDimens.padding_edit_text,
                                    child: TextFormField(
                                        controller: edtEmail,
                                        onChanged: (text) {
                                          _updateSignInButton();
                                        },
                                        textInputAction: TextInputAction.done,
                                        style: AppStyles.inputTextStyle,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration:
                                            AppStyles.textInputDecoration),
                                  ),
                                  SizedBox(height: 5),
                                  Text(AppStrings.phone,
                                      style: TextStyle(
                                          color: AppColors.grey_text_view)),
                                  Container(
                                    height: AppDimens.editTextHeight,
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left,right: AppDimens.activity_margin.right),
                                    padding: AppDimens.padding_edit_text,
                                    child: TextFormField(
                                        controller: edtPhone,
                                        onChanged: (text) {
                                          _updateSignInButton();
                                        },
                                        textInputAction: TextInputAction.done,
                                        style: AppStyles.inputTextStyle,
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            AppStyles.textInputDecoration),
                                  ),
                                  SizedBox(height: 5),
                                  Text(AppStrings.password,
                                      style: TextStyle(
                                          color: AppColors.grey_text_view)),
                                  Container(
                                    height: AppDimens.editTextHeight,
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left,right: AppDimens.activity_margin.right),
                                    padding: AppDimens.padding_edit_text,
                                    child: TextFormField(
                                        controller: edtPassword,
                                        onChanged: (text) {
                                          _updateSignInButton();
                                        },
                                        obscureText: true,
                                        textInputAction: TextInputAction.done,
                                        style: AppStyles.inputTextStyle,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration:
                                            AppStyles.textInputDecoration),
                                  ),
                                  SizedBox(height: 5),
                                  Text(AppStrings.confirm_password,
                                      style: TextStyle(
                                          color: AppColors.grey_text_view)),
                                  Container(
                                    height: AppDimens.editTextHeight,
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left,right: AppDimens.activity_margin.right),
                                    padding: AppDimens.padding_edit_text,
                                    child: TextFormField(
                                        controller: edtConfirmPassword,
                                        onChanged: (text) {
                                          _updateSignInButton();
                                        },
                                        obscureText: true,
                                        textInputAction: TextInputAction.done,
                                        style: AppStyles.inputTextStyle,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration:
                                            AppStyles.textInputDecoration),
                                  ),
                                  SizedBox(height: 50),
                                  Container(
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left,right: AppDimens.activity_margin.right),
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _requestSignUp();
                                      },
                                      style: AppStyles.buttonSquareGreen
                                          .copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      isSignUpButtonEnable
                                                          ? AppColors
                                                              .blue_button
                                                          : AppColors
                                                              .grey_button)),
                                      child: Text(
                                        AppStrings.register,
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
