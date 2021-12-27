import 'package:flutter/material.dart';

class Constants {
   static final String ERROR_RESPONSE_UNKNOWN = "520";
   static bool shouldEnableFabric = true;

  //Broadcast
   static final String BROADCAST_CHANNEL_LISTUPDATED = "Insurance.Channel.ListUpdated";
   static final String BROADCAST_CLAIM_LISTUPDATED = "Insurance.Claim.ListUpdated";
   static final String BROADCAST_INVITE_LISTUPDATED = "Insurance.Invite.ListUpdated";
   static final String BROADCAST_MESSAGE_LISTUPDATED = "Insurance.Message.ListUpdated";
   static final String BROADCAST_FORM_LISTUPDATED = "Insurance.Form.ListUpdated";
   static final String BROADCAST_ORGANIZATION_DATA_FETCHED = "Insurance.Organization.dataFetched";

   static const Color drawing_colorBlack = Colors.black;
   static final Color drawing_colorBlue = Colors.blue;
   static final Color drawing_colorRed = Colors.red;
   static final Color drawing_colorGreen = Colors.green;
   static final Color drawing_colorYellow = Colors.yellow;

   static final int DRAWING_STROKE_WIDTH_1 = 10;
   static final int DRAWING_STROKE_WIDTH_2 = 20;
   static final int DRAWING_STROKE_WIDTH_3 = 30;
   static final int DRAWING_STROKE_WIDTH_4 = 40;
   static final int DRAWING_STROKE_WIDTH_5 = 50;

   static final int DRAWING_TYPE_PENCIL = 1111;
   static final int DRAWING_TYPE_ERASER = 2222;
   static final int DRAWING_TYPE_LINE = 3333;
   static final int DRAWING_TYPE_LINE_ARROW = 4444;
   static final int DRAWING_TYPE_RECTANGLE = 5555;
   static final int DRAWING_TYPE_RECTANGLE_FILLED = 6666;
   static final int DRAWING_TYPE_CIRCLE = 7777;
   static final int DRAWING_TYPE_CIRCLE_FILLED = 8888;
   static final int DRAWING_TYPE_ZOOMING = 9999;
}