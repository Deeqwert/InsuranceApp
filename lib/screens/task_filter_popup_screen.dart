import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insurance/isModel/claim/dataModel/is_claim_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_filter_option_data_model.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/organization/dataModel/is_organization_data_model.dart';
import 'package:insurance/isModel/organization/is_organization_manager.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';

class ISTaskFilterPopupDialogScreen extends BaseScreen {

  final FilterPopupDialogListener? mListener;
  final ISTaskFilterOptionDataModel? modelFilter;
  final ISTaskFilterPopupFor? claimHistory;
  const ISTaskFilterPopupDialogScreen({Key? key, required this.mListener,this.modelFilter,this.claimHistory}) : super(key: key);



  @override
  _ISTaskFilterPopupDialogScreenState createState() =>
      _ISTaskFilterPopupDialogScreenState();
}

class _ISTaskFilterPopupDialogScreenState
    extends BaseScreenState<ISTaskFilterPopupDialogScreen> {
  final etClaimNumber = TextEditingController();
  ISTaskFilterOptionDataModel? modelFilter;
  ISTaskFilterPopupFor? enumFilterFor;
  int sortType = 1;
  String etOrgnization = "";
  String etStatus = "";
  String etDate = "";
  String etType = "";
  List<String> arrayOrgNames = [];
  List<String> arrayStatus = [];
  List<String> arryTypes = [];
  DateTime? picked;
  bool buttonDate = true;
  bool buttonStatus = false;
  bool buttonType = false;
  bool isStatus=false;

  Future<void> _selectDate(
      BuildContext context, StateSetter updateState) async {
    picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    DateTime? tempDate= ISUtilsDate.getDateTimeFromStringWithFormat(etDate, ISEnumDateTimeFormat.MMddyyyy_hhmma.value,false);
    if (picked != null && picked != tempDate)
      updateState(() {
        etDate = ISUtilsDate.getStringFromDateTimeWithFormat(
            picked, ISEnumDateTimeFormat.MMMdyyyy.value, false);
      });
  }

  @override
  void initState() {
    super.initState();
     sortType = 1;
     modelFilter=widget.modelFilter;
     enumFilterFor=widget.claimHistory;
    _buildFilterOptions();
    _initFilterOptions();

  }

  // setData(ISTaskFilterOptionDataModel data, ISTaskFilterPopupFor enumFilter) {
  //   modelFilter = data;
  //   enumFilterFor = enumFilter;
  // }

  _buildFilterOptions() {
    arrayOrgNames = [];
    arrayOrgNames.add("All Organizations");

    for (ISOrganizationDataModel org
        in ISOrganizationManager.sharedInstance.arrayOrganizations) {
      arrayOrgNames.add(org.szName);
    }
    arrayStatus = [];
    if (enumFilterFor == ISTaskFilterPopupFor.claimList) {
      arrayStatus.add("All Statuses");
      arrayStatus.add(ISEnumTaskStatus.pending.value);
      arrayStatus.add(ISEnumTaskStatus.assigned.value);
      arrayStatus.add(ISEnumTaskStatus.scheduled.value);
      arrayStatus.add(ISEnumTaskStatus.enRoute.value);
      arrayStatus.add(ISEnumTaskStatus.arrived.value);
      arrayStatus.add(ISEnumTaskStatus.departed.value);
      arrayStatus.add(ISEnumTaskStatus.failed.value);
    } else if (enumFilterFor == ISTaskFilterPopupFor.claimHistory) {
      arrayStatus.add(ISEnumTaskStatus.completed.value);
    } else if (enumFilterFor == ISTaskFilterPopupFor.map) {
      arrayStatus.add("All Statuses");
      arrayStatus.add(ISEnumTaskStatus.pending.value);
      arrayStatus.add(ISEnumTaskStatus.assigned.value);
      arrayStatus.add(ISEnumTaskStatus.scheduled.value);
      arrayStatus.add(ISEnumTaskStatus.enRoute.value);
      arrayStatus.add(ISEnumTaskStatus.arrived.value);
      arrayStatus.add(ISEnumTaskStatus.departed.value);
      arrayStatus.add(ISEnumTaskStatus.failed.value);
    }
    arryTypes = [];
    arryTypes.add("All Types");
    for (int i = 0; i < ClaimTypeExtension.getAvailableValue().length; i++) {
      arryTypes.add(ClaimTypeExtension.getAvailableValue()[i]);
    }
    setState(() {
      isStatus=true;
    });
    setState(() {
      arrayOrgNames = arrayOrgNames;
      arrayStatus = arrayStatus;
      arryTypes = arryTypes;
    });

    if (enumFilterFor == ISTaskFilterPopupFor.map) {
    } else if (enumFilterFor == ISTaskFilterPopupFor.claimList) {
    } else if (enumFilterFor == ISTaskFilterPopupFor.claimHistory) {
      setSelectSpinerItem(1, "Completed");
      //TODO:
      setState(() {
        isStatus=false;
      });
    }
  }

  _initFilterOptions() {
    if (modelFilter == null) return;
    etClaimNumber.text = modelFilter!.szClaimNumber;
    //Organization
    if (modelFilter!.organizationId != null &&
        ISOrganizationManager.sharedInstance
                .getOrganizationById(modelFilter!.organizationId) !=
            null) {
      ISOrganizationDataModel? org = ISOrganizationManager.sharedInstance
          .getOrganizationById(modelFilter!.organizationId);
      setSelectSpinerItem(0, org!.szName);
    } else {
      setSelectSpinerItem(0, "All Organizations");
    }

    //Status
    if (modelFilter!.enumStatus != ISEnumTaskStatus.none) {
      setSelectSpinerItem(1, modelFilter!.enumStatus.value);
    } else {
      setSelectSpinerItem(1, "All Statuses");
    }
    if (enumFilterFor == ISTaskFilterPopupFor.claimHistory) {
      setSelectSpinerItem(1, "Completed");
    }

    //Date
    etDate = ISUtilsDate.getStringFromDateTimeWithFormat(
        modelFilter!.date, ISEnumDateTimeFormat.MMMdyyyy.value, false);

    // Type
    if (modelFilter!.enumType != ISEnumClaimType.none) {
      setSelectSpinerItem(2, etType = modelFilter!.enumType.value);
    } else {
      setSelectSpinerItem(2, "All Types");
    }

    if (modelFilter!.enumSortBy == ISEnumTaskSortBy.status) {
      setState(() {
        buttonStatus = true;
        buttonDate = false;
        buttonType = false;
      });
    } else if (modelFilter!.enumSortBy == ISEnumTaskSortBy.date) {
      setState(() {
        buttonDate = true;
        buttonStatus = false;
        buttonType = false;
      });
    } else if (modelFilter!.enumSortBy == ISEnumTaskSortBy.type) {
      setState(() {
        buttonType = true;
        buttonDate = false;
        buttonStatus = false;
      });
    }
  }

  setSelectSpinerItem(int spinerType, String text) {
    if (spinerType == 0) {
      for (int i = 0; i < arrayOrgNames.length; i++) {
        String str = arrayOrgNames[i];
        if (str == text) {
          setState(() {
            etOrgnization = arrayOrgNames[i];
          });
        }
      }
    } else if (spinerType == 1) {
      for (int i = 0; i < arrayStatus.length; i++) {
        String str = arrayStatus[i];
        if (str == text) {
        setState(() {
          etStatus = arrayStatus[i];
        });
        }
      }
    } else if (spinerType == 2) {
      for (int i = 0; i < arryTypes.length; i++) {
        String str = arryTypes[i];
        if (str == text) {
        setState(() {
          etType = arryTypes[i];
        });
        }
      }
    }
  }

  _buttonDone() {
    ISTaskFilterOptionDataModel filter = ISTaskFilterOptionDataModel();
    filter.szClaimNumber = etClaimNumber.text.toString();
    if (sortType == 0) {
      filter.enumSortBy = ISEnumTaskSortBy.status;
    } else if (sortType == 1) {
      filter.enumSortBy = ISEnumTaskSortBy.date;
    } else if (sortType == 2) {
      filter.enumSortBy = ISEnumTaskSortBy.type;
    }

    if (etOrgnization.isNotEmpty) {
      var org = ISOrganizationManager.sharedInstance
          .getOrganizationByName(etOrgnization);
      if (org != null) filter.organizationId = org.id;
    }

    if (etStatus.isNotEmpty)
      filter.enumStatus = TaskStatusExtension.fromString(etStatus);

    if (etDate.isNotEmpty){
      var test = ISUtilsDate.getStringFromDateTimeWithFormat(picked, ISEnumDateTimeFormat.MMMdyyyy.value, false);
      filter.date = ISUtilsDate.getDateTimeFromStringWithFormat( test, ISEnumDateTimeFormat.MMMdyyyy.value, false);
    }
    if (etType.isNotEmpty) filter.enumType = ClaimTypeExtension.fromString(etType);
    widget.mListener?.didTaskFilterPopupSearchClick(filter);
    Navigator.pop(context);
  }

  _buttonClear() {
    widget.mListener?.didTaskFilterPopupClearClick();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.all(0),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(builder: (context, setState) {
          return Container(
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
                margin: AppDimens.activity_margin,
                decoration: BoxDecoration(
                  color: AppColors.background_white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: AppDimens.activity_padding,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.gray,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Sort and Filter",
                                  style: AppStyles.appHeadertitle.copyWith(
                                      color: AppColors.gray_dark)),
                              InkWell(
                                onTap: () {
                                  widget.mListener?.didTaskFilterPopupCloseClick();
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  'assets/images/close.png',
                                  width: 18,
                                  height: 18,
                                  color: AppColors.gray_darkest,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text("Sort By",
                            style: AppStyles.appHeadertitle.copyWith(
                                color: AppColors.black)),
                        SizedBox(height: 5),
                        Container(
                          margin: AppDimens.activity_margin
                              .copyWith(left: 40, right: 40),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.gray,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    sortType = 0;
                                    buttonStatus = true;
                                    buttonDate = false;
                                    buttonType = false;
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: buttonStatus
                                        ? AppColors.background_white
                                        : AppColors.gray,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("Status"),
                                ),
                              )),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    sortType = 1;
                                    buttonStatus = false;
                                    buttonDate = true;
                                    buttonType = false;
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: buttonDate
                                        ? AppColors.background_white
                                        : AppColors.gray,
                                  ),
                                  child: Text("Date"),
                                ),
                              )),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    sortType = 2;
                                    buttonStatus = false;
                                    buttonDate = false;
                                    buttonType = true;
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: buttonType
                                        ? AppColors.background_white
                                        : AppColors.gray,
                                  ),
                                  child: Text("Type"),
                                ),
                              )),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Divider(height: 1),
                        SizedBox(height: 10),
                        Text("Filter By",
                            style: AppStyles.appHeadertitle.copyWith(
                                color: AppColors.black)),
                        SizedBox(height: 8),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: AppDimens.activity_margin
                              .copyWith(left: AppDimens.activity_margin_large.left, right:  AppDimens.activity_margin_large.right),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(AppStrings.claims + "#",
                                      style: AppStyles.inputTextStyle.copyWith(
                                          fontSize:
                                              AppDimens.text_normal_size))),
                              SizedBox(width: 5),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 30,
                                  child: TextFormField(
                                      controller: etClaimNumber,
                                      onChanged: (text) {},
                                      textInputAction: TextInputAction.done,
                                      style: AppStyles.inputTextStyle,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration:
                                          AppStyles.textInputDecoration),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: AppDimens.activity_margin
                              .copyWith(left: AppDimens.activity_margin_large.left, right:  AppDimens.activity_margin_large.right,top: 0),

                          child: Row(
                            children: [
                              Expanded(
                                  child: Text("Organization",
                                      style: AppStyles.appHeadertitle.copyWith(
                                          color: AppColors.black))),
                              SizedBox(width: 5),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.grey_edit_text),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  height: 30,
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Container(
                                      padding: EdgeInsets.only(left: AppDimens.activity_margin_small.left),
                                      child: Text(etOrgnization,overflow: TextOverflow.ellipsis,
                                          style: AppStyles.inputTextStyle
                                              .copyWith(
                                                  fontSize: AppDimens
                                                      .text_normal_size)),
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.transparent,
                                    ),
                                    iconSize: 24,
                                    elevation: 16,
                                    underline: Container(
                                      height: 0,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        etOrgnization = newValue!;
                                      });
                                    },
                                    items: arrayOrgNames
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: AppDimens.activity_margin
                              .copyWith(left: AppDimens.activity_margin_large.left, right:  AppDimens.activity_margin_large.right,top: 0),

                          child: Row(
                            children: [
                              Expanded(
                                  child: Text("Status",
                                      style: AppStyles.appHeadertitle.copyWith(
                                          color: AppColors.black))),
                              SizedBox(width: 5),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.grey_edit_text),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  height: 30,
                                  child: DropdownButton<String>(
                                    hint: Container(
                                      padding: EdgeInsets.only(left: AppDimens.activity_margin_small.left),
                                      child: Text(etStatus,
                                          style: AppStyles.inputTextStyle.copyWith(
                                              fontSize:
                                                  AppDimens.text_normal_size,
                                              color: isStatus?AppColors.font_grey_edit_text:AppColors.toolbar_color_control_gray)),
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.transparent,
                                    ),
                                    iconSize: 24,
                                    elevation: 16,
                                    underline: Container(
                                      height: 0,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        etStatus = newValue!;
                                      });
                                    },
                                    items: arrayStatus
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: AppDimens.activity_margin
                              .copyWith(left: AppDimens.activity_margin_large.left, right:  AppDimens.activity_margin_large.right,top: 0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text("Scheduled Date",
                                      style: AppStyles.appHeadertitle.copyWith(
                                          color: AppColors.black))),
                              SizedBox(width: 5),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    _selectDate(context, setState);
                                  },
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: AppDimens.activity_margin_small.left),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.grey_edit_text),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      height: 30,
                                      child: Text(etDate,
                                          style: AppStyles.inputTextStyle
                                              .copyWith(
                                                  fontSize: AppDimens
                                                      .text_normal_size))),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: AppDimens.activity_margin
                              .copyWith(left: AppDimens.activity_margin_large.left, right:  AppDimens.activity_margin_large.right,top: 0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text("Type",
                                      style: AppStyles.appHeadertitle.copyWith(
                                          color: AppColors.black))),
                              SizedBox(width: 5),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.grey_edit_text),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  height: 30,
                                  child: DropdownButton<String>(
                                    hint: Container(
                                      padding: EdgeInsets.only(left: AppDimens.activity_margin_small.left),
                                      child: Text(etType,
                                          style: AppStyles.textNormal),
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.transparent,
                                    ),
                                    iconSize: 24,
                                    elevation: 16,
                                    underline: Container(
                                      height: 0,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        etType = newValue!;
                                      });
                                    },
                                    items: arryTypes
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.gray,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6)),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        _buttonClear();
                                      },
                                      child: Text("Clear")),
                                  SizedBox(width: 12),
                                  ElevatedButton(
                                      onPressed: () {
                                        _buttonDone();
                                      },
                                      child: Text("Done"))
                                ],
                              )),
                        ))
                  ],
                )),
          );
        }));
  }
}

abstract class FilterPopupDialogListener {
  didTaskFilterPopupClearClick();
  didTaskFilterPopupCloseClick();
  didTaskFilterPopupSearchClick(ISTaskFilterOptionDataModel filterModel);

}
