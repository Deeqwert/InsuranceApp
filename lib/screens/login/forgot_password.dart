import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insurance/isModel/communications/is_network_reachability_manager.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:insurance/utils/utils_base_functions.dart';


class ForgotPasswordScreen extends BaseScreen {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends BaseScreenState<ForgotPasswordScreen> {
  bool isResetButtonEnable=false;
  final edtEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateResetButton();
    }

  _updateResetButton(){
    if(edtEmail.text.toString().length==0){
      setState(() {
        isResetButtonEnable=false;
      });
    }else{
      setState(() {
        isResetButtonEnable=true;
      });
    }
  }

  onClickFragmentDialog() {
    Navigator.pop(context);
  }

  _requestResetPassword() {
    if (!isResetButtonEnable) return;
    final email = edtEmail.text;
    if(!UtilsBaseFunction.isValidEmail(email)){
      showToast("Email is not correct.");
      return;
    }

    if (ISNetworkReachabilityManager.sharedInstance.isConnected()) {
      showToast("No internet connection available.");
      return;
    }
    showProgressHUD();
    ISUserManager.sharedInstance.requestUserForgotPassword(email,
            (responseDataModel) {
          hideProgressHUD();
          if (responseDataModel.isSuccess()) {
            UtilsBaseFunction.showAlert(context, "Reset Password",
                "An email was sent to the email address you entered.\n\nPlease use the link in the email to reset your password ",onClickFragmentDialog());
          } else {
            showToast(responseDataModel.getBeautifiedErrorMessage());
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
              physics: NeverScrollableScrollPhysics(),
                child:Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/background_image.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                        margin:EdgeInsets.only(top: Platform.isIOS?30:20),
                        padding: AppDimens.activity_margin_large,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child:   Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child:  Image.asset(
                                        'assets/images/ic_back_gray.png',
                                        width: 15,height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(),
                                  Expanded(child:
                                  Container(
                                      alignment: Alignment.center,
                                      child: Text(AppStrings.forgot_pass_,style: AppStyles.textLarge.copyWith(color: AppColors.font_white_color),)
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: AppDimens.activity_margin_large,
                              decoration: BoxDecoration(
                                color: AppColors.background_white_transparent_85,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppStrings.email,style: TextStyle(color: AppColors.grey_text_view)),
                                  Container(
                                    height: AppDimens.editTextHeight,
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left,right: AppDimens.activity_margin.right),
                                    padding: AppDimens.padding_edit_text,
                                    child: TextFormField(
                                        controller: edtEmail,
                                        onChanged: (text){
                                          _updateResetButton();
                                        },
                                        textInputAction: TextInputAction.done,
                                        style: AppStyles.inputTextStyle,
                                        obscureText: false,
                                        keyboardType: TextInputType.visiblePassword,
                                        decoration: AppStyles.textInputDecoration
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Container(
                                    margin: EdgeInsets.only(left: AppDimens.activity_margin.left,right: AppDimens.activity_margin.right),
                                    width: MediaQuery.of(context).size.width,
                                    child:  ElevatedButton(
                                      onPressed: () {
                                        _requestResetPassword();
                                      },
                                      style: AppStyles.buttonSquareGreen.copyWith(backgroundColor: MaterialStateProperty.all(isResetButtonEnable?AppColors.blue_button:AppColors.grey_button)),
                                      child: Text(
                                        AppStrings.forgot_pass_btn,
                                        textAlign: TextAlign.center,
                                        style: AppStyles.buttonTextStyle,
                                      ),
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ],
                        )
                    )
                )) ,
          )
      ),
    );
  }
}
