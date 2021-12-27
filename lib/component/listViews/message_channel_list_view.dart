import 'package:flutter/material.dart';
import 'package:insurance/isModel/channels/dataModel/is_channel_data_model.dart';
import 'package:insurance/listeners/row_item_click_listner.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';

class MessageChannelListView extends BaseScreen {
  final List<ISChannelDataModel> arrayChannels;
  final RowItemClickListener<ISChannelDataModel>? itemClickListener;
  const MessageChannelListView(
      {Key? key, required this.arrayChannels, this.itemClickListener})
      : super(key: key);

  @override
  _MessageChannelListViewState createState() => _MessageChannelListViewState();
}

class _MessageChannelListViewState extends BaseScreenState<MessageChannelListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return   ListView.builder(
      shrinkWrap: true,
      itemCount: widget.arrayChannels.length,
      itemBuilder: (context, index) {
        final data = widget.arrayChannels[index];
        return Container(
            child: InkWell(
              onTap: () {
                widget.itemClickListener?.call(data, index);
              },
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(data.szName,
                              style: AppStyles.inputTextStyle
                                  .copyWith(
                                  fontSize:
                                  AppDimens.text_size)),
                        ),
                        Container(
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                              color: AppColors.gray_darkest,
                            )),
                      ]),
                  Divider(
                      height: 30,
                      thickness: 0.5,
                      color: AppColors.gray_dark),
                ],
              ),
            ));
      },
    );
  }
}
