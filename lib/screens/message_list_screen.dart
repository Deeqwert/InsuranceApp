import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insurance/component/listViews/message_list_view.dart';
import 'package:insurance/isModel/channels/dataModel/is_channel_data_model.dart';
import 'package:insurance/isModel/channels/is_channel_manager.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/localNotification/is_notification_observer.dart';
import 'package:insurance/isModel/localNotification/is_notification_warden.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';

class MessageListScreen extends BaseScreen {

  final ISChannelDataModel? channelItem;
  const MessageListScreen({Key? key,  this.channelItem}) : super(key: key);

  @override
  _MessageListScreenState createState() => _MessageListScreenState();
}

class _MessageListScreenState extends BaseScreenState<MessageListScreen> implements ISNotificationObserver {

  ISChannelDataModel? modelChannel;
  var messageInput=TextEditingController();

  @override
  void initState() {
    modelChannel=widget.channelItem;
    _registerLocalNotification();
    _reloadMessages();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    ISNotificationWarden.sharedInstance.removeObserver(this);
  }

   _registerLocalNotification() {
     ISNotificationWarden.sharedInstance.notifyTaskObservers(ISUtilsGeneral.messageListUpdated);
  }

 _reloadMessages() {
    setState(() {
      modelChannel=modelChannel;
    });
  }

  _refreshControlDidRefresh() {
    showProgressHUD();
    ISChannelManager.sharedInstance.requestGetChannelMessages(modelChannel!,(responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        _reloadMessages();
      } else {
        hideProgressHUD();
      }
    });
  }

  _onSubmit(){
    showProgressHUD();
    ISChannelManager.sharedInstance.requestSendChannelMessage(modelChannel!,messageInput.text.toString(), (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
         messageInput.text="";
        _reloadMessages();
      } else {
        hideProgressHUD();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.black, //change your color here
        ),
        backwardsCompatibility: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: AppColors.background_white_transparent_85),
        title: Text(AppStrings.message,
            style: AppStyles.inputTextStyle
                .copyWith(color: AppColors.black)),
        backgroundColor: AppColors.background_white_transparent_85,
      ),
      body:SafeArea(
        child:  GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 60,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: RefreshIndicator(
                    onRefresh: () {
                      _refreshControlDidRefresh();
                      return Future.delayed(const Duration(milliseconds: 1000));
                    },child:MessageListView(
                     dataModel: modelChannel!,
                  )),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  color: AppColors.background_grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.75,
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: TextFormField(
                            controller:messageInput ,
                            onChanged:(text){
                            },
                            textInputAction: TextInputAction.done,
                            style: AppStyles.inputTextStyle,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: AppStyles.textInputDecoration.copyWith(fillColor: AppColors.background_white)
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.20,
                        margin: EdgeInsets.only(
                            left: 5, right: 10, bottom: 10, top: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            _onSubmit();
                          },
                          style: AppStyles.buttonSquareGreen.copyWith(
                              backgroundColor:
                              MaterialStateProperty.all(AppColors.blue_button)),
                          child: Text(
                            AppStrings.send,
                            textAlign: TextAlign.center,
                            style: AppStyles.buttonTextStyle,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  claimListUpdated() {
  }

  @override
  formListUpdated() {
  }

  @override
  messageListUpdated() {
    _reloadMessages();
  }

  @override
  requestFormReload() {
  }
  @override
  channelListUpdated() {
  }
}
