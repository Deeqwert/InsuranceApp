import 'package:insurance/isModel/claim/dataModel/is_media_data_model.dart';

abstract class MediaListener {
  progressBarShow(bool shouldShow);
  completedUploadAndResponse(ISMediaDataModel media);
  completeUploadMultiPhotosAndResponse(List<ISMediaDataModel> array);
  completedDownload(ISMediaDataModel media);
}