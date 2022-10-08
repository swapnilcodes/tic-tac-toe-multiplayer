import 'package:flutter/material.dart';
import '../common/fonts.dart';

class LeaveButton extends StatefulWidget {
  final Function onTap;
  const LeaveButton({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LeaveButton> createState() => _LeaveButtonState();
}

class _LeaveButtonState extends State<LeaveButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => widget.onTap(),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith(
          (states) => Color.fromARGB(37, 255, 147, 143),
        ),
      ),
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.redAccent,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        child: Center(
          child: Text(
            "Leave Room",
            style: TextStyle(
              color: Colors.red,
              fontFamily: primaryFont,
            ),
          ),
        ),
      ),
    );
  }
}
