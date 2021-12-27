import 'package:flutter/material.dart';
import 'package:insurance/isModel/claim/dataModel/is_claim_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/is_caim_manager.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';

class ClaimReserversScreen extends BaseScreen {
  final ISTaskDataModel mModelTask;
  const ClaimReserversScreen({Key? key, required this.mModelTask})
      : super(key: key);
  @override
  _ClaimReserversScreenState createState() => _ClaimReserversScreenState();
}

class _ClaimReserversScreenState extends BaseScreenState<ClaimReserversScreen> {
  final edtInsuredValue = TextEditingController();
  final edtInitialLossReserve = TextEditingController();
  final edtAdjustedLossReserve = TextEditingController();
  ISTaskDataModel? mTask;
  String txtClaimNumber = "";

  @override
  void initState() {
    super.initState();
    _initArguments();
    _showClaimInfo();
  }

  _initArguments() {
    if (widget.mModelTask.id.isNotEmpty) {
      mTask = ISClaimManager.sharedInstance.getTaskById(widget.mModelTask.id);
    }
  }

  _showClaimInfo() {
    if (mTask == null) return;
    ISClaimDataModel? claim = mTask!.getClaimDataModel();
    if (claim == null) return;
    txtClaimNumber = claim.szClaimNumber;
    edtInsuredValue.text =
        ISUtilsString.beautifyAmountInDollars(claim.nTotalInsuredValue);
    edtInitialLossReserve.text =
        ISUtilsString.beautifyAmountInDollars(claim.nTotalLossReserve);
    edtAdjustedLossReserve.text =
        ISUtilsString.beautifyAmountInDollars(claim.nAdjustedLossReserve);
  }


  _onSaveButton() {
    if (mTask == null) return;
    ISClaimDataModel? claim = mTask!.getClaimDataModel();
    if (claim == null) return;
    String value = ISUtilsString.stripNonNumberics(edtAdjustedLossReserve.text);
    int number = 0;
    if (value.isNotEmpty) {
      number =  int.parse(value);
    }
    claim.nAdjustedLossReserve = number;
    showProgressHUD();
    ISClaimManager.sharedInstance.requestUpdateReservesForTask(mTask!,(responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        showToast("Reserve amounts are updated successfully.");
      } else {
        hideProgressHUD();
        showToast(responseDataModel.errorMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(mTask!.modelClaim.szClaimNumber, style: AppStyles.appHeadertitle),
          backgroundColor: mTask!.getColorStatus(),
          actions: [
            Container(
                alignment: Alignment.center,
                margin: AppDimens.activity_margin,
                child: InkWell(
                    onTap: () {
                      _onSaveButton();
                    },
                    child: Text(AppStrings.save_btn,
                        style: AppStyles.appHeadertitle)))
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            top: false,
            child: Container(
              margin: AppDimens.activity_margin_large,
              color: AppColors.background_white,
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.reserves,
                      style: AppStyles.textLarge
                          .copyWith(color: AppColors.text_color_primary)),
                  SizedBox(height: 10),
                  Text(txtClaimNumber, style: AppStyles.normalText),
                  SizedBox(height: 10),
                  Text(AppStrings.insured_value, style: AppStyles.normalText),
                  SizedBox(height: 5),
                  Container(
                    height: 35,
                    child: TextFormField(
                        controller: edtInsuredValue,
                        enabled: false,
                        textInputAction: TextInputAction.done,
                        style: AppStyles.inputTextStyle,
                        keyboardType: TextInputType.number,
                        decoration: AppStyles.textInputDecoration),
                  ),
                  SizedBox(height: 10),
                  Text(AppStrings.initial_loss_reserve,
                      style: AppStyles.normalText),
                  SizedBox(height: 5),
                  Container(
                    height: 35,
                    child: TextFormField(
                        controller: edtInitialLossReserve,
                        enabled: false,
                        textInputAction: TextInputAction.done,
                        style: AppStyles.inputTextStyle,
                        keyboardType: TextInputType.number,
                        decoration: AppStyles.textInputDecoration),
                  ),
                  SizedBox(height: 10),
                  Text(AppStrings.adjusted_loss_reserve,
                      style: AppStyles.normalText),
                  SizedBox(height: 5),
                  Container(
                    height: 35,
                    child: TextFormField(
                        controller: edtAdjustedLossReserve,
                        textInputAction: TextInputAction.done,
                        style: AppStyles.inputTextStyle,
                        keyboardType: TextInputType.number,
                        decoration: AppStyles.textInputDecoration.copyWith(hintText: "\$")),
                  ),
                ],
              )),
            ),
          ),
        ));
  }
}
