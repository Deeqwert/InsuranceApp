import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insurance/isModel/claim/dataModel/is_media_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_note_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/is_caim_manager.dart';
import 'package:insurance/isModel/communications/is_url_manager.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class NotesDetailsScreen extends BaseScreen {
  final ISTaskDataModel modelTask;
  final ISNoteDataModel arrayNotes;
  final NoteMediaPreviewListener? mediaPreviewListener;
  const NotesDetailsScreen(
      {Key? key, required this.modelTask, required this.arrayNotes,required this.mediaPreviewListener})
      : super(key: key);
  @override
  _NotesDetailsScreenState createState() => _NotesDetailsScreenState();
}

class _NotesDetailsScreenState extends BaseScreenState<NotesDetailsScreen> {
  ISTaskDataModel? modelTask;
  ISNoteDataModel? note;
  @override
  void initState() {
    _initArguments();
    super.initState();
  }

  _initArguments() {
    if (widget.modelTask.id.isNotEmpty) {
      modelTask =
          ISClaimManager.sharedInstance.getTaskById(widget.modelTask.id);
    }
    if (widget.arrayNotes.id.isNotEmpty) {
      note = modelTask!.getNoteById(widget.arrayNotes.id);
    }
    if (note == null) onBackPressed();
  }

  _onClickImage(int position) {
      widget.mediaPreviewListener!.onSelectMediaToPreview(note!.arrayMedia, position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: widget.modelTask.getColorStatus()),
          title: Text(modelTask!.modelClaim.szClaimNumber, style: AppStyles.appHeadertitle),
          backgroundColor: widget.modelTask.getColorStatus(),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            top: false,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: AppDimens.activity_margin_large.copyWith(bottom: 0),
                    child: Text(note!.szComments,
                        style: AppStyles.inputTextStyle
                            .copyWith(fontSize: AppDimens.text_normal_size)
                            .copyWith(color: AppColors.black)),
                  ),
                  Container(
                    margin: AppDimens.activity_margin_large,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                        maxCrossAxisExtent: 100,
                      ),
                      itemCount: note!.arrayMedia.length,
                      itemBuilder: (BuildContext ctx, index) {
                        var data=note!.arrayMedia[index];
                        return InkWell(
                            onTap: () {
                              _onClickImage(index);
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child:data.enumMimeType.value == ISEnumMediaMimeType.pdf.value?
                                Image.asset(
                                  "assets/images/placeholder_pdf.png",
                                  fit: BoxFit.fill,
                                ):
                                Image.network(
                                  ISUrlManager.claimApi.getEndpointForMediaWithId(modelTask!.id, modelTask!.modelClaim.id, data.mediaId),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ));
                      },
                    ),
                  )
                ],
              )),
            ),
          ),
        ));
  }
}

abstract class NoteMediaPreviewListener {
void onSelectMediaToPreview(List<ISMediaDataModel> arrayMedia, int mediaIndex);
}
