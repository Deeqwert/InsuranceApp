import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insurance/isModel/appManager/dataModel/is_app_setting_data_model.dart';
import 'package:insurance/isModel/appManager/is_app_manager.dart';
import 'package:insurance/isModel/claim/dataModel/is_claim_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_filter_option_data_model.dart';
import 'package:insurance/isModel/claim/is_caim_manager.dart';
import 'package:insurance/isModel/localNotification/is_notification_observer.dart';
import 'package:insurance/isModel/localNotification/is_notification_warden.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:insurance/screens/task_filter_popup_screen.dart';
import 'package:insurance/utils/utils_base_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class MapViewScreen extends BaseScreen {
  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends BaseScreenState<MapViewScreen>
    implements ISNotificationObserver, FilterPopupDialogListener {
  late GoogleMapController mapController;
  final Set<Marker> markers = new Set();
  static const LatLng showLocation = const LatLng(30.7046, 76.7179);

  List<ISTaskDataModel> arrayTasks = [];
  bool isStatusUpdated = false;

  @override
  void initState() {
    super.initState();
    ISNotificationWarden.sharedInstance.addObserver(this);
    reloadData();
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
    addAllItemsOnMap();
  }

  addAllItemsOnMap() {}

  clickedRouteButton(ISTaskDataModel task) {
    if (task.enumStatus == ISEnumTaskStatus.pending) {
      promptForAcceptTask(task);
    } else if (task.enumStatus == ISEnumTaskStatus.assigned) {
      scheduleTask(task);
    } else if (task.enumStatus == ISEnumTaskStatus.scheduled) {
      startRouteForTask(task);
    } else if (task.enumStatus == ISEnumTaskStatus.enRoute) {
      checkInTask(task);
    } else if (task.enumStatus == ISEnumTaskStatus.arrived) {
      checkOutTask(task);
    } else if (task.enumStatus == ISEnumTaskStatus.departed) {
      completeTask(task);
    }
  }

  scheduleTask(ISTaskDataModel task){
  }

  _promptForOpenNavigationApps(ISTaskDataModel task) {
    final preference =
        ISAppManager.sharedInstance.modelSettings.enumMapPreference;
    if (preference == ISEnumSettingMapViewPreference.waze) {
      _openWaze(task);
    } else if (preference == ISEnumSettingMapViewPreference.googleMaps) {
      _openGoogleMaps(task);
    } else if (preference == ISEnumSettingMapViewPreference.hereWeGo) {
      _openHereWeGo(task);
    } else if (preference == ISEnumSettingMapViewPreference.appleMaps) {
      _openAppleMaps(task);
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
                      _openWaze(task);
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
                      _openGoogleMaps(task);
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
                        _openAppleMaps(task);
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
                        _openHereWeGo(task);
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

  _openWaze(ISTaskDataModel task) async {
    ISAppManager managerApp = ISAppManager.sharedInstance;
    managerApp.modelSettings.enumMapPreference =
        ISEnumSettingMapViewPreference.waze;
    managerApp.saveToLocalStorage();
    ISClaimDataModel? claim = task.getClaimDataModel();
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

  _openGoogleMaps(ISTaskDataModel task) async {
    ISAppManager managerApp = ISAppManager.sharedInstance;
    managerApp.modelSettings.enumMapPreference =
        ISEnumSettingMapViewPreference.googleMaps;
    managerApp.saveToLocalStorage();
    ISClaimDataModel? claim = task.getClaimDataModel();
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

  _openHereWeGo(ISTaskDataModel task) async {
    ISAppManager managerApp = ISAppManager.sharedInstance;
    managerApp.modelSettings.enumMapPreference =
        ISEnumSettingMapViewPreference.hereWeGo;
    managerApp.saveToLocalStorage();
    ISClaimDataModel? claim = task.getClaimDataModel();
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

  _openAppleMaps(ISTaskDataModel task) async {
    ISAppManager managerApp = ISAppManager.sharedInstance;
    managerApp.modelSettings.enumMapPreference =
        ISEnumSettingMapViewPreference.appleMaps;
    managerApp.saveToLocalStorage();
    ISClaimDataModel? claim = task.getClaimDataModel();
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

  startRouteForTask(ISTaskDataModel task) {
    showProgressHUD();
    ISClaimManager.sharedInstance.requestUpdateTaskStatus(
        task, ISEnumTaskStatus.enRoute, (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
         isStatusUpdated=true;
         reloadData();
        _promptForOpenNavigationApps(task);
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

  checkInTask(ISTaskDataModel task){
    showProgressHUD();
    ISClaimManager.sharedInstance.requestUpdateTaskStatus(
        task, ISEnumTaskStatus.arrived, (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        isStatusUpdated=true;
        reloadData();
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

  checkOutTask(ISTaskDataModel task){
    showProgressHUD();
    ISClaimManager.sharedInstance.requestUpdateTaskStatus(
        task, ISEnumTaskStatus.departed, (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        isStatusUpdated=true;
        reloadData();
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

  completeTask(ISTaskDataModel task){
    showProgressHUD();
    ISClaimManager.sharedInstance.requestUpdateTaskStatus(
        task, ISEnumTaskStatus.completed, (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        isStatusUpdated=true;
        reloadData();
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

  promptForAcceptTask(ISTaskDataModel task) {
    UtilsBaseFunction.showBottomSheet(
        context, _acceptPendingTask(task), _declinePendingTask(task));
  }

  _acceptPendingTask(ISTaskDataModel task) {
    showProgressHUD();
    ISClaimManager.sharedInstance.requestUpdateTaskStatus(
        task, ISEnumTaskStatus.assigned, (responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        reloadData();
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

  _declinePendingTask(ISTaskDataModel task) {
    showProgressHUD();
    ISClaimManager.sharedInstance.requestDeclineTask(task, "",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: showLocation,
          zoom: 15.0,
        ),
        markers: getmarkers(),
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker Title First ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add second marker
        markerId: MarkerId(showLocation.toString()),
        position:
            LatLng(30.71245720721462, 76.70554446519816), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker Title Second ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId(showLocation.toString()),
        position:
            LatLng(30.709060152009528, 76.72159575111077), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker Title Third ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      //add more markers here
    });

    return markers;
  }

  @override
  channelListUpdated() {}

  @override
  claimListUpdated() {
    reloadData();
  }

  @override
  formListUpdated() {}

  @override
  messageListUpdated() {}

  @override
  requestFormReload() {}

  @override
  didTaskFilterPopupClearClick() {
    isStatusUpdated = true;
    ISClaimManager.sharedInstance.modelFilter = ISTaskFilterOptionDataModel();
    reloadData();
  }

  @override
  didTaskFilterPopupCloseClick() {}

  @override
  didTaskFilterPopupSearchClick(ISTaskFilterOptionDataModel filterModel) {
    isStatusUpdated = true;
    ISClaimManager.sharedInstance.modelFilter = filterModel;
    reloadData();
  }
}
