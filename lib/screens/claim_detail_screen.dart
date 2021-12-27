import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insurance/isModel/claim/dataModel/is_claim_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/is_caim_manager.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/localNotification/is_notification_observer.dart';
import 'package:insurance/isModel/localNotification/is_notification_warden.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';

class ClaimDetailScreen extends BaseScreen {
  final ISTaskDataModel mModelTask;
  const ClaimDetailScreen({Key? key, required this.mModelTask})
      : super(key: key);
  @override
  _ClaimDetailScreenState createState() => _ClaimDetailScreenState();
}

class _ClaimDetailScreenState extends BaseScreenState<ClaimDetailScreen>
    implements ISNotificationObserver {
  String imgviewAvatar = "";
  String txtUsername = "";
  String txtPhoneNumber = "";
  String txtEmail = "";
  String txtLocation = "";
  String txtEvent = "";
  String txtLossDate = "";
  String txtClaimType = "";
  String lblPrivacy = "";
  String lblDescription = "";
  String txtWriterName = "";
  String txtWriterPhone = "";
  String txtWriterEmail = "";

  String txtPolicyId = "";
  String txtHolder = "";
  String txtPolicyType = "";
  ISTaskDataModel? modelTask;

  String strLossLocation = "";
  String strLossDateTime = "";
  String strDescription = "";

  @override
  void initState() {
    super.initState();
    _initArgument();
  }

  @override
  void dispose() {
    super.dispose();
    ISNotificationWarden.sharedInstance.removeObserver(this);
  }

  _initArgument() {
    modelTask = ISClaimManager.sharedInstance.getTaskById(widget.mModelTask.id);
    strLossLocation = modelTask!.getAddress();
    strLossDateTime = modelTask!.getFormattedLossDate();
    if (modelTask!.getClaimDataModel()!.szDescription.isEmpty) {
      strDescription = ISUtilsString.refineString(modelTask!.szDescription);
    } else {
      strDescription = ISUtilsString.refineString(
          modelTask!.getClaimDataModel()!.szDescription);
    }
    _refeshFields();
  }

  _refeshFields() {
    initUserInfo();
    initEventType();
    initLossLocation();
    initPolicyInfo();
    initWriterInfo();
    initDescriptionInfo();
  }

  initLossLocation() {
    txtLocation = strLossLocation;
    txtEvent = modelTask!.getEventName();
    txtLossDate = modelTask!.getFormattedLossDate();
  }

  initUserInfo() {
    // userInfo
    txtUsername = modelTask!.getContactName();
    txtPhoneNumber = modelTask!.getContactPhoneNumber();
    txtEmail = modelTask!.getContactEmailAddress();
  }

  initWriterInfo() {
    txtWriterName = "N/A";
    txtWriterEmail = "N/A";
    txtWriterPhone = "N/A";

    ISClaimDataModel? claim = modelTask!.getClaimDataModel();
    if (claim != null) {
      if (claim.modelWriter.szName.isNotEmpty) {
        txtWriterName = claim.modelWriter.szName;
      }
      if (claim.modelWriter.szEmail.isNotEmpty) {
        txtWriterEmail = claim.modelWriter.szEmail;
      }
      if (claim.modelWriter.szPhone.isNotEmpty) {
        txtWriterPhone = claim.modelWriter.szPhone;
      }
    }
  }

  initEventType() {
    txtEvent = modelTask!.getEventName();
    txtLossDate = strLossDateTime;
    txtClaimType = modelTask!.getClaimType();
  }

  initPolicyInfo() {
    txtPolicyId = modelTask!.getPolicyNumber();
    txtHolder = modelTask!.getFormattedPolicyEffectiveDate();
    txtPolicyType = modelTask!.getPolicyType();
  }

  initDescriptionInfo() {
    lblDescription = strDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: modelTask!.getColorStatus()),
        title: Text(modelTask!.modelClaim.szClaimNumber,
            style: AppStyles.inputTextStyle
                .copyWith(color: AppColors.font_white_color)),
        backgroundColor: modelTask!.getColorStatus(),
      ),
      body: Container(
        margin: EdgeInsets.only(top: AppDimens.activity_margin_large.top),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: AppColors.background_white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(left: AppDimens.activity_margin.left),
                    child: CircleAvatar(
                      backgroundColor: AppColors.gray,
                      radius: 35,
                      backgroundImage:
                          ExactAssetImage("assets/images/ic_account_gray.png"),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: AppDimens.activity_margin.left),
                          child: Text(txtUsername,
                              style: AppStyles.normalText
                                  .copyWith(color: AppColors.font_black_color)),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: AppDimens.activity_margin.left,
                              top: AppDimens.activity_margin.top),
                          child: Text(txtPhoneNumber,
                              style: AppStyles.normalText
                                  .copyWith(color: AppColors.font_black_color)),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: AppDimens.activity_margin.left,
                              top: AppDimens.activity_margin.top,
                              bottom: AppDimens.activity_margin.bottom),
                          child: Text(txtEmail,
                              style: AppStyles.normalText
                                  .copyWith(color: AppColors.font_black_color)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(height: 1, color: AppColors.gray_dark),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimens.activity_margin.left,
                          top: AppDimens.activity_margin.top),
                      child: Text("Writer",
                          style: AppStyles.normalText
                              .copyWith(color: AppColors.font_dark_grey_color)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimens.activity_margin.left,
                          top: AppDimens.activity_margin.top),
                      child: Text(txtWriterName,
                          style: AppStyles.textNormal
                              .copyWith(color: AppColors.font_black_color)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimens.activity_margin.left,
                          top: AppDimens.activity_margin.top),
                      child: Text(txtWriterEmail,
                          style: AppStyles.textNormal
                              .copyWith(color: AppColors.font_black_color)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimens.activity_margin.left,
                          top: AppDimens.activity_margin.top,
                          bottom: AppDimens.activity_margin.bottom),
                      child: Text(txtWriterPhone,
                          style: AppStyles.textNormal
                              .copyWith(color: AppColors.font_black_color)),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.gray_dark),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimens.activity_margin.left,
                          top: AppDimens.activity_margin.top),
                      child: Text("Loss Location",
                          style: AppStyles.normalText
                              .copyWith(color: AppColors.font_dark_grey_color)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimens.activity_margin.left,
                          top: AppDimens.activity_margin.top,
                          bottom: AppDimens.activity_margin.bottom),
                      child: Text(strLossLocation,
                          style: AppStyles.textNormal
                              .copyWith(color: AppColors.font_black_color)),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.gray_dark),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      margin: EdgeInsets.only(
                          left: AppDimens.activity_margin.left,
                          top: AppDimens.activity_margin.top),
                      child: Text("Event: ",
                          style: AppStyles.normalText
                              .copyWith(color: AppColors.font_dark_grey_color)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimens.activity_margin.left,
                          top: AppDimens.activity_margin.top),
                      child: Text(txtEvent,
                          style: AppStyles.textNormal.copyWith(
                              fontSize: AppDimens.text_normal_size,
                              color: AppColors.font_dark_grey_color)),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      margin: EdgeInsets.only(left: 10, top: 15),
                      child: Text("Claim Type: ",
                          style: AppStyles.normalText
                              .copyWith(color: AppColors.font_dark_grey_color)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimens.activity_margin.left,
                          top: AppDimens.activity_margin.top,
                          bottom: AppDimens.activity_margin.bottom),
                      child: Text(txtClaimType,
                          style: AppStyles.textNormal
                              .copyWith(color: AppColors.font_black_color)),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.gray_dark),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      margin: EdgeInsets.only(
                          left: AppDimens.activity_margin.left,
                          top: AppDimens.activity_margin.top),
                      child: Text("Policy: ",
                          style: AppStyles.normalText
                              .copyWith(color: AppColors.font_dark_grey_color)),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: AppDimens.activity_margin.left,
                                top: AppDimens.activity_margin.top),
                            child: Text(txtPolicyId,
                                style: AppStyles.textNormal.copyWith(
                                    color: AppColors.font_black_color)),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: AppDimens.activity_margin.left,
                                top: AppDimens.activity_margin.top,
                                bottom: AppDimens.activity_margin.bottom),
                            child: Text(txtPolicyType,
                                style: AppStyles.textNormal.copyWith(
                                    color: AppColors.font_black_color)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: AppColors.gray_dark,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimens.activity_margin.left,
                          top: AppDimens.activity_margin.top),
                      child: Text(lblDescription,
                          style: AppStyles.inputTextStyle.copyWith(
                              fontSize: AppDimens.text_normal_size,
                              color: AppColors.font_dark_grey_color)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  claimListUpdated() {}

  @override
  formListUpdated() {}

  @override
  requestFormReload() {}

  @override
  messageListUpdated() {
  }
  @override
  channelListUpdated() {
  }
}
