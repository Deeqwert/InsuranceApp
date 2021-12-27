import 'package:flutter/material.dart';
import 'package:insurance/component/listViews/message_channel_list_view.dart';
import 'package:insurance/isModel/channels/dataModel/is_channel_data_model.dart';
import 'package:insurance/isModel/channels/is_channel_manager.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/localNotification/is_notification_observer.dart';
import 'package:insurance/isModel/localNotification/is_notification_warden.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:insurance/screens/message_list_screen.dart';

class MessagesChannelScreen extends BaseScreen {
  const MessagesChannelScreen({Key? key}) : super(key: key);
  @override
  _MessagesChannelScreenState createState() => _MessagesChannelScreenState();
}

class _MessagesChannelScreenState
    extends BaseScreenState<MessagesChannelScreen> implements ISNotificationObserver{
  List<ISChannelDataModel> arrayChannels = [];

  @override
  void initState() {
    super.initState();
    _registerLocalNotification();
    _reloadData();
  }


  @override
  void dispose() {
    super.dispose();
    ISNotificationWarden.sharedInstance.removeObserver(this);
  }

  _registerLocalNotification() {
    ISNotificationWarden.sharedInstance.notifyTaskObservers(ISUtilsGeneral.messageListUpdated);
  }
  _reloadData() {
    setState(() {
      arrayChannels = ISChannelManager.sharedInstance.arrayChannels;
    });
  }

  _startMessageListFragment(ISChannelDataModel channelItem){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessageListScreen(channelItem: channelItem,)),
    );
  }

  _gotoMessageFragment(int pos) {
    final ISChannelDataModel channelItem =arrayChannels[pos];
    showProgressHUD();
    ISChannelManager.sharedInstance.requestGetChannelMessages(channelItem,(responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        _startMessageListFragment(channelItem);
      } else {
       hideProgressHUD();
      }
    });
  }


  _refreshControlDidRefresh() {
    showProgressHUD();
    ISChannelManager.sharedInstance.requestGetChannels((responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        _reloadData();
      } else {
        hideProgressHUD();
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
            child: RefreshIndicator(
              onRefresh: () {
                _refreshControlDidRefresh();
                return Future.delayed(const Duration(milliseconds: 1000));
              },
              child: Container(
                margin: AppDimens.activity_margin_large,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Messages",
                          style: AppStyles.textLarge
                              .copyWith(color: AppColors.text_color_primary)),
                      SizedBox(height: 20),
                      MessageChannelListView(
                          arrayChannels:arrayChannels,
                          itemClickListener: (notes, index) {
                            _gotoMessageFragment(index);
                          }),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  @override
  channelListUpdated() {
    _reloadData();
  }
  @override
  claimListUpdated() {

  }

  @override
  formListUpdated() {
  }

  @override
  messageListUpdated() {
  }

  @override
  requestFormReload() {
  }
}
