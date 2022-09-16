/// This file contains general style used for styling a text in the app.

import 'package:flutter/cupertino.dart';
import 'package:tic_tac_toe_mobile/common/colors.dart';
import 'package:tic_tac_toe_mobile/common/fonts.dart';

TextStyle generateTextStyle(double fontSize) {
  return TextStyle(
    color: textColor,
    fontFamily: primaryFont,
    fontSize: fontSize,
  );
}
