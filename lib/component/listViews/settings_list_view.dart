import 'package:flutter/material.dart';
import 'package:insurance/isModel/appManager/dataModel/is_app_setting_data_model.dart';
import 'package:insurance/isModel/appManager/is_app_manager.dart';
import 'package:insurance/listeners/row_item_click_listner.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/screens/base/base_screen.dart';


class SettingsListView extends BaseScreen {
  final List<ISEnumSettingMapViewPreference> arrayMapApps;
  final RowItemClickListener<ISEnumSettingMapViewPreference>? itemClickListener;

  const SettingsListView(
      {Key? key, required this.arrayMapApps, this.itemClickListener})
      : super(key: key);

  @override
  _SettingsListViewState createState() => _SettingsListViewState();
}

class _SettingsListViewState extends BaseScreenState<SettingsListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.arrayMapApps.length,
      itemBuilder: (BuildContext context, int index) {
        var mapPreference = widget.arrayMapApps[index];
        String _txtName = mapPreference.title;
        bool _iconTick = false;
        if (ISAppManager.sharedInstance.modelSettings
            .enumMapPreference ==
            mapPreference) {
          _iconTick = true;
        } else {
          _iconTick = false;
        }
        return InkWell(
          onTap: () {
            widget.itemClickListener?.call(mapPreference, index);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(_txtName,
                      style: TextStyle(
                          color: AppColors.black).copyWith(fontSize: AppDimens.text_size)),
                  _iconTick
                      ? Image.asset(
                    'assets/images/ic_select_navigation.png',
                    width: 20,
                    color: AppColors.blue_button,
                    height: 20,
                  )
                      : const SizedBox(
                    width: 20,
                    height: 20,
                  )
                ],
              ),
              const Divider(
                  height: 40,
                  color: AppColors.gray),
            ],
          ),
        );
      },
    );
  }
}