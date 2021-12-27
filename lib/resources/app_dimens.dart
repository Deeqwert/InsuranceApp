import 'package:flutter/material.dart';

/// App Dimensions Class - Resource class for storing app level dimensions constants
abstract class AppDimens {
  static double getHeight(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  //START
  static const EdgeInsets activity_horizontal_margin =
  EdgeInsets.symmetric(horizontal: 12.0);
  static const EdgeInsets activity_vertical_margin =
  EdgeInsets.symmetric(horizontal: 12.0);

  // Margin
  static const EdgeInsets activity_margin_very_small = EdgeInsets.all(2.0);
  static const EdgeInsets activity_margin_small = EdgeInsets.all(5.0);
  static const EdgeInsets activity_margin = EdgeInsets.all(10.0);
  static const EdgeInsets activity_margin_n = EdgeInsets.all(12.0);
  static const EdgeInsets activity_margin_et = EdgeInsets.all(14.0);
  static const EdgeInsets activity_margin_navigation = EdgeInsets.all(15.0);
  static const EdgeInsets activity_margin_medium = EdgeInsets.all(15.0);
  static const EdgeInsets activity_margin_large = EdgeInsets.all(20.0);
  static const EdgeInsets activity_margin_extra_large = EdgeInsets.all(30.0);
  static const EdgeInsets activity_margin_extra_extra_large = EdgeInsets.all(50.0);
  static const EdgeInsets activity_margin_extra_extra_extra_large = EdgeInsets.all(100.0);
  static const EdgeInsets activity_margin_top_group = EdgeInsets.all(60.0);
  static const EdgeInsets activity_margin_logo_group = EdgeInsets.all(40.0);
  static const EdgeInsets activity_margin_account_logo_group = EdgeInsets.all(60.0);
  static const EdgeInsets activity_status_bar_margin = EdgeInsets.all(22.0);

  static const EdgeInsets page_indicator_margin = EdgeInsets.all(50.0);
  static const EdgeInsets text_on_page_indicator_margin = EdgeInsets.all(70.0);

  // Padding
  static const EdgeInsets activity_padding_small = EdgeInsets.all(5.0);
  static const EdgeInsets activity_padding = EdgeInsets.all(10.0);
  static const EdgeInsets activity_padding_navigation = EdgeInsets.all(15.0);
  static const EdgeInsets activity_padding_large = EdgeInsets.all(20.0);
  static const EdgeInsets activity_padding_extra_large = EdgeInsets.all(30.0);
  static const EdgeInsets activity_padding_extra_extra_large = EdgeInsets.all(50.0);


  static const EdgeInsets padding_vertical_text_view =
  EdgeInsets.symmetric(vertical: 2.0);
  static const EdgeInsets padding_horizontal_text_view =
  EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets padding_logo_group = EdgeInsets.all(60.0);
  static const EdgeInsets padding_account_logo_group = EdgeInsets.all(80.0);
  static const EdgeInsets padding_text_view_very_small = EdgeInsets.all(2.0);
  static const EdgeInsets padding_text_view_small = EdgeInsets.all(2.0);
  static const EdgeInsets padding_text_view_normal = EdgeInsets.all(6.0);

  static const EdgeInsets padding_text_view_large = EdgeInsets.all(10.0);
  static const EdgeInsets padding_button = EdgeInsets.all(5.0);
  static const EdgeInsets padding_edit_text = EdgeInsets.all(5.0);
  static const EdgeInsets padding_edit_text_large = EdgeInsets.all(10.0);
  static const EdgeInsets padding_like_text = EdgeInsets.all(20.0);
  static const EdgeInsets padding_like_text_large = EdgeInsets.all(35.0);
  static const EdgeInsets padding_toolbar_btn = EdgeInsets.all(6.0);
  static const EdgeInsets padding_button_horizontal = EdgeInsets.all(26.0);
  static const EdgeInsets padding_tool_bar_top = EdgeInsets.all(24.0);
  static const EdgeInsets padding_navigation_title = EdgeInsets.all(16.0);

  // ListView/recycler

  static const double recycler_item_size = 100.0;
  static const double recycler_img_height = 75.0;
  static const double item_text_margin = 10.0;
  static const EdgeInsets item_img_padding = EdgeInsets.all(15.0);
  static const double item_img_size = 80.0;
  static const double item_jobs_height = 150.0;
  static const double item_jobs_width = 120.0;

  // TextSize
  static const double text_very_small_size = 10.0;
  static const double text_small_size = 12.0;
  static const double text_size = 14.0;
  static const double text_normal_size = 16.0;
  static const double text_medium_size = 18.0;
  static const double text_large_size = 20.0;
  static const double text_extra_large_size = 24.0;
  static const double text_extra_extra_large_size = 36.0;

  static const double text_button_small_size = 14.0;
  static const double text_button_size = 18.0;
  static const double text_button_size_large = 24.0;
  static const double text_button_size_extra_large = 28.0;

  // Button
  static const double button_height = 32.0;
  static const double button_small_height = 26.0;
  static const double button_medium_height = 40.0;
  static const double button_event_height = 60.0;
  static const double button_transparent_height = 48.0;
  static const double toolbar_image_button_size = 48.0;

  static const double button_height_ellipse = 56.0;
  static const double button_height_comments = 30.0;
  static const EdgeInsets button_padding_small = EdgeInsets.all(10.0);
  static const EdgeInsets button_padding = EdgeInsets.all(30.0);
  static const EdgeInsets button_img_padding = EdgeInsets.all(5.0);
  static const EdgeInsets button_padding_comments = EdgeInsets.all(15.0);
  static const double button_radius = 8.0;
  static const double button_radius_toolbar = 4.0;
  static const double button_stroke = 1.0;
  static const EdgeInsets circle_button_margin = EdgeInsets.all(30.0);
  static const double circle_button_size = 64.0;
  static const double button_radius_comments = 4.0;

  // TextView-EditText
  static const double edit_text_height = 64.0;

  // Other
  static const double border_line_height = 0.5;
  static const double header_img_height = 200.0;
  static const double card_view_elevation = 0.0;
  static const double card_view_radius = 10.0;
  static const double logo_img_size = 80.0;
  static const double logo_home_img_height = 100.0;
  static const EdgeInsets bottom_button_margin_size = EdgeInsets.only(bottom: 180);
  static const double shadow_height = 10.0;
  static const double text_placeholder_size = 60.0;
  static const double drop_down_vertical_offset = 40.0;
  static const double DEFAULT_BITMAP_SIZE_USER_AVATAR = 120.0;
  static const double DEFAULT_BITMAP_SIZE_MEDIA = 420.0;
  static const double DEFAULT_BITMAP_SIZE_MARKER = 32.0;

  static const double filter_borderline_width = 150.0;
  static const double filter_pin_size = 40.0;
  static const double editTextHeight = 40.0;


  // CardStack
  static const EdgeInsets left_cardstack_padding = EdgeInsets.only(bottom: 10);
  static const EdgeInsets right_cardstack_padding = EdgeInsets.only(bottom: 10);
  static const EdgeInsets top_cardstack_padding = EdgeInsets.only(bottom: 100);

   // Toolbar Elevation

  static const double toolbar_elevation = 6.0;
  static const double navigation_drawer_horizontal_margin = 16.0;

  static const double header_navdrawer_height = 147.0;
  static const double bottom_button_height = 48.0;
  static const double bottom_button_margin = 20.0;

   // Summary List

  static const double send_button_size = 50.0;
  static const double thumbnail_size = 50.0;
  static const double ic_download_size = 44.0;
  static const EdgeInsets list_item_margin = EdgeInsets.all(20);
  static const EdgeInsets list_item_margin_top_bottom = EdgeInsets.only(top: 20);


}
