import 'package:flutter/material.dart';
import 'package:tic_tac_toe_mobile/common/colors.dart';
import 'package:tic_tac_toe_mobile/common/styles.dart';
import 'package:tic_tac_toe_mobile/services/socketio.dart';
import '../models/room_data.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final Socket socket = SocketExporter.getSocket();

  var roomData = null;
  var boxes;
  var myLetter = null;

  /// Returns a single clickable box from the tic tac toe grid
  Widget getBoxWidget(int xPos, int yPos) {
    Widget container = InkWell(
      onTap: () => {
        print('clicked box at $xPos $yPos'),
        socket.emitPlayEvent('O', xPos, yPos)
      },
      child: Container(
        width: 90,
        height: 90,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: yPos != 2
                ? BorderSide(color: textColor, width: 3)
                : BorderSide.none,
            right: xPos == 0
                ? BorderSide(color: textColor, width: 3)
                : BorderSide.none,
            left: xPos == 2
                ? BorderSide(color: textColor, width: 3)
                : BorderSide.none,
          ),
        ),
        child: Text(
          // the box contains "empty" for specification if its empty, we dont want that in the ui
          roomData.boxes[xPos][yPos].replaceAll('empty', ''),
          style: generateTextStyle(30),
        ),
      ),
    );
    return container;
  }

  /// Returns a row containing 3 boxes recieved from the [getBoxWidget] method
  Widget getRow(int pos) {
    List<Widget> boxesList = [];
    for (int boxNumber = 0; boxNumber < 3; boxNumber++) {
      boxesList.add(getBoxWidget(boxNumber, pos));
    }
    return Row(
      children: boxesList,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  /// This function binds all the rows recieved from the [getRow] method and forms a grid.
  /// This function is Used directly in the main build.
  Widget getGrid() {
    List<Widget> rows = [];
    for (int i = 0; i < 3; i++) {
      rows.add(getRow(i));
    }
    return Column(
      children: rows,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  /// checking for turn
  void checkForTurns() {
    print('checking for turns');
    socket.addTurnListener((data) {
      print('turn recieved ');

      setState(() {
        roomData = RoomData.extractFromMap(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // extracting the passed arguments(information of the room) from the context
    if (roomData == null) {
      roomData = ModalRoute.of(context)!.settings.arguments as RoomData;
    }

    checkForTurns();
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          margin: EdgeInsets.only(top: screenSize.height / 9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'TIC-TAC-TOE',
                style: generateTextStyle(40),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenSize.height / 10,
              ),
              getGrid(),
              SizedBox(
                height: screenSize.height / 9,
              ),
              Text(
                "${roomData.turn}'s turn",
                style: generateTextStyle(30),
              )
            ],
          ),
        ),
      ),
    );
  }
}
