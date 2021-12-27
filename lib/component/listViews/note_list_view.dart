import 'package:flutter/material.dart';
import 'package:insurance/isModel/claim/dataModel/is_note_data_model.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/listeners/row_item_click_listner.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';

class NoteListView extends BaseScreen {
  final List<ISNoteDataModel> arrayNotes;
  final RowItemClickListener<ISNoteDataModel>? itemClickListener;
  const NoteListView(
      {Key? key, required this.arrayNotes, this.itemClickListener})
      : super(key: key);

  @override
  _NoteListViewState createState() => _NoteListViewState();
}

class _NoteListViewState extends BaseScreenState<NoteListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.arrayNotes.length,
      itemBuilder: (context, index) {
        var data = widget.arrayNotes[index];
        return Container(
            padding: EdgeInsets.only(bottom: AppDimens.activity_padding_small.bottom, top: 0),
            child: InkWell(
              onTap: () {
                widget.itemClickListener?.call(data, index);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: AppDimens.activity_margin
                            .copyWith(bottom: 0, top: 0),
                        child: Text(
                            ISUtilsDate
                                .getStringFromDateTimeWithFormat(
                                data.dateCreatedAt,
                                ISEnumDateTimeFormat
                                    .MMMdyyyy.value,
                                false) +
                                " @ " +
                                ISUtilsDate
                                    .getStringFromDateTimeWithFormat(
                                    data.dateCreatedAt,
                                    ISEnumDateTimeFormat
                                        .hhmma.value,
                                    false),
                            style: AppStyles.textSmall
                                .copyWith(
                                color: AppColors.black)),
                      ),
                      data.arrayMedia.isNotEmpty
                          ? Container(
                        margin: AppDimens.activity_margin
                            .copyWith(bottom: 0, top: 0),
                        child: Image.asset(
                          'assets/images/attachment.png',
                          width: 18,
                          height: 18,
                          color: AppColors.gray_darkest,
                        ),
                      )
                          : Container()
                    ],
                  ),
                  Container(
                    margin: AppDimens.activity_margin
                        .copyWith(bottom: AppDimens.activity_margin_small.bottom, top: AppDimens.activity_margin_small.top),
                    child: Text(data.modelModifiedBy.szUsername,
                        style: AppStyles.textSmall
                            .copyWith(color: AppColors.black)),
                  ),
                  Container(
                    margin: AppDimens.activity_margin
                        .copyWith(bottom: 5, top: 0),
                    child: Text(data.szComments,
                        style: AppStyles.textNormalBold
                            .copyWith(color: AppColors.black)),
                  ),
                  SizedBox(height: 5),
                  Divider(height: 1)
                ],
              ),
            ));
      },
    );
  }
}
