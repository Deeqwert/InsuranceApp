import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/form_details_screen.dart';
import 'package:insurance/screens/base/base_screen.dart';

class FormsListScreen extends BaseScreen {
  @override
  _FormsListScreenState createState() => _FormsListScreenState();
}

class _FormsListScreenState extends BaseScreenState<FormsListScreen> {
  @override
  void initState() {
    super.initState();
  }

  _gotoAdjusterformDetailsScreen() {
    Navigator.push(
      context,
      createRoute(FormDetailsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: AppColors.button_en_route),
        title: Text("Adjuster Forms",
            style: AppStyles.inputTextStyle
                .copyWith(color: AppColors.font_white_color)),
        backgroundColor: AppColors.button_en_route,
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: AppColors.background_white),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Inspection Multi Form",
                  style: AppStyles.textLarge.copyWith(
                      color: AppColors.blue_dark_button,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 20),
                      child: InkWell(
                    onTap: () {
                      _gotoAdjusterformDetailsScreen();
                    },
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text("Simple Form",
                                    style: AppStyles.inputTextStyle.copyWith(
                                        fontSize: AppDimens.text_normal_size, color: AppColors.black,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Container(
                                  child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                                color: AppColors.black,
                              )),
                            ]),
                      ],
                    ),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
