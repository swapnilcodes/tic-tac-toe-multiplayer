/// This file deals with creation destruction and management of the modal component used in various screens of the app

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tic_tac_toe_mobile/common/styles.dart';
import '../common/colors.dart';

class Modal {
  var context;

  Modal(BuildContext context, String text) {
    this.context = context;
    showModalBottomSheet<void>(
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: appBackgroundColor,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Text(
                  text,
                  style: generateTextStyle(25),
                ),
                const SizedBox(
                  height: 30,
                ),
                SpinKitCircle(
                  color: secondaryBackgroundColor,
                  size: 40,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void close() {
    Navigator.pop(context);
  }
}
