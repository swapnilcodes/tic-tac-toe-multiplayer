/// This file contains the button widget used in most of pages in this application.

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_mobile/common/colors.dart';
import 'package:tic_tac_toe_mobile/common/fonts.dart';

class AppButton extends StatefulWidget {
  final Function onTap;
  final String text;
  const AppButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  double button_width = 310;
  double button_height = 70;

  /// Creates a animation by tweaking with the size of the button
  void animate() async {
    setState(() {
      button_width = 315;
      button_height = 72;
    });

    await Future.delayed(Duration(milliseconds: 150));
    setState(() {
      button_width = 310;
      button_height = 70;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        animate();
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: button_width,
        height: button_height,
        decoration: BoxDecoration(
          color: secondaryBackgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: TextStyle(
            color: textColor,
            fontFamily: primaryFont,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
