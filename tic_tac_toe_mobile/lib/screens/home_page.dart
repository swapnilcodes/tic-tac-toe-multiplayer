/// Home page of the application

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_mobile/common/styles.dart';
import 'package:tic_tac_toe_mobile/components/button.dart';
import 'package:tic_tac_toe_mobile/common/colors.dart';
import 'package:tic_tac_toe_mobile/components/modal.dart';
import 'package:tic_tac_toe_mobile/models/room_data.dart';
import 'package:tic_tac_toe_mobile/services/socketio.dart';

class HomePage extends StatelessWidget {
  final Socket socket = SocketExporter.getSocket();

  /// creates a room and redirects to the [WaitingRoom] page
  void createRoom(BuildContext context) {
    // opening a modal for giving feedback to the user
    Modal modal = new Modal(
      context,
      "Creating Room",
    );

    socket.emitCreateRoomEvent();

    socket.addJoinedRoomListener((data) {
      modal.close();

      Navigator.pushReplacementNamed(
        context,
        '/waitingRoom',
        arguments: RoomData.extractFromMap(data['roomData']),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: Container(
        margin: EdgeInsets.only(top: screenSize.height / 8),
        width: screenSize.width,
        height: screenSize.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "TIC-TAC-TOE",
              style: generateTextStyle(40),
            ),
            SizedBox(
              height: screenSize.height / 20,
            ),
            Text(
              "MULTIPLAYER",
              style: generateTextStyle(30),
            ),
            SizedBox(height: screenSize.height / 10),
            AppButton(
              onTap: () => createRoom(context),
              text: 'Create Room',
            ),
            SizedBox(height: screenSize.height / 20),
            AppButton(
              onTap: () => Navigator.pushNamed(context, '/joinRoom'),
              text: 'Join Room',
            ),
            SizedBox(height: screenSize.height / 20),
            AppButton(
              onTap: () => Navigator.pushNamed(context, '/about'),
              text: 'About the Developer',
            ),
          ],
        ),
      ),
    );
  }
}
