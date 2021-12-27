import 'package:flutter/material.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';

class FormDetailsScreen extends BaseScreen {
  @override
  _FormDetailsScreenState createState() => _FormDetailsScreenState();
}

class _FormDetailsScreenState extends BaseScreenState<FormDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.button_en_route,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("Adjuster Form Details",
            style: AppStyles.inputTextStyle
                .copyWith(color: AppColors.font_white_color)),
        actions: <Widget>[
          Padding(
            padding: AppDimens.activity_vertical_margin.copyWith(top: 20),
            child: GestureDetector(
              onTap: () {
                // _gotoAccountDetailsScreen();
              },
              child: Text("Save",
                  style: AppStyles.inputTextStyle.copyWith(
                      color: AppColors.font_white_color,
                      fontSize: AppDimens.text_normal_size)),
            ),
          )
        ],
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
              Text("Page",
                  style: AppStyles.normalText.copyWith(
                      color: AppColors.black, fontWeight: FontWeight.w700)),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(top: 25),
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text("Section",
                                        style: AppStyles.inputTextStyle
                                            .copyWith(
                                                fontSize:
                                                    AppDimens.text_normal_size,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w700)),
                                  ),
                                  Container(
                                      child: Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    size: 25,
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
