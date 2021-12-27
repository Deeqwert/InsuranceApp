import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/is_caim_manager.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/localNotification/is_notification_warden.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';

class AppointmentDetailScreen extends BaseScreen {
  final ISTaskDataModel mTaskData;
  const AppointmentDetailScreen({Key? key, required this.mTaskData})
      : super(key: key);
  @override
  AppointmentDetailScreenState createState() => AppointmentDetailScreenState();
}

class AppointmentDetailScreenState
    extends BaseScreenState<AppointmentDetailScreen> {
  TimeOfDay currentTime = TimeOfDay.now();
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  String tvStartTime = "09:00 AM";
  String tvEndTime = "10:00 AM";
  String tv_selectedDate = "";
  DateTime? selectedDate;
  ISTaskDataModel? mTaskData;

  DateTime? mStartDateTime;
  DateTime? mEndDateTime;
  DateTime mCurrentDate = DateTime.now();
  var newStartDate;
  var newEndDate;
  @override
  void initState() {
    super.initState();
    setState(() {
      tv_selectedDate = ISUtilsDate.getStringFromDateTimeWithFormat(
          new DateTime.now(), ISEnumDateTimeFormat.EEEEMMMMdyyyy.value, false);
    });
    _initArguments();
    _initAppointmentItems();
  }

  _initArguments() {

    var date = DateTime.now();
     newStartDate = DateTime(date.year, date.month,date.day,  9);
     newEndDate = DateTime(date.year, date.month,date.day,  10);

    if (widget.mTaskData.id.isEmpty) return;
    mTaskData = ISClaimManager.sharedInstance.getTaskById(widget.mTaskData.id);

    setState(() {
      mStartDateTime =   mTaskData!.getBestStartDate();
      mEndDateTime = mTaskData!.getBestEndDate();
    });
  }

  _initAppointmentItems() {
    _updateInfo();
  }

  _updateInfo() {
    setState(() {
      selectedDate=mTaskData!.getBestStartDate() ?? DateTime.now();
      mCurrentDate = mTaskData!.getBestStartDate() ?? DateTime.now();
      tv_selectedDate = ISUtilsDate.getStringFromDateTimeWithFormat(
          mCurrentDate, ISEnumDateTimeFormat.EEEEMMMMdyyyy.value, false);
      tvStartTime = ISUtilsDate.getStringFromDateTimeWithFormat(
          mTaskData!.getBestStartDate() ?? newStartDate,
          ISEnumDateTimeFormat.hhmma.value,
          false);

      tvEndTime = ISUtilsDate.getStringFromDateTimeWithFormat(
          mTaskData!.getBestEndDate() ?? newEndDate,
          ISEnumDateTimeFormat.hhmma.value,
          false);
    });
  }

  _onSelectDate(DateTime date){

    setState(() {
      tv_selectedDate = ISUtilsDate
          .getStringFromDateTimeWithFormat(
          date,
          ISEnumDateTimeFormat
              .EEEEMMMMdyyyy.value,
          false);
      selectedDate=date;
      mStartDateTime=DateTime(selectedDate!.year,selectedDate!.month,selectedDate!.day,mTaskData!.getBestStartDate()!.hour,mTaskData!.getBestStartDate()!.minute);
      mEndDateTime=DateTime(selectedDate!.year,selectedDate!.month,selectedDate!.day,mTaskData!.getBestEndDate()!.hour,mTaskData!.getBestEndDate()!.minute);

    });
  }

  Future<Null> _selectTime(BuildContext context, bool isStartDate) async {
    final now = new DateTime.now();
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: isStartDate
          ? TimeOfDay.fromDateTime(mStartDateTime ?? newStartDate)
          : TimeOfDay.fromDateTime(mEndDateTime ?? newEndDate),
    );
    if (isStartDate) {
      final now = new DateTime.now();
      setState(() {
        tvStartTime = ISUtilsDate.getStringFromDateTimeWithFormat(
            DateTime(now.year, now.month, now.day, timePicked!.hour,
                timePicked.minute),
            ISEnumDateTimeFormat.hhmma.value,
            false);
        mStartDateTime = DateTime(
            selectedDate!.year, selectedDate!.month, selectedDate!.day, timePicked.hour, timePicked.minute);
      });
    } else {
      setState(() {
        tvEndTime = ISUtilsDate.getStringFromDateTimeWithFormat(
            DateTime(now.year, now.month, now.day, timePicked!.hour,
                timePicked.minute),
            ISEnumDateTimeFormat.hhmma.value,
            false);
        mEndDateTime = DateTime(
            selectedDate!.year, selectedDate!.month, selectedDate!.day, timePicked.hour, timePicked.minute);
      });
    }
  }

  _saveAppointment() {
    showProgressHUD();
    ISClaimManager.sharedInstance.requestScheduleTask(mTaskData!,mStartDateTime!,mEndDateTime!,(responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        ISNotificationWarden.sharedInstance.notifyTaskObservers(ISUtilsGeneral.claimListUpdated);
        Navigator.pop(context);
      } else {
        hideProgressHUD();
        if(responseDataModel.errorMessage==""){
          showToast("Sorry, we've encountered an error.");
        }else{
          showToast(responseDataModel.getBeautifiedErrorMessage());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: mTaskData!.getColorStatus()),
          title: Text(mTaskData!.modelClaim.szClaimNumber,
              style: AppStyles.appHeadertitle),
          backgroundColor: mTaskData!.getColorStatus(),
          actions: <Widget>[
            Padding(
              padding: AppDimens.activity_vertical_margin.copyWith(top: 20),
              child: GestureDetector(
                onTap: () {
                  _saveAppointment();
                },
                child: Text("Save",
                    style: AppStyles.inputTextStyle.copyWith(
                        color: AppColors.font_white_color,
                        fontSize: AppDimens.text_normal_size)),
              ),
            )
          ],
        ),
        body: Dialog(
            insetPadding: EdgeInsets.all(0),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                  decoration: BoxDecoration(
                      color: AppColors.gray_light,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppDimens.card_view_radius),
                          topRight:
                              Radius.circular(AppDimens.card_view_radius))),
                  height: MediaQuery.of(context).size.height - 40,
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                          color: AppColors.background_white,
                          child: Column(
                            children: [
                              CalendarDatePicker(
                                  initialDate: mCurrentDate,
                                  firstDate: mCurrentDate,
                                  lastDate: DateTime.utc(2030, 3, 14),
                                  onDateChanged: (selected) {
                                    setState(() {
                                      _onSelectDate(selected);
                                    });
                                  }),
                              SizedBox(height: 5),
                              Text(tv_selectedDate,
                                  style: AppStyles.inputTextStyle.copyWith(
                                      fontSize: AppDimens.text_normal_size)),
                              SizedBox(height: 10),
                            ],
                          )),
                      Expanded(
                        child: Container(
                          margin: AppDimens.activity_margin_large,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Start Time:",
                                      style: AppStyles.inputTextStyle.copyWith(
                                          fontSize: AppDimens.text_size)),
                                  InkWell(
                                    onTap: () {
                                      _selectTime(context, true);
                                    },
                                    child: Text(tvStartTime,
                                        style: AppStyles.inputTextStyle
                                            .copyWith(
                                                fontSize: AppDimens.text_size)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("End Time:",
                                      style: AppStyles.inputTextStyle.copyWith(
                                          fontSize: AppDimens.text_size)),
                                  InkWell(
                                    onTap: () {
                                      _selectTime(context, false);
                                    },
                                    child: Text(tvEndTime,
                                        style: AppStyles.inputTextStyle
                                            .copyWith(
                                                fontSize: AppDimens.text_size)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )));
            })));
  }
}
