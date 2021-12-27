import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insurance/isModel/claim/dataModel/is_media_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_note_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';
import 'package:insurance/isModel/claim/is_caim_manager.dart';
import 'package:insurance/isModel/communications/is_url_manager.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/listeners/media_listener.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:insurance/screens/note_details_screen.dart';
import 'package:insurance/utils/utils_base_functions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class AddNotesScreen extends BaseScreen {
  final NoteMediaPreviewListener? mediaPreviewListener;
  final ISTaskDataModel modelTask;
  const AddNotesScreen({Key? key,required this.modelTask,required this.mediaPreviewListener}) : super(key: key);
  @override
  AddNotesScreenState createState() => AddNotesScreenState();
}
class AddNotesScreenState extends BaseScreenState<AddNotesScreen> implements MediaListener{
  final _picker = ImagePicker();
  final etComposeText=TextEditingController();
  ISTaskDataModel? mModelTask;
  List<ISMediaDataModel> arrayMedia = [];
  List<ISMediaDataModel> arrayMediaTemp = [];
  bool isAddPhoto=true;
  @override
  void initState() {
    ISMediaDataModel? isMediaDataModel=ISMediaDataModel();
    arrayMedia.insert(0,isMediaDataModel);
    _initArguments();
    super.initState();
  }

  _initArguments() {
    if (widget.modelTask.id.isNotEmpty) {
      mModelTask=ISClaimManager.sharedInstance.getTaskById(widget.modelTask.id);
    }
  }

  _showTakePhotoDialog() {
    UtilsBaseFunction.showImagePicker(
        context, _takePhotoFromCamera, _choosePhotoFromGallery);
  }

  Future _choosePhotoFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    final File file = File(pickedFile!.path);
    _didPhotosCaptureFinish(file);
  }



  Future _takePhotoFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    final File file = File(pickedFile!.path);
    _didPhotosCaptureFinish(file);
  }


   _didPhotosCaptureFinish(File image) {
     showProgressHUD();
     ISClaimManager.sharedInstance.requestUploadPhotoForTask(mModelTask!,image,(responseDataModel) {
       hideProgressHUD();
       if (responseDataModel.isSuccess()) {
        ISMediaDataModel medium= responseDataModel.parsedObject;
         completedUploadAndResponse(medium);
       } else {
           if(responseDataModel.errorMessage!=""){
             showToast(responseDataModel.getBeautifiedErrorMessage());
           }else{
             showToast("Sorry, we've encountered an error");
           }
       }
     });
  }

   bool _saveNotes(){
    DateTime now = DateTime.now();
    String strNote = etComposeText.text.toString();
    if(strNote.isEmpty) {
      showToast("Please input some notes");
      return false;
    }
    _addNewNote(etComposeText.text.toString(), now);
    return true;
  }

  _addNewNote(String note,DateTime addon){
    if(mModelTask == null) return;
    showProgressHUD();
    ISNoteDataModel noteModel = ISNoteDataModel();
    noteModel.szComments = note;
    noteModel.arrayMedia.addAll(arrayMediaTemp);
    ISClaimManager.sharedInstance.requestAddNoteForTask(mModelTask!,noteModel,(responseDataModel) {
      hideProgressHUD();
      if (responseDataModel.isSuccess()) {
        Navigator.pop(context);
      } else {
          if(responseDataModel.errorMessage!=""){
            showToast(responseDataModel.getBeautifiedErrorMessage());
          }else{
            showToast("Sorry, we've encountered an error");
          }
      }
    });
  }

  _onClickImage(int position) {
    widget.mediaPreviewListener!.onSelectMediaToPreview(arrayMedia, position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:  AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: mModelTask!.getColorStatus()),
          title: Text(mModelTask!.modelClaim.szClaimNumber,
              style: AppStyles.appHeadertitle),
          backgroundColor: mModelTask!.getColorStatus(),
      actions: <Widget>[
        Padding(
          padding: AppDimens.activity_vertical_margin.copyWith(top: 20),
          child: GestureDetector(
            onTap: () {
             _saveNotes();
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
                    color: AppColors.background_white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppDimens.card_view_radius),
                        topRight: Radius.circular(AppDimens.card_view_radius))),
                height: MediaQuery.of(context).size.height - 40,
                child: Container(
                    child: Column(
                      children: [
                        Container(
                            margin: AppDimens.activity_margin,
                            child: Column(
                              children: [
                                Container(
                                  child: TextFormField(
                                      controller: etComposeText,
                                      textInputAction: TextInputAction.done,
                                      obscureText: false,
                                      maxLines: 7,
                                      decoration: AppStyles.textInputDecoration
                                          .copyWith(
                                          contentPadding:
                                          EdgeInsets.all(5))),
                                ),
                                SizedBox(height: 10),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    childAspectRatio: 1.0,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                    maxCrossAxisExtent: 50,
                                  ),
                                  itemCount: arrayMedia.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    final item = arrayMedia[index];
                                    return InkWell(
                                      onTap: () {
                                        _onClickImage(index);
                                      },
                                      child: index==arrayMedia.length-1
                                          ? InkWell(
                                        onTap: () {
                                          _showTakePhotoDialog();
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: AppColors
                                                  .font_white_color,
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      1))),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors
                                                            .gray_dark)),
                                                child: Icon(
                                                  Icons.add,
                                                  color:
                                                  AppColors.gray_dark,
                                                  size: 40.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ) : ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child:item.enumMimeType.value == ISEnumMediaMimeType.pdf.value?
                                        Image.asset(
                                          "assets/images/placeholder_pdf.png",
                                          fit: BoxFit.fill,
                                        ):
                                        Image.network(
                                          ISUrlManager.claimApi.getEndpointForMediaWithId(mModelTask!.id, mModelTask!.modelClaim.id, item.mediaId),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            )),
                      ],
                    )));
          }))
    );
  }

  @override
  completeUploadMultiPhotosAndResponse(List<ISMediaDataModel> array) {
  }

  @override
  completedDownload(ISMediaDataModel media) {
  }

  @override
  completedUploadAndResponse(ISMediaDataModel media) {
    setState(() {
      arrayMedia.insert(0,media);
      arrayMediaTemp.add(media);
    });
  }

  @override
  progressBarShow(bool shouldShow) {

  }
}


