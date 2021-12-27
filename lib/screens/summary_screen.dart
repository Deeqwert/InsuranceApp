import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insurance/isModel/appManager/dataModel/is_app_setting_data_model.dart';
import 'package:insurance/isModel/appManager/is_app_manager.dart';
import 'package:insurance/isModel/claim/dataModel/is_claim_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_media_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_note_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/is_caim_manager.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/localNotification/is_notification_observer.dart';
import 'package:insurance/isModel/localNotification/is_notification_warden.dart';
import 'package:insurance/isModel/utils_map.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/appointment_detail_screen.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:insurance/screens/claim_detail_screen.dart';
import 'package:insurance/screens/claim_reserves_screen.dart';
import 'package:insurance/screens/note_details_screen.dart';
import 'package:insurance/screens/notes_screen.dart';
import 'package:insurance/utils/utils_base_functions.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SummaryScreen extends BaseScreen {
  final ISTaskDataModel mModelTask;
  const SummaryScreen({Key? key, required this.mModelTask}) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends BaseScreenState<SummaryScreen>
    implements ISNotificationObserver, NoteMediaPreviewListener {
  static const LatLng showLocation =
      const LatLng(30.7046, 76.7179); //location to show in map
  TimeOfDay currentTime = TimeOfDay.now();
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  String startDate = "";
  String endDate = "";
  String selectedDate = "";
  bool isInsured = false;
  Color? statusBarColor;
  ISTaskDataModel? mModelTask;

  bool mViewItemAddAppointment = true;
  bool mViewItemAppointment = true;
  bool mViewItemReserves = true;
  bool mViewItemHover = true;

  String tvContact = "";
  bool tvContactDisabled = false;
  String btnRoute = "";
  bool btnRouteVisibility = true;
  bool btnRouteEnable = true;

  String tvName = "";
  String tvProperty = "";
  String tvAddress = "";
  bool id_mark_address = true;

  String tvDate = "";
  String tvTime = "";

  String tvTitleNote = "";

  static final int ITEM_TYPE_SEND = 0;
  static final int ITEM_TYPE_DETAILS = 1;
  static final int ITEM_TYPE_ADD_APPOINTMENT = 2;
  static final int ITEM_TYPE_APPOINTMENTS = 3;
  static final int ITEM_TYPE_NOTES = 4;
  static final int ITEM_TYPE_ATTACHMENTS = 5;
  static final int ITEM_TYPE_ADJUSTERFORMS = 6;
  static final int ITEM_TYPE_HOVER = 7;
  static final int ITEM_TYPE_RESERVES = 8;

  static final List<int> Pending_Item_Types = [
    ITEM_TYPE_SEND,
    ITEM_TYPE_DETAILS,
    ITEM_TYPE_NOTES,
    ITEM_TYPE_ADJUSTERFORMS,
    ITEM_TYPE_HOVER,
    ITEM_TYPE_ATTACHMENTS
  ];

  static final List<int> Assigned_Item_Types = [
    ITEM_TYPE_SEND,
    ITEM_TYPE_DETAILS,
    ITEM_TYPE_ADD_APPOINTMENT,
    ITEM_TYPE_NOTES,
    ITEM_TYPE_ADJUSTERFORMS,
    ITEM_TYPE_HOVER,
    ITEM_TYPE_ATTACHMENTS,
    ITEM_TYPE_RESERVES
  ];

  static final List<int> Scheduled_Item_Types = [
    ITEM_TYPE_SEND,
    ITEM_TYPE_DETAILS,
    ITEM_TYPE_ADD_APPOINTMENT,
    ITEM_TYPE_NOTES,
    ITEM_TYPE_ADJUSTERFORMS,
    ITEM_TYPE_HOVER,
    ITEM_TYPE_ATTACHMENTS,
    ITEM_TYPE_RESERVES
  ];

  static final List<int> Complete_Item_Types = [
    ITEM_TYPE_SEND,
    ITEM_TYPE_DETAILS,
    ITEM_TYPE_APPOINTMENTS,
    ITEM_TYPE_NOTES,
    ITEM_TYPE_ADJUSTERFORMS,
    ITEM_TYPE_HOVER,
    ITEM_TYPE_ATTACHMENTS,
    ITEM_TYPE_RESERVES
  ];

  List<ISNoteDataModel> arrayNotes = [];
  List<ISMediaDataModel> arrayMedia = [];

  GoogleMap? googleMap;
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  final Set<Marker> markers = new Set();

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedDate = ISUtilsDate.getStringFromDateTimeWithFormat(
          new DateTime.now(), ISEnumDateTimeFormat.EEEEMMMMdyyyy.value, false);
      statusBarColor = widget.mModelTask.getColorStatus();
    });
    _initArguments();
    ISNotificationWarden.sharedInstance.addObserver(this);
    _initSummaryItems();
    _initBottomButton();
  }

  @override
  void dispose() {
    super.dispose();
    ISNotificationWarden.sharedInstance.removeObserver(this);
  }

  _initArguments() {
    mModelTask =
        ISClaimManager.sharedInstance.getTaskById(widget.mModelTask.id);
  }

  _refreshUI() {
    _initSummaryItems();

    _initBottomButton();
    setState(() {
      statusBarColor = mModelTask!.getColorStatus();
    });
    _updateMapView();
  }

  _initSummaryItems() {
    switch (mModelTask!.enumStatus) {
      case ISEnumTaskStatus.pending:
        mViewItemAddAppointment = false;
        mViewItemAppointment = false;
        mViewItemReserves = false;
        break;
      case ISEnumTaskStatus.assigned:
      case ISEnumTaskStatus.scheduled:
        if (mModelTask!.isAppointmentSet()) {
          mViewItemAddAppointment = false;
          mViewItemAppointment = true;
        } else {
          mViewItemAddAppointment = true;
          mViewItemAppointment = false;
        }
        break;
      default:
        mViewItemAddAppointment = false;
        mViewItemAppointment = true;
        break;
    }
    if (!mModelTask!.modelHoverLink.isLinkAvailable()) {
      mViewItemHover = false;
    }

    if (mModelTask!.dateFirstContact != null) {
      tvContact = "First contact at: " +
          ISUtilsDate.getStringFromDateTimeWithFormat(
                  mModelTask!.dateFirstContact,
                  ISEnumDateTimeFormat.MMddyyyy_hhmma.value,
                  false)
              .toString();
      tvContactDisabled = true;
    } else {
      tvContact = "Did you contact this insured?";
    }

    _initDetailsItem(mModelTask!);
    _initAppointmentItem(mModelTask!);
    _initNotesItem(mModelTask!);
    _initAttachmentsItem(mModelTask!);
  }

  _initDetailsItem(ISTaskDataModel data) {
    tvName = data.getContactName().isEmpty ? "" : data.getContactName();
    tvProperty = data.szDescription;
    if (data.getAddress().isEmpty) {
      tvAddress = "";
      id_mark_address = false;
    } else {
      tvAddress = data.getAddress();
    }
  }

  _initAppointmentItem(ISTaskDataModel data) {
    tvDate = mModelTask!.getFormattedBestStartDateString();
    String time = mModelTask!.getFormattedBestStartTimeString() +
        "-" +
        mModelTask!.getFormattedBestEndTimeString();
    tvTime = time;
  }

  _onItemClickAddAppointment() {
    if (mModelTask!.enumStatus == ISEnumTaskStatus.failed) {
      setState(() {
        if (mModelTask!.enumStatus == ISEnumTaskStatus.failed) {
          showToast("The task status is failed. Please fix it first.");
          return;
        }
      });
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AppointmentDetailScreen(mTaskData: mModelTask!)),
    );
  }

  _onItemClickAppointments(ISTaskDataModel data) {
    setState(() {
      if (mModelTask!.enumStatus == ISEnumTaskStatus.failed) {
        showToast("The task status is failed. Please fix it first.");
        return;
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AppointmentDetailScreen(mTaskData: mModelTask!)),
    );
  }

  _initNotesItem(ISTaskDataModel data) {
    if (mModelTask!.getClaimDataModel() == null) return;
    arrayNotes = [];

    for (var note in mModelTask!.arrayNotes) {
      if (note.szComments.isNotEmpty) {
        arrayNotes.add(note);
      }
    }
    tvTitleNote = "Note: " + arrayNotes.length.toString();
  }

  _onItemClickNotes(ISTaskDataModel data) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotesScreen(mModelTask: data)),
    );
  }

  _onItemClickAdjustForms(ISTaskDataModel data) {
    //TODO:
    // ((ClaimProgressActivity) mActivity).startFormsListFragment(data);
  }

  _onItemClickHoverLink(ISTaskDataModel data) async {
    String link = data.modelHoverLink.szAndroidLink;
    if (link.isEmpty) return;
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  _onItemClickReserves(ISTaskDataModel data) {
    Navigator.push(
      context,
      createRoute(ClaimReserversScreen(mModelTask: data)),
    );
  }

  _initAttachmentsItem(ISTaskDataModel data) {
    //TODO:
    // RecyclerView fileAttachView = cell.findViewById(R.id.file_attach_view);
    // fileAttachView.setLayoutManager(new LinearLayoutManager(mActivity, LinearLayoutManager.HORIZONTAL, false));
    if (data.getClaimDataModel() == null) return;
    arrayMedia = [];

    for (var note in mModelTask!.arrayNotes) {
      for (ISMediaDataModel media in note.arrayMedia) {
        arrayMedia.add(media);
      }
    }

    List<ISMediaDataModel> list = [];
    if (arrayMedia.isNotEmpty) {
      for (var media in arrayMedia) {
        list.add(media);
      }
    }
    //TODO:
    // mAttachmentAdapter = new AttachmentsAdapter(fileAttachView, list);
    // fileAttachView.setAdapter(mAttachmentAdapter);
  }

  _onClickRoute() {
    switch (mModelTask!.enumStatus) {
      case ISEnumTaskStatus.pending:
        _promptForAcceptTask();
        break;
      case ISEnumTaskStatus.assigned:
        break;
      case ISEnumTaskStatus.scheduled:
        _startRouteForTask();
        break;
      case ISEnumTaskStatus.enRoute:
        _checkInTask();
        break;
      case ISEnumTaskStatus.arrived:
        _checkOutTask();
        break;
      case ISEnumTaskStatus.departed:
        _completeTask();
        break;
      default:
        return showToast("Route Claim : Invalid Claim Status" +
            mModelTask!.enumStatus.value);
    }
  }

  _initBottomButton() {
    _unlockButton();
    if (mModelTask!.enumStatus == ISEnumTaskStatus.pending) {
      btnRoute = AppStrings.acknowledge_assignment;
    } else if (mModelTask!.enumStatus == ISEnumTaskStatus.assigned) {
      btnRoute = AppStrings.start_route;
      _lockButton();
    } else if (mModelTask!.enumStatus == ISEnumTaskStatus.scheduled) {
      btnRoute = AppStrings.start_route;
    } else if (mModelTask!.enumStatus == ISEnumTaskStatus.enRoute) {
      btnRoute = AppStrings.check_in;
    } else if (mModelTask!.enumStatus == ISEnumTaskStatus.arrived) {
      btnRoute = AppStrings.checkout;
    } else if (mModelTask!.enumStatus == ISEnumTaskStatus.departed) {
      btnRoute = AppStrings.complete_inspection;
    } else if (mModelTask!.enumStatus == ISEnumTaskStatus.failed) {
      btnRouteVisibility = false;
    } else {
      btnRouteVisibility = false;
    }
  }

  _updateMapView() {
    _reloadMap();
  }

 Future< Set<Marker>> getmarkers() async {
    final Uint8List markerIcon = await UtilsBaseFunction.getBytesFromAsset(mModelTask!.getIconStatus(), 80);
    BitmapDescriptor icon = BitmapDescriptor.fromBytes(markerIcon);
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(mModelTask!.getBestCoordinates()!.fLatitude,mModelTask!.getBestCoordinates()!.fLongitude), //position of marker
        infoWindow: InfoWindow(
          title: mModelTask!.getAddress(),
        ),
        icon: icon,
      ));
    });
    return markers;
  }

  _reloadMap() async{
    googleMap = GoogleMap(
      zoomGesturesEnabled: true,
      mapType: MapType.normal,
      tiltGesturesEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
          zoom: UtilsMap.cameraZoom,
          tilt: UtilsMap.cameraTilt,
          bearing: UtilsMap.cameraBearing,
          target: LatLng(mModelTask!.getBestCoordinates()!.fLatitude,mModelTask!.getBestCoordinates()!.fLongitude)),
      markers: await getmarkers(),
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
        });
        getmarkers();
      },
    );
  }

  _lockButton() {
    btnRouteEnable = false;
  }

  _unlockButton() {
    btnRouteEnable = true;
  }

  int getItemType(int pos) {
    switch (mModelTask!.enumStatus) {
      case ISEnumTaskStatus.pending:
        return Pending_Item_Types[pos];
      case ISEnumTaskStatus.assigned:
      case ISEnumTaskStatus.scheduled:
        if (mModelTask!.isAppointmentSet())
          return Complete_Item_Types[pos];
        else
          return Assigned_Item_Types[pos];
      case ISEnumTaskStatus.enRoute:
      case ISEnumTaskStatus.arrived:
      case ISEnumTaskStatus.departed:
      case ISEnumTaskStatus.completed:
        return Complete_Item_Types[pos];
      default:
        return ITEM_TYPE_DETAILS;
    }
  }

  _promptForAcceptTask() {
    UtilsBaseFunction.showBottomSheet(
        context, _acceptPendingTask, _declinePendingTask);
  }

  _acceptPendingTask() {
    showProgressHUD();
    ISClaimManager.sharedInstance.requestUpdateTaskStatus(
        mModelTask!, ISEnumTaskStatus.assigned, (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        _refreshUI();
      } else {
        hideProgressHUD();
        if (responseDataModel.errorMessage == "") {
          showToast("Sorry, we've encountered an error.");
        } else {
          showToast(responseDataModel.getBeautifiedErrorMessage());
        }
      }
    });
  }

  _declinePendingTask() {
    showProgressHUD();
    ISClaimManager.sharedInstance.requestDeclineTask(mModelTask!, "",
        (responseDataModel) {
      if (responseDataModel.isSuccess()) {
        hideProgressHUD();
      } else {
        hideProgressHUD();
        if (responseDataModel.errorMessage == "") {
          showToast("Sorry, we've encountered an error.");
        } else {
          showToast(responseDataModel.getBeautifiedErrorMessage());
        }
      }
    });
  }

  _startRouteForTask() {
    showProgressHUD();
    ISClaimManager.sharedInstance.requestUpdateTaskStatus(
        mModelTask!, ISEnumTaskStatus.enRoute, (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        _refreshUI();
        _promptForOpenNavigationApps();
      } else {
        hideProgressHUD();
        if (responseDataModel.errorMessage == "") {
          showToast("Sorry, we've encountered an error.");
        } else {
          showToast(responseDataModel.getBeautifiedErrorMessage());
        }
      }
    });
  }

  _checkInTask() {
    showProgressHUD();
    ISClaimManager.sharedInstance.requestUpdateTaskStatus(
        mModelTask!, ISEnumTaskStatus.arrived, (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        _refreshUI();
      } else {
        hideProgressHUD();
        if (responseDataModel.errorMessage == "") {
          showToast("Sorry, we've encountered an error.");
        } else {
          showToast(responseDataModel.getBeautifiedErrorMessage());
        }
      }
    });
  }

  _checkOutTask() {
    showProgressHUD();
    ISClaimManager.sharedInstance.requestUpdateTaskStatus(
        mModelTask!, ISEnumTaskStatus.departed, (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        _refreshUI();
      } else {
        hideProgressHUD();
        if (responseDataModel.errorMessage == "") {
          showToast("Sorry, we've encountered an error.");
        } else {
          showToast(responseDataModel.getBeautifiedErrorMessage());
        }
      }
    });
  }

  _completeTask() {
    showProgressHUD();
    ISClaimManager.sharedInstance.requestUpdateTaskStatus(
        mModelTask!, ISEnumTaskStatus.completed, (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        _refreshUI();
      } else {
        hideProgressHUD();
        if (responseDataModel.errorMessage == "") {
          showToast("Sorry, we've encountered an error.");
        } else {
          showToast(responseDataModel.getBeautifiedErrorMessage());
        }
      }
    });
  }

  _promptForOpenNavigationApps() {
    final preference =
        ISAppManager.sharedInstance.modelSettings.enumMapPreference;
    if (preference == ISEnumSettingMapViewPreference.waze) {
      _openWaze();
    } else if (preference == ISEnumSettingMapViewPreference.googleMaps) {
      _openGoogleMaps();
    } else if (preference == ISEnumSettingMapViewPreference.hereWeGo) {
      _openHereWeGo();
    } else if (preference == ISEnumSettingMapViewPreference.appleMaps) {
      _openAppleMaps();
    } else {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            margin: AppDimens.activity_margin,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: AppDimens.activity_padding,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Navigation",
                        textAlign: TextAlign.center,
                        style: AppStyles.inputTextStyle,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Please select navigation application",
                        textAlign: TextAlign.center,
                        style: AppStyles.inputTextStyle
                            .copyWith(fontSize: AppDimens.text_size),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0.5, color: Colors.transparent),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: const Text(
                      "Waze App",
                      textAlign: TextAlign.center,
                      style: AppStyles.normalText,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      ISAppManager
                              .sharedInstance.modelSettings.enumMapPreference =
                          ISEnumSettingMapViewPreference.waze;
                      ISAppManager.sharedInstance.saveToLocalStorage();
                      _openWaze();
                    },
                  ),
                ),
                const Divider(height: 0.5, color: Colors.transparent),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: const Text(
                      "GoogleMaps App",
                      textAlign: TextAlign.center,
                      style: AppStyles.normalText,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      ISAppManager
                              .sharedInstance.modelSettings.enumMapPreference =
                          ISEnumSettingMapViewPreference.googleMaps;
                      ISAppManager.sharedInstance.saveToLocalStorage();
                      _openGoogleMaps();
                    },
                  ),
                ),
                const Divider(height: 0.5, color: Colors.transparent),
                Visibility(
                  visible: Platform.isIOS,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                    ),
                    child: ListTile(
                      title: const Text(
                        "Apple Maps App",
                        textAlign: TextAlign.center,
                        style: AppStyles.normalText,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ISAppManager.sharedInstance.modelSettings
                                .enumMapPreference =
                            ISEnumSettingMapViewPreference.appleMaps;
                        ISAppManager.sharedInstance.saveToLocalStorage();
                        _openAppleMaps();
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: Platform.isAndroid,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                    ),
                    child: ListTile(
                      title: const Text(
                        "HERE WeGo App",
                        textAlign: TextAlign.center,
                        style: AppStyles.inputTextStyle,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ISAppManager.sharedInstance.modelSettings
                                .enumMapPreference =
                            ISEnumSettingMapViewPreference.hereWeGo;
                        ISAppManager.sharedInstance.saveToLocalStorage();
                        _openHereWeGo();
                      },
                    ),
                  ),
                ),
                const Divider(height: 8, color: Colors.transparent),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  child: ListTile(
                    title: const Text(
                      AppStrings.cancel,
                      textAlign: TextAlign.center,
                      style: AppStyles.inputTextStyle,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  _openWaze() async {
    ISAppManager managerApp = ISAppManager.sharedInstance;
    managerApp.modelSettings.enumMapPreference =
        ISEnumSettingMapViewPreference.waze;
    managerApp.saveToLocalStorage();
    ISClaimDataModel? claim = mModelTask!.getClaimDataModel();
    if (claim == null) return;
    String wazeUrl = "https://waze.com/ul?ll=" +
        claim.coordLocation.fLatitude.toString() +
        "," +
        claim.coordLocation.fLongitude.toString() +
        "&navigate=yes";
    var uri = Uri.encodeFull(wazeUrl);
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      showToast("Waze App not found.");
    }
  }

  _openGoogleMaps() async {
    ISAppManager managerApp = ISAppManager.sharedInstance;
    managerApp.modelSettings.enumMapPreference =
        ISEnumSettingMapViewPreference.googleMaps;
    managerApp.saveToLocalStorage();
    ISClaimDataModel? claim = mModelTask!.getClaimDataModel();
    if (claim == null) return;
    String googleUrl = "google.navigation:q=" +
        claim.coordLocation.fLatitude.toString() +
        "," +
        claim.coordLocation.fLongitude.toString() +
        "&mode=d";
    var uri = Uri.encodeFull(googleUrl);
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      showToast("Google Maps App not found.");
    }
  }

  _openHereWeGo() async {
    ISAppManager managerApp = ISAppManager.sharedInstance;
    managerApp.modelSettings.enumMapPreference =
        ISEnumSettingMapViewPreference.hereWeGo;
    managerApp.saveToLocalStorage();
    ISClaimDataModel? claim = mModelTask!.getClaimDataModel();
    if (claim == null) return;
    String hereWoGoUrl =
        "here.directions://v1.0/mylocation/${claim.coordLocation.fLatitude.toString()},${claim.coordLocation.fLongitude.toString()}?m=w";
    var uri = Uri.encodeFull(hereWoGoUrl);
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      showToast("HERE WeGo App not found.");
    }
  }

  _openAppleMaps() async {
    ISAppManager managerApp = ISAppManager.sharedInstance;
    managerApp.modelSettings.enumMapPreference =
        ISEnumSettingMapViewPreference.appleMaps;
    managerApp.saveToLocalStorage();
    ISClaimDataModel? claim = mModelTask!.getClaimDataModel();
    if (claim == null) return;
    String appleUrl =
        "https://maps.apple.com/?q=${claim.coordLocation.fLatitude.toString()},${claim.coordLocation.fLongitude.toString()}";
    var uri = Uri.encodeFull(appleUrl);
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      showToast("Apple Maps App not found.");
    }
  }

  _onItemClickDetail(ISTaskDataModel taskDataModel) {
    Navigator.push(
      context,
      createRoute(ClaimDetailScreen(mModelTask: taskDataModel)),
    );
  }

  _callPhone(String phone) {
    launch("tel://" + phone);
  }

  _sendEmail(String email) {
    launch("mailto:$email");
  }

  _sendMessage(String phoneNumber) async {
    // Android
    var uri = 'sms:$phoneNumber';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      var uri = 'sms:$phoneNumber';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  _promptDatePickerSelection() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(
                2030)) //what will be the up to supported date in picker
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      String date = ISUtilsDate.getStringFromDateTimeWithFormat(
          pickedDate, ISEnumDateTimeFormat.MMddyyyy.value, false);
      _promptTimePickerSelection(date);
    });
  }

  _promptTimePickerSelection(String date) async {
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timePicked != null) timePicked.replacing(hour: timePicked.hourOfPeriod);
    DateTime tempDate = DateFormat(ISEnumDateTimeFormat.hhmm.value).parse(
        timePicked!.hour.toString() + ":" + timePicked.minute.toString());
    var dateFormat = DateFormat(
        ISEnumDateTimeFormat.hhmma.value); // you can change the format here
    String time = dateFormat.format(tempDate);
    String dateTime = date + " " + time;

    _didFirstContact(ISUtilsDate.getDateTimeFromStringWithFormat(
        dateTime, ISEnumDateTimeFormat.MMddyyyy_hhmma.value, false));
  }

  _didFirstContact(DateTime? dateFirstMeeting) {
    if (dateFirstMeeting == null) return;
    showProgressHUD();
    ISClaimManager.sharedInstance.requestConfirmFirstContact(
        mModelTask!, dateFirstMeeting, (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        _refreshUI();
      } else {
        hideProgressHUD();
        if (responseDataModel.errorMessage == "") {
          showToast("Sorry, we've encountered an error.");
        } else {
          showToast(responseDataModel.getBeautifiedErrorMessage());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _reloadMap();
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: statusBarColor),
        title: Text(widget.mModelTask.modelClaim.szClaimNumber,
            style: AppStyles.inputTextStyle
                .copyWith(color: AppColors.font_white_color)),
        backgroundColor: statusBarColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          top: false,
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: googleMap,
                  ),
                  Expanded(
                      child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                onTap: () {
                                  _sendEmail(
                                      mModelTask!.getContactEmailAddress());
                                },
                                child: Image.asset(
                                  'assets/images/ic_email_red_48dp.png',
                                  width: 50,
                                  height: AppDimens.send_button_size,
                                ),
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                onTap: () {
                                  _callPhone(
                                      mModelTask!.getContactPhoneNumber());
                                },
                                child: Image.asset(
                                  'assets/images/ic_phone_blue_48dp.png',
                                  width: 50,
                                  height: AppDimens.send_button_size,
                                ),
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                onTap: () {
                                  _sendMessage(
                                      mModelTask!.getContactPhoneNumber());
                                },
                                child: Image.asset(
                                  'assets/images/ic_chat_yellow_48dp.png',
                                  width: 50,
                                  height: AppDimens.send_button_size,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Column(
                                      children: [
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(tvName,
                                                    style: AppStyles
                                                        .textMediumBold
                                                        .copyWith(
                                                            color: AppColors
                                                                .font_black_color)),
                                                Text(tvProperty,
                                                    style: AppStyles.normalText
                                                        .copyWith(
                                                            color: AppColors
                                                                .font_grey_color)),
                                                SizedBox(height: 5),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50,
                                                  child: Row(
                                                    children: [
                                                      Visibility(
                                                          visible:
                                                              id_mark_address,
                                                          child: Image.asset(
                                                            'assets/images/ic_marker_blue_dark.png',
                                                            width: 14,
                                                            height: 14,
                                                          )),
                                                      SizedBox(width: 8),
                                                      Expanded(
                                                          child: Text(tvAddress,
                                                              style: AppStyles
                                                                  .normalText
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .font_black_color)))
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                InkWell(
                                                  onTap: () {
                                                    if (!tvContactDisabled) {
                                                      _promptDatePickerSelection();
                                                    }
                                                  },
                                                  child: Text(tvContact,
                                                      style: AppStyles
                                                          .normalText
                                                          .copyWith(
                                                              color: tvContactDisabled
                                                                  ? AppColors
                                                                      .black
                                                                  : AppColors
                                                                      .indigo_button)),
                                                )
                                              ],
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: 18,
                                              color: AppColors.gray_darkest,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      _onItemClickDetail(widget.mModelTask);
                                    },
                                  ),
                                  SizedBox(height: 5),
                                  Divider(
                                      height: mViewItemAddAppointment ? 1 : 0),

                                  //Add Appointment
                                  Visibility(
                                    visible: mViewItemAddAppointment,
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/ic_calendar_grey2.png',
                                                width: 14,
                                                height: 14,
                                              ),
                                              SizedBox(width: 8),
                                              Text("Add Appointment",
                                                  style: AppStyles.normalText)
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 18,
                                            color: AppColors.gray_darkest,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        _onItemClickAddAppointment();
                                      },
                                    ),
                                  ),

                                  Divider(height: mViewItemAppointment ? 1 : 0),
                                  //appointment date time
                                  Visibility(
                                    visible: mViewItemAppointment,
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/ic_calendar_grey2.png',
                                                width: 14,
                                                height: 14,
                                              ),
                                              SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(tvDate,
                                                      style:
                                                          AppStyles.normalText),
                                                  Text(tvTime,
                                                      style:
                                                          AppStyles.normalText)
                                                ],
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 18,
                                            color: AppColors.gray_darkest,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        _onItemClickAppointments(mModelTask!);
                                      },
                                    ),
                                  ),

                                  //Hover
                                  Divider(height: mViewItemHover ? 1 : 0),
                                  Visibility(
                                    visible: mViewItemHover,
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Hovers",
                                              style: AppStyles.normalText),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 18,
                                            color: AppColors.gray_darkest,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        _onItemClickHoverLink(mModelTask!);
                                      },
                                    ),
                                  ),
                                  //Adjuster form
                                  Divider(height: 1),
                                  Visibility(
                                    visible: true,
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Adjuster Forms",
                                              style: AppStyles.normalText),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 18,
                                            color: AppColors.gray_darkest,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        _onItemClickAdjustForms(mModelTask!);
                                      },
                                    ),
                                  ),
                                  Divider(height: 1),

                                  //Notes form
                                  Visibility(
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(tvTitleNote,
                                                  style: AppStyles.normalText),
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 18,
                                            color: AppColors.gray_darkest,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        _onItemClickNotes(mModelTask!);
                                      },
                                    ),
                                  ),
                                  Divider(height: mViewItemReserves ? 1 : 0),

                                  //Reservers
                                  Visibility(
                                      visible: mViewItemReserves,
                                      child: ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Reservers",
                                                style: AppStyles.normalText),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: 18,
                                              color: AppColors.gray_darkest,
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          _onItemClickReserves(mModelTask!);
                                        },
                                      )),
                                  Divider(height: 1),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
                  Visibility(
                      visible: btnRouteVisibility,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: AppDimens.activity_padding_small,
                        color: Colors.white,
                        child: Container(
                          margin: AppDimens.activity_margin,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              if (btnRouteEnable) {
                                _onClickRoute();
                              }
                            },
                            style: AppStyles.buttonSquareGreen.copyWith(
                                backgroundColor: MaterialStateProperty.all(
                                    btnRouteEnable
                                        ? AppColors.blue_dark_button
                                        : AppColors.gray_dark)),
                            child: Text(
                              btnRoute,
                              textAlign: TextAlign.center,
                              style: AppStyles.buttonTextStyle,
                            ),
                          ),
                        ),
                      ))
                ],
              )),
        ),
      ),
    );
  }

  @override
  claimListUpdated() {
    setState(() {
      if (mModelTask!.isOutdated) {
        mModelTask = ISClaimManager.sharedInstance.getTaskById(mModelTask!.id);
      }
      if (mModelTask == null) {
        onBackPressed();
      } else {
        _refreshUI();
      }
    });
  }

  @override
  formListUpdated() {}

  @override
  requestFormReload() {}

  @override
  void onSelectMediaToPreview(
      List<ISMediaDataModel> arrayMedia, int mediaIndex) {}

  @override
  messageListUpdated() {
  }
  @override
  channelListUpdated() {
  }
}
