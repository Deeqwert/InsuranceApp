import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insurance/component/listViews/claim_list_view.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_filter_option_data_model.dart';
import 'package:insurance/isModel/claim/is_caim_manager.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/localNotification/is_notification_observer.dart';
import 'package:insurance/isModel/localNotification/is_notification_warden.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:insurance/screens/summary_screen.dart';
import 'package:insurance/screens/task_filter_popup_screen.dart';

class HistoryScreen extends BaseScreen {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends BaseScreenState<HistoryScreen> implements FilterPopupDialogListener,ISNotificationObserver {
  List<ISTaskDataModel> arrayTasks = [];
  ISTaskFilterOptionDataModel modelFilter = ISTaskFilterOptionDataModel();

  @override
  Future<bool> onBackPressed() {
    // TODO: implement onBackPressed
    return super.onBackPressed();
  }

  @override
  void initState() {
    super.initState();
    ISNotificationWarden.sharedInstance.addObserver(this);
    modelFilter.enumSortBy = ISEnumTaskSortBy.date;
    reloadData();
  }

  @override
  void dispose() {
    super.dispose();
    ISNotificationWarden.sharedInstance.removeObserver(this);
  }


  reloadData() {
    arrayTasks = [];
    List<ISTaskDataModel> array =
        ISClaimManager.sharedInstance.getTaskByFilterOptions(modelFilter);

    List<ISEnumTaskStatus> status = [
      ISEnumTaskStatus.completed,
    ];
    arrayTasks = ISClaimManager.sharedInstance.filterTaskFrom(array, status);
    arrayTasks.sort((ISTaskDataModel s1, ISTaskDataModel s2) {
      DateTime? date1 = s1.dateUpdatedAt;
      DateTime? date2 = s2.dateUpdatedAt;
      if (date1 == null && date2 == null) {
        return 0;
      }
      if (date1 == null) {
        return -1;
      }
      if (date2 == null) {
        return 1;
      }
      return date1.compareTo(date2);
    });

    setState(() {
      arrayTasks = arrayTasks;
    });
  }

  refreshControlDidRefresh() {
    showProgressHUD();
    ISClaimManager.sharedInstance.requestGetTasks((responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        reloadData();
      } else {
        showToast(responseDataModel.getBeautifiedErrorMessage());
      }
    });
  }

  _gotoSummaryScreen(ISTaskDataModel taskDataModel) {
    Navigator.push(
      context,
      createRoute(SummaryScreen(mModelTask: taskDataModel)),
    );
  }


  showFilterPopupDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ISTaskFilterPopupDialogScreen(mListener: this,modelFilter: modelFilter,claimHistory: ISTaskFilterPopupFor.claimHistory,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.black, //change your color here
        ),
        title: Text(AppStrings.menu_history, style: AppStyles.inputTextStyle),
        backgroundColor: AppColors.gray_light,
        actions: [
          Container(
              margin: EdgeInsets.only(right: AppDimens.activity_margin.right),
              child: InkWell(
                onTap: () {
                  showFilterPopupDialog();
                },
                child: Image.asset(
                  'assets/images/ic_top_sort.png',
                  height: 40,
                  width: 40,
                ),
              ))
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: () {
                refreshControlDidRefresh();
                return Future.delayed(const Duration(milliseconds: 1000));
              },
              child: Container(
                margin: AppDimens.activity_margin,
                child: ClaimListView(arrayTasks: arrayTasks,itemClickListener: (claim,index){
                  _gotoSummaryScreen(claim);
                },),
              ),
            )),
      ),
    );
  }

  @override
  didTaskFilterPopupClearClick() {
    modelFilter =  ISTaskFilterOptionDataModel();
    modelFilter.enumSortBy = ISEnumTaskSortBy.date;
    reloadData();
  }

  @override
  didTaskFilterPopupCloseClick() {

  }

  @override
  didTaskFilterPopupSearchClick(ISTaskFilterOptionDataModel filterModel) {
    modelFilter = filterModel;
    reloadData();
  }

  @override
  claimListUpdated() {
    reloadData();
  }

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
