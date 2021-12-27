import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insurance/component/listViews/claim_list_view.dart';
import 'package:insurance/isModel/appManager/is_app_manager.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_filter_option_data_model.dart';
import 'package:insurance/isModel/claim/is_caim_manager.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/localNotification/is_notification_observer.dart';
import 'package:insurance/isModel/localNotification/is_notification_warden.dart';
import 'package:insurance/isModel/organization/dataModel/is_tutorial_link_data_model.dart';
import 'package:insurance/isModel/organization/is_organization_manager.dart';
import 'package:insurance/isModel/user/dataModel/is_user_data_model.dart';
import 'package:insurance/isModel/user/is_user_manager.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:insurance/screens/history_screen.dart';
import 'package:insurance/screens/login/login_screen.dart';
import 'package:insurance/screens/profile_screen.dart';
import 'package:insurance/screens/setting_screen.dart';
import 'package:insurance/screens/summary_screen.dart';
import 'package:insurance/screens/task_filter_popup_screen.dart';
import 'package:insurance/screens/tutorial_screen.dart';

class ClaimsScreen extends BaseScreen {
  List<ISTaskDataModel> arrayTasks = [];
  @override
  _ClaimsScreenState createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends BaseScreenState<ClaimsScreen>
    implements ISNotificationObserver, FilterPopupDialogListener {
  bool buttonDate = true;
  bool buttonStatus = false;
  bool buttonType = false;
  List<ISTaskDataModel> arrayTasks = [];

  // Drawer items
  bool isTutorialLinkExist = true;
  String ivProfile = "";
  String tvUserName = "";
  String tvUserEmail = "";
  String headerTop = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int position = 1;

  @override
  void initState() {
    super.initState();
    ISNotificationWarden.sharedInstance.addObserver(this);
    reloadData();
    updateUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
    ISNotificationWarden.sharedInstance.removeObserver(this);
  }

  reloadData() {
    List<ISTaskDataModel> array = ISClaimManager.sharedInstance
        .getTaskByFilterOptions(ISClaimManager.sharedInstance.modelFilter);
    List<ISEnumTaskStatus> status = [
      ISEnumTaskStatus.pending,
      ISEnumTaskStatus.assigned,
      ISEnumTaskStatus.scheduled,
      ISEnumTaskStatus.enRoute,
      ISEnumTaskStatus.arrived,
      ISEnumTaskStatus.departed,
      ISEnumTaskStatus.failed
    ];

    setState(() {
      arrayTasks = ISClaimManager.sharedInstance.filterTaskFrom(array, status);
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
    ).then((value) => {reloadData()});
  }

// NAVIGATION DRAWER DATA
  updateUserInfo() {
    ISUserDataModel? currentUser = ISUserManager.sharedInstance.currentUser;
    if (currentUser != null) {
      String name = currentUser.szName;
      List<String> splited = [];
      splited = name.split(" ");
      if (splited.length > 1) {
        name = splited[0].substring(0, 1) + splited[1].substring(0, 1);
      } else {
        if (name.length > 1) name = name.substring(0, 2);
      }
      setState(() {
        tvUserEmail = currentUser.szEmail;
        tvUserName = currentUser.szName;
        ivProfile = name;
      });
    }
  }

  updateSideMenu() {
    //Showing tutorial menu base on the availability of tutorial videos
    List<ISTutorialLinkDataModel> tutorials =
        ISOrganizationManager.sharedInstance.getAllTutorialLinks();
    if (tutorials.length <= 0) {
      setState(() {
        isTutorialLinkExist = false;
      });
    } else {
      setState(() {
        isTutorialLinkExist = true;
      });
    }
    ISUtilsGeneral.log("Tutorial: " + tutorials.length.toString());
  }

  logOut() {
    ISAppManager.sharedInstance.initializeManagersAfterLogout();
    Navigator.pushReplacement(
      context,
      createRoute(const LoginScreen()),
    );
  }

  Widget drawerMenu() {
    return Drawer(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            top: 0,
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                  ),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: AppColors.avatar,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35))),
                          child: Text(ivProfile,
                              style: AppStyles.inputTextStyle.copyWith(
                                  fontSize: AppDimens.text_extra_large_size)),
                        ),
                        Container(
                            margin: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tvUserName,
                                    style: AppStyles.inputTextStyle.copyWith(
                                        fontSize: AppDimens.text_size)),
                                Flexible(
                                  child: Text(tvUserEmail,
                                      style: AppStyles.inputTextStyle.copyWith(
                                          fontSize: AppDimens.text_size)),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_account_gray.png',
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(width: 10),
                              Padding(
                                padding: AppDimens.activity_margin,
                                child: Text("My Profile",
                                    style: AppStyles.inputTextStyle.copyWith(
                                        fontSize: AppDimens.text_size)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          createRoute(const ProfileScreen()),
                        );
                      },
                    ),
                    ListTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_history_grey600_24dp.png',
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(width: 10),
                              Padding(
                                padding: AppDimens.activity_margin,
                                child: Text("History",
                                    style: AppStyles.inputTextStyle.copyWith(
                                        fontSize: AppDimens.text_size)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          createRoute(const HistoryScreen()),
                        );
                      },
                    ),
                    Visibility(
                      visible: isTutorialLinkExist,
                      child: ListTile(
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic_menu_video.png',
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: AppDimens.activity_margin,
                                  child: Text("Tutorial Videos",
                                      style: AppStyles.inputTextStyle.copyWith(
                                          fontSize: AppDimens.text_size)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            createRoute(const TutorialScreen()),
                          );
                        },
                      ),
                    ),
                    ListTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_settings_black_24dp.png',
                                height: 20,
                                width: 20,
                                color: AppColors.gray_dark,
                              ),
                              SizedBox(width: 10),
                              Padding(
                                padding: AppDimens.activity_margin,
                                child: Text("Settings",
                                    style: AppStyles.inputTextStyle.copyWith(
                                        fontSize: AppDimens.text_size)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          createRoute(const SettingScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Divider(height: 1),
                    ListTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_save_end_exit.png',
                                height: 20,
                                width: 20,
                                color: AppColors.gray_dark,
                              ),
                              SizedBox(width: 10),
                              Padding(
                                padding: AppDimens.activity_margin,
                                child: Text("Sign out",
                                    style: AppStyles.inputTextStyle.copyWith(
                                        fontSize: AppDimens.text_size)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        logOut();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Container(
                  child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                title: Row(
                  children: [
                    Padding(
                      padding: AppDimens.activity_margin,
                      child: Text(
                        "0.0.1 Dev",
                        style: AppStyles.inputTextStyle
                            .copyWith(fontSize: AppDimens.text_size),
                      ),
                    ),
                  ],
                ),
              )))
        ],
      ),
    );
  }

  showFilterPopupDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ISTaskFilterPopupDialogScreen(
          mListener: this,
          modelFilter: ISClaimManager.sharedInstance.modelFilter,
          claimHistory: ISTaskFilterPopupFor.claimList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: AppColors.background_white),
        leading: new IconButton(
          icon: new Icon(Icons.menu, size: 32, color: Colors.grey),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: Container(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/logo_topbar.png',
            height: 40,
          ),
        ),
        backgroundColor: AppColors.gray_light,
        actions: [
          Container(
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
              child: ClaimListView(
                  arrayTasks: arrayTasks,
                  itemClickListener: (claim, index) {
                    _gotoSummaryScreen(claim);
                  }),
            ),
          ),
        ),
      ),
      drawer: drawerMenu(),
      key: _scaffoldKey,
    );
  }

  @override
  claimListUpdated() {
    reloadData();
    showToast("Your claims list has been updated successfully.");
  }

  @override
  formListUpdated() {}

  @override
  requestFormReload() {}

  @override
  didTaskFilterPopupClearClick() {
    ISClaimManager.sharedInstance.modelFilter = ISTaskFilterOptionDataModel();
    reloadData();
  }

  @override
  didTaskFilterPopupCloseClick() {}

  @override
  didTaskFilterPopupSearchClick(ISTaskFilterOptionDataModel filterModel) {
    ISClaimManager.sharedInstance.modelFilter = filterModel;
    reloadData();
  }

  @override
  messageListUpdated() {
  }
  @override
  channelListUpdated() {
  }
}
