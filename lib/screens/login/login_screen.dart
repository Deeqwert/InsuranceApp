import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insurance/isModel/communications/is_network_reachability_manager.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:insurance/screens/base/main_screen.dart';
import 'package:insurance/screens/login/forgot_password.dart';
import 'package:insurance/screens/login/registration.dart';


class LoginScreen extends BaseScreen {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseScreenState<LoginScreen> {

  //Login fields
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();

  bool isLoginButtonEnable=false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        )
    );
    edtEmail.text = "onseentest@gmail.com";
    edtPassword.text = "pass1!";
    _updateLoginButton();
  }

  _gotoMainScreen() {
    Navigator.push(
      context,
      createRoute(const MainScreen()),
    );
  }

  _gotoRegisterScreen() {
    Navigator.push(
      context,
      createRoute(const RegistrationScreen()),
    );
  }

  _gotoForgotPasswordScreen() {
    Navigator.push(
      context,
      createRoute(const ForgotPasswordScreen()),
    );
  }

  _updateLoginButton(){
   if(edtEmail.text.toString().length==0||edtPassword.text.toString().length==0){
     setState(() {
       isLoginButtonEnable=false;
     });
   }else{
     setState(() {
       isLoginButtonEnable=true;
     });
   }
  }


  _requestLogin() {
    if (!isLoginButtonEnable) return;
    final email = edtEmail.text;
    final password = edtPassword.text;
    if(!ISNetworkReachabilityManager.sharedInstance.isConnected()) {
      showToast("No internet connection available.");
      return;
    }
    showProgressHUD();
    ISUserManager.sharedInstance.requestUserLogin(email, password,
            (responseDataModel) {
          hideProgressHUD();
          if (responseDataModel.isSuccess()) {
            if (ISUserManager.sharedInstance.currentUser != null &&
                ISUserManager.sharedInstance.currentUser!.isValid()) {
              ISUserManager.sharedInstance.saveToLocalStorage();
              _gotoMainScreen();
            } else {
              showToast("We've encountered an issue.");
            }
          } else {
            showToast(responseDataModel.getBeautifiedErrorMessage());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                       physics:new NeverScrollableScrollPhysics(),
                child:Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/background_image.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2),
                        padding: AppDimens.activity_margin_large,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                right: 0,left: 0,bottom: 0,top: 50,
                                child:   Column(
                                  children: [
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
                                          SizedBox(height: 30),
                                          Text(AppStrings.email,style: TextStyle(color: AppColors.grey_text_view)),
                                          Container(
                                            height: AppDimens.editTextHeight,
                                            margin: EdgeInsets.only(left: AppDimens.activity_margin.left,right: AppDimens.activity_margin.right),
                                            padding: AppDimens.padding_edit_text,
                                            child: TextFormField(
                                                controller: edtEmail,
                                                textInputAction: TextInputAction.done,
                                                style: AppStyles.inputTextStyle,
                                                obscureText: false,
                                                onChanged: (text){
                                                  _updateLoginButton();
                                                },
                                                keyboardType: TextInputType.visiblePassword,
                                                decoration: AppStyles.textInputDecoration
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Container(
                                              alignment: Alignment.topRight,
                                              margin: EdgeInsets.only(left: 10,right: 20),
                                              child: InkWell(
                                                onTap: (){
                                                  _gotoRegisterScreen();
                                                },
                                                child: Text(AppStrings.new_user_register,style:AppStyles.buttonTransparent),
                                              )
                                          ),
                                          SizedBox(height: 5),
                                          Text(AppStrings.password,style: TextStyle(color: AppColors.grey_text_view)),
                                          Container(
                                            height: AppDimens.editTextHeight,
                                            margin: EdgeInsets.only(left: AppDimens.activity_margin.left,right: AppDimens.activity_margin.right),
                                            padding: AppDimens.padding_edit_text,
                                            child: TextFormField(
                                                onChanged:(text){
                                                _updateLoginButton();
                                                },
                                                controller: edtPassword,
                                                textInputAction: TextInputAction.done,
                                                style: AppStyles.inputTextStyle,
                                                obscureText: true,
                                                keyboardType: TextInputType.visiblePassword,
                                                decoration: AppStyles.textInputDecoration
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Container(
                                              alignment: Alignment.topRight,
                                              margin: EdgeInsets.only(left: 10,right: 20),
                                              child: InkWell(
                                                onTap: (){
                                                  _gotoForgotPasswordScreen();
                                                },
                                                child: Text(AppStrings.forgot_pass,style:AppStyles.buttonTransparent),
                                              )
                                          ),
                                          SizedBox(height: 50),
                                          Container(
                                            margin: EdgeInsets.only(left: AppDimens.activity_margin.left,right: AppDimens.activity_margin.right),
                                            width: MediaQuery.of(context).size.width,
                                            child:  ElevatedButton(
                                              onPressed: () {
                                                _requestLogin();
                                              },
                                              style: AppStyles.buttonSquareGreen.copyWith(backgroundColor: MaterialStateProperty.all(isLoginButtonEnable?AppColors.blue_button:AppColors.grey_button)),
                                              child: Text(
                                                AppStrings.log_in,
                                                textAlign: TextAlign.center,
                                                style: AppStyles.buttonTextStyle,
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                  ],
                                ),),
                              Positioned(right: 50,left: 50,bottom: 50,top: 0,
                                  child:  Container(
                                    alignment: Alignment.topCenter,
                                    child:  Image.asset(
                                      'assets/images/logo_image_shadow.png',
                                      fit: BoxFit.cover,
                                      width: 100,height: 100,
                                    ),
                                  ))
                            ],
                          )
                        )
                    )
                )) ,
                ))));
  }
}
                  