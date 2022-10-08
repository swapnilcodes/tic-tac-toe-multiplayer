import 'package:flutter/material.dart';
import 'package:tic_tac_toe_mobile/common/colors.dart';
import 'package:tic_tac_toe_mobile/common/styles.dart';
import 'package:tic_tac_toe_mobile/components/button.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  final myInfo =
      "This game is made by a nerdy kid reffered as Swapnil Deshmane, who isnt an associate chintu and is not in anyways related to whitehat jr in anyways. This game is not a real world project and is made for content creation purposes.";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height / 7,
            ),
            Text(
              "About The Developer",
              style: generateTextStyle(30),
            ),
            SizedBox(
              height: size.height / 12,
            ),
            Text(
              myInfo,
              style: generateTextStyle(17),
            ),
            AppButton(
              onTap: () => Navigator.pop(context),
              text: "Go Back To Home",
            )
          ],
        ),
      ),
    );
  }
}
