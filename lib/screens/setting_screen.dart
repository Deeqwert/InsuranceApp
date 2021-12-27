import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insurance/component/listViews/settings_list_view.dart';
import 'package:insurance/isModel/appManager/dataModel/is_app_setting_data_model.dart';
import 'package:insurance/isModel/appManager/is_app_manager.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';

class SettingScreen extends BaseScreen {
  const SettingScreen({Key? key}) : super(key: key);
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends BaseScreenState<SettingScreen> {
  final List<ISEnumSettingMapViewPreference> _arrayMapApps = [];
  @override
  void initState() {
    super.initState();
    _refreshFields();
  }

  _refreshFields() async {
    setState(() {
      for (var mapApp in ISEnumSettingMapViewPreference.values) {
        if (Platform.isAndroid &&
            mapApp != ISEnumSettingMapViewPreference.appleMaps) {
          _arrayMapApps.add(mapApp);
        }
        if (Platform.isIOS &&
            mapApp != ISEnumSettingMapViewPreference.hereWeGo) {
          _arrayMapApps.add(mapApp);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.black, //change your color here
        ),
        title: Text(AppStrings.menu_settings, style: AppStyles.inputTextStyle),
        backgroundColor: AppColors.gray_light,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          top: false,
          child: Container(
              margin: AppDimens.activity_margin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 6, bottom: 18),
                    child: Text(AppStrings.default_navigation_app,
                        style: TextStyle(color: AppColors.black)
                            .copyWith(fontSize: AppDimens.text_normal_size)),
                  ),
                  SettingsListView(
                      arrayMapApps: _arrayMapApps,
                      itemClickListener: (mapPreference, index) {
                        setState(() {
                          ISAppManager.sharedInstance.modelSettings
                              .enumMapPreference = mapPreference;
                          ISAppManager.sharedInstance.saveToLocalStorage();
                        });
                      })
                ],
              )),
        ),
      ),
    );
  }
}
