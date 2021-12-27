import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insurance/component/listViews/note_list_view.dart';
import 'package:insurance/isModel/claim/dataModel/is_media_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_note_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/is_caim_manager.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/localNotification/is_notification_observer.dart';
import 'package:insurance/isModel/localNotification/is_notification_warden.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/add_notes_screen.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:insurance/screens/note_details_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class NotesScreen extends BaseScreen {
  final ISTaskDataModel mModelTask;
  const NotesScreen({Key? key, required this.mModelTask}) : super(key: key);
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends BaseScreenState<NotesScreen>
    implements ISNotificationObserver,NoteMediaPreviewListener {
  ISTaskDataModel? mModelTask;
  List<ISNoteDataModel> arrayNotes = [];

  @override
  void initState() {

    ISNotificationWarden.sharedInstance.addObserver(this);
    _initArguments();
    _initUiView();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    ISNotificationWarden.sharedInstance.removeObserver(this);
  }

  _initArguments() {
    if (widget.mModelTask.id.isNotEmpty) {
      mModelTask =
          ISClaimManager.sharedInstance.getTaskById(widget.mModelTask.id);
    }
  }

  _initUiView() {
    _initNotesList();
  }


  _initNotesList() {
    if (mModelTask == null) return;
    arrayNotes = [];
    arrayNotes.addAll(mModelTask!.arrayNotes);
    setState(() {
      arrayNotes = arrayNotes;
    });
  }

  _startNoteDetailsScreen(ISTaskDataModel data, ISNoteDataModel note) {
    Navigator.push(
      context,
      createRoute(NotesDetailsScreen(modelTask: data, arrayNotes: note,mediaPreviewListener: this)),
    );
  }

  _startNoteAddScreen() {
    Navigator.push(
      context,
      createRoute(AddNotesScreen(modelTask: mModelTask!,mediaPreviewListener: this)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: mModelTask!.getColorStatus()),
          title: Text(mModelTask!.modelClaim.szClaimNumber,
              style: AppStyles.appHeadertitle),
          backgroundColor: widget.mModelTask.getColorStatus(),
        ),
        floatingActionButton: Container(
          child: InkWell(
            onTap: () {
              _startNoteAddScreen();
            },
            child: Image.asset(
              'assets/images/ic_composer_32dp.png',
              width: 24,
              height: 24,
              color: AppColors.black,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            top: false,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: AppDimens.activity_margin_large,
                    child: Text("Notes",
                        style: AppStyles.textMediumBold
                            .copyWith(color: AppColors.black)),
                  ),
                  Expanded(
                    child: NoteListView(
                        arrayNotes:arrayNotes,
                        itemClickListener: (notes, index) {
                         _startNoteDetailsScreen(mModelTask!, notes);
                        }),
                  )
                ],
              )),
            ),
          ),
        ));
  }

  @override
  claimListUpdated() {
    if(mModelTask!.isOutdated){
      mModelTask = ISClaimManager.sharedInstance.getTaskById(mModelTask!.id);
    }
    if(mModelTask == null) {
      onBackPressed();
    } else {
      _initNotesList();
    }
  }

  @override
  formListUpdated() {

  }

  @override
  requestFormReload() {

  }

  @override
  void onSelectMediaToPreview(List<ISMediaDataModel> arrayMedia, int mediaIndex) {
    _previewMedia(arrayMedia, mediaIndex);
  }

  _previewMedia(List<ISMediaDataModel> arrayMedia, int startIndex) {
    List<String> imageUrls = [];
    ISMediaDataModel media = arrayMedia[startIndex];
    if (media.enumMimeType.value == ISEnumMediaMimeType.pdf.value) {
      // TODO: PDF Viewer
    } else {
      for (int index = 0; index < arrayMedia.length; index++) {
        ISMediaDataModel m = arrayMedia[index];
        if (m.enumMimeType.value == ISEnumMediaMimeType.pdf.value) {
          if (index < startIndex) {
            startIndex--;
          }
        } else {
          imageUrls.add(m.getUrlString());
          ISUtilsGeneral.log("URL"+ m.getUrlString());
        }
      }
      if (startIndex < 0) startIndex = 0;
      if (startIndex >= imageUrls.length) startIndex = imageUrls.length - 1;
      _previewImages(imageUrls, startIndex);
    }
  }
  _previewImages(List<String> imageUrls, int startIndex) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.all(0),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
                width: double.infinity,
                height: double.infinity,
                child: PhotoViewGallery.builder(
                  pageController: PageController(
                    initialPage: startIndex,
                    keepPage: true,
                  ),
                  backgroundDecoration: BoxDecoration(color: Colors.black),
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(imageUrls[index]
                      ),
                      initialScale: PhotoViewComputedScale.contained,
                    );
                  },
                  itemCount: imageUrls.length,
                )
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.clear,
                  size: 24, color: AppColors.font_white_color),
            ),
          ],
        ),
      ),
    );
  }

  @override
  messageListUpdated() {
  }
  @override
  channelListUpdated() {
  }

}

