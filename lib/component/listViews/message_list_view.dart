import 'package:flutter/material.dart';
import 'package:insurance/isModel/channels/dataModel/is_channel_data_model.dart';
import 'package:insurance/isModel/channels/dataModel/is_message_data_model.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';

class MessageListView extends BaseScreen {
  final ISChannelDataModel dataModel;
  const MessageListView({Key? key,required this.dataModel}) : super(key: key);
  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends BaseScreenState<MessageListView> {
  List<ISMessageDataModel>? messageList;

  @override
  void initState() {
    setState(() {
      messageList=widget.dataModel.arrayMessages;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      cacheExtent: 1000,
      itemCount: messageList!.length,
      itemBuilder: (BuildContext context, int index) {
        var data=messageList![index];
        return Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                child: data.amISender()
                    ? Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width,
                                  color: AppColors.gray_light,
                                  padding: EdgeInsets.only(
                                      top: 30,
                                      left: 5,
                                      right: 5,
                                      bottom: 5),
                                  child: Text(data.szMessage),
                                ),
                                SizedBox(height: 10),
                                Text(ISUtilsDate.getStringFromDateTimeWithFormat(data.dateCreateAt,ISEnumDateTimeFormat.MMddyyyy_hhmma.value, false),style:
                                AppStyles.textSmall.copyWith(color: AppColors.gray_dark),
                                ),
                              ],
                            )),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.only(bottom: 30
                          ),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(25.0),
                            child: Container(
                              alignment: Alignment.center,
                              color: AppColors.avatar,
                              height: 50,width: 50,
                              child: Text(ISUtilsString.getInitialsFromName(data.modelCreateBy.szName)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ):Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(25.0),
                            child: Container(
                              alignment: Alignment.center,
                              color: AppColors.avatar,
                              height: 50,width: 50,
                              child: Text(ISUtilsString.getInitialsFromName(data.modelCreateBy.szName)),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width,
                                  color: AppColors.gray_light,
                                  padding: EdgeInsets.only(
                                      top: 30,
                                      left: 5,
                                      right: 5,
                                      bottom: 5),
                                  child: Text(data.szMessage),
                                ),
                                SizedBox(height: 10),
                                Text(ISUtilsDate.getStringFromDateTimeWithFormat(data.dateCreateAt,ISEnumDateTimeFormat.MMMdyyyy_hhmma.value, false),style:
                                  AppStyles.textSmall.copyWith(color: AppColors.gray_dark),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                )),
            SizedBox(height: 10)
          ],
        );
      },
    );
  }
}
