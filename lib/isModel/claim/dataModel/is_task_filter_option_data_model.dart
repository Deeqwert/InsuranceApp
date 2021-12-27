import 'package:insurance/isModel/claim/dataModel/is_claim_data_model.dart';
import 'package:insurance/isModel/claim/dataModel/is_task_data_model.dart';

class ISTaskFilterOptionDataModel {
   ISEnumTaskSortBy enumSortBy = ISEnumTaskSortBy.status;
   String szClaimNumber = "";
   String? organizationId;
   ISEnumTaskStatus enumStatus = ISEnumTaskStatus.none;
   DateTime? date;
   ISEnumClaimType enumType = ISEnumClaimType.none;

     initialize() {
     enumSortBy = ISEnumTaskSortBy.status;
     szClaimNumber = "";
     organizationId = null;
     enumStatus = ISEnumTaskStatus.none;
     date = null;
     enumType = ISEnumClaimType.none;
   }

}

enum ISEnumTaskSortBy { status, date, type }
extension ISEnumTaskSortByExtension on ISEnumTaskSortBy {
  int get value {
    switch (this) {
      case ISEnumTaskSortBy.status:
        return 0;
      case ISEnumTaskSortBy.date:
        return 1;
      case ISEnumTaskSortBy.type:
        return 2;
    }
  }
}


