import 'package:flutter/material.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/listeners/row_item_click_listner.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';

class ClaimListView extends BaseScreen {
  final List<ISTaskDataModel> arrayTasks;
  final RowItemClickListener<ISTaskDataModel>? itemClickListener;

  const ClaimListView(
      {Key? key, required this.arrayTasks, this.itemClickListener})
      : super(key: key);

  @override
  _ClaimListViewState createState() => _ClaimListViewState();
}

class _ClaimListViewState extends BaseScreenState<ClaimListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.arrayTasks.length,
      itemBuilder: (context, index) {
        final data = widget.arrayTasks[index];
        return Container(
            padding: EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                widget.itemClickListener?.call(data, index);
              },
              child: Column(
                children: [
                  Card(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      elevation: 3,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                padding: AppDimens.activity_padding_small
                                    .copyWith(top: 0, bottom: 0),
                                decoration: BoxDecoration(
                                    color: data.getColorStatus(),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: AppDimens.activity_padding_small,
                                      child: Text(data.enumStatus.value,
                                          style: AppStyles.textMediumBold),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 18,
                                      color: AppColors.font_white_color,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: AppDimens.activity_margin
                                    .copyWith(left: 15, right: 15, top: 5),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Claim Number: " +
                                            data.getClaimNumber(),
                                        style: AppStyles.textNormalBold),
                                    SizedBox(height: 5),
                                    Text("Adjuster Inpection",
                                        style: AppStyles.textNormal.copyWith(
                                            color: AppColors.font_grey_color)),
                                    SizedBox(height: 5),
                                    Text(data.getContactName(),
                                        style: AppStyles.textNormal.copyWith(
                                            color: AppColors.font_black_color)),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/ic_calendar_grey.png',
                                                fit: BoxFit.cover,
                                                width: 20,
                                                height: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                  data
                                                      .getFormattedBestStartDateString(),
                                                  style: AppStyles.normalText
                                                      .copyWith(
                                                          color: AppColors
                                                              .font_black_color)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/ic_time_green.png',
                                                fit: BoxFit.cover,
                                                width: 20,
                                                height: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                  data
                                                      .getFormattedBestStartTimeString(),
                                                  style: AppStyles.normalText
                                                      .copyWith(
                                                          color: AppColors
                                                              .font_black_color)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/ic_marker_blue_dark.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                            child: Text(data.getAddress(),
                                                style: AppStyles.textNormal
                                                    .copyWith(
                                                        color: AppColors
                                                            .indigo_button))),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              )
                            ],
                          ))),
                ],
              ),
            ));
      },
    );
  }
}
