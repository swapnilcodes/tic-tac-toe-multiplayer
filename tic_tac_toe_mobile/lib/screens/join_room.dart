import 'package:flutter/material.dart';
import 'package:tic_tac_toe_mobile/common/colors.dart';
import 'package:tic_tac_toe_mobile/common/styles.dart';
import 'package:tic_tac_toe_mobile/components/button.dart';
import 'package:tic_tac_toe_mobile/models/room_data.dart';
import '../services/socketio.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({Key? key}) : super(key: key);

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  String roomId = '';

  final Socket socket = SocketExporter.getSocket();

  void joinRoom() {
    socket.emitJoinRoomEvent(
      roomId,
    );

    // once joined the room navigating to the game screen.
    socket.addJoinedRoomListener((data) {
      print(data);
      Navigator.pushReplacementNamed(
        context,
        '/game',
        arguments: RoomData.extractFromMap(data['roomData']),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: screenSize.height / 8),
          width: screenSize.width,
          height: screenSize.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Join A Room",
                style: generateTextStyle(35),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenSize.height / 7,
              ),
              Container(
                width: screenSize.width / 1.5,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0)),
                    ),
                    hintText: 'Enter the room code',
                    fillColor: secondaryBackgroundColor,
                    filled: true,
                  ),
                  style: generateTextStyle(17),
                  onChanged: (value) => setState(() {
                    roomId = value;
                  }),
                ),
              ),
              SizedBox(
                height: screenSize.height / 10,
              ),
              AppButton(onTap: () => joinRoom(), text: "Join Room"),
              SizedBox(
                height: screenSize.height / 8,
              ),
              Text(
                "You are a faithful friend! paste the code your friend has sent to you & click join",
                style: generateTextStyle(20),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
