import 'package:flutter/material.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';

abstract class AppStyles {

  static const TextStyle inputTextStyle = TextStyle(
      color: AppColors.font_grey_edit_text,
      fontSize: AppDimens.text_medium_size,
      fontWeight: FontWeight.w500
  );

  static const TextStyle textMediumBold = TextStyle(
      color: AppColors.font_white_color,
      fontSize: AppDimens.text_medium_size,
      fontWeight: FontWeight.w500,
  );

  static const TextStyle textSmall = TextStyle(
    color: AppColors.font_white_color,
    fontSize: AppDimens.text_small_size,
  );

  static const TextStyle textMediumRegular = TextStyle(
    color: AppColors.font_white_color,
    fontSize: AppDimens.text_medium_size,
  );
  static const TextStyle textNormalBold = TextStyle(
    color: AppColors.black,
    fontSize: AppDimens.text_normal_size,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle textNormal = TextStyle(
    color: AppColors.black,
    fontSize: AppDimens.text_normal_size,
  );

  static const TextStyle appHeadertitle = TextStyle(
      color: AppColors.font_white_color,
      fontSize: AppDimens.text_size,
      fontWeight: FontWeight.w500
  );
  static const TextStyle textLarge = TextStyle(
      color: AppColors.font_grey_edit_text,
      fontSize: AppDimens.text_large_size
  );
  static const TextStyle buttonTransparent = TextStyle(
      color: AppColors.indigo_button,
      fontSize: AppDimens.text_button_small_size,
  );
  static const TextStyle normalText = TextStyle(
      color: AppColors.font_grey_edit_text,
      fontSize: AppDimens.text_size,
  );
  static InputDecoration textInputDecoration = InputDecoration(
      errorMaxLines: 1,
      contentPadding: EdgeInsets.only(left: 10,right: 10),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.grey_edit_text),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.grey_edit_text),
        borderRadius: BorderRadius.circular(8.0),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      filled: true,
      fillColor: AppColors.white_edit_text);

      // ignore: non_constant_identifier_names
      static InputDecoration DisabledtextInputDecoration = InputDecoration(
      errorMaxLines: 1,
      contentPadding: EdgeInsets.only(left: 10,right: 10),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.grey_edit_text),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.grey_edit_text),
        borderRadius: BorderRadius.circular(8.0),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      filled: true,
      fillColor: AppColors.gray_light);

  static ButtonStyle buttonSquareGreen = ElevatedButton.styleFrom(
    minimumSize:  Size(50, AppDimens.button_height),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: AppColors.white_button,
    fontSize: AppDimens.text_button_small_size,
  );

  static ThemeData appTheme = ThemeData(
      primaryColorDark: AppColors.colorPrimary,
      primaryColor: AppColors.colorPrimaryDark);
}
