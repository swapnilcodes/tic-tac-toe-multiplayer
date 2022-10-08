import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_mobile/common/colors.dart';
import 'package:tic_tac_toe_mobile/common/styles.dart';
import 'package:tic_tac_toe_mobile/components/button.dart';
import 'package:tic_tac_toe_mobile/services/socketio.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final Socket socket = SocketExporter.getSocket();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final String state = ModalRoute.of(context)?.settings.arguments as String;

    Map<String, String> titles = {
      'win': 'You Won',
      'lose': 'You Lose',
      'draw': 'Its a Draw!',
    };

    Map<String, String> descriptions = {
      'win':
          'Winning in a tic-tac-toe match with your friend is a accomplishment, even though your life would still be shit.',
      'lose':
          'You cant win a tic-tac-toe match bruh! Go do some practice and play again you dumb!',
      'draw': "You're not playing with einstien, YOU NEED TO WIN!"
    };

    void goToHome() {
      socket.emitLeaveRoomEvent();

      Navigator.popAndPushNamed(
        context,
        '/',
      );
    }

    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: EdgeInsets.fromLTRB(30, screenSize.height / 10, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              titles[state]!,
              style: generateTextStyle(40),
            ),
            SizedBox(
              height: screenSize.height / 10,
            ),
            Text(
              descriptions[state]!,
              style: generateTextStyle(20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: screenSize.height / 10,
            ),
            AppButton(
              onTap: goToHome,
              text: 'Go Back to HOME',
            )
          ],
        ),
      ),
    );
  }
}
