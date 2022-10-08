import 'package:flutter/material.dart';
import 'package:tic_tac_toe_mobile/common/colors.dart';
import 'package:tic_tac_toe_mobile/common/styles.dart';
import 'package:tic_tac_toe_mobile/components/leave_button.dart';
import 'package:tic_tac_toe_mobile/models/room_data.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tic_tac_toe_mobile/services/socketio.dart';

class WaitingRoom extends StatefulWidget {
  const WaitingRoom({Key? key}) : super(key: key);

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  final Socket socket = SocketExporter.getSocket();

  late final RoomData roomData;

  /// Copies the roomId of the room to the clipboard
  void copyRoomId() {
    FlutterClipboard.copy(roomData.roomId).then(
      (value) => Fluttertoast.showToast(
        msg: 'Copied The room-id to clipboard',
      ),
    );
  }

  /// switches to game screen when recieves turn event from the server
  void addTurnListener() {
    socket.addUpdateListener((data) {
      print('recieved update');
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/game',
          arguments: RoomData.extractFromMap(data),
        );
      }
    });
  }

  /// emits the leave_room event and redirects to the home page
  void leaveRoom() {
    socket.emitLeaveRoomEvent();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    roomData = ModalRoute.of(context)!.settings.arguments as RoomData;

    addTurnListener();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        body: Container(
          width: screenSize.width,
          height: screenSize.height,
          margin: EdgeInsets.only(top: screenSize.height / 6),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ROOM',
                style: generateTextStyle(35),
              ),
              SizedBox(
                height: (screenSize.height / 12),
              ),
              Text(
                'Waiting for a player to JOIN!',
                style: generateTextStyle(22),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: (screenSize.height / 12),
              ),
              Container(
                color: secondaryBackgroundColor,
                width: 280,
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 220,
                      child: Center(
                        child: Text(
                          '${roomData.roomId}',
                          style: generateTextStyle(17),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 3,
                      color: textColor,
                    ),
                    IconButton(
                      onPressed: () => copyRoomId(),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => appBackgroundColor,
                        ),
                      ),
                      icon: Icon(
                        Icons.copy,
                        color: textColor,
                      ),
                      splashRadius: 25,
                      splashColor: textColor,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height / 9,
              ),
              Text(
                'You can copy and send this code to your friends even though they wont join ',
                style: generateTextStyle(18),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              LeaveButton(
                onTap: leaveRoom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
