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
        socket.emitPlayEvent(myLetter, xPos, yPos)
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
          roomData.boxes[yPos][xPos].replaceAll('empty', ''),
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

  /// checking for updates
  void checkForUpdates() {
    print('checking for turns');
    socket.addUpdateListener((data) {
      print('turn recieved ');
      if (mounted) {
        setState(() {
          roomData = RoomData.extractFromMap(data);
        });
      }
    });
  }

  /// Returns the letter of the user
  void getMyLetter(RoomData roomData) {
    if (roomData.players['X'] == socket.getId()) {
      myLetter = 'X';
    } else {
      myLetter = 'O';
    }
  }

  /// Navigates to the result page if the game is over
  void checkGameState(RoomData roomData) {
    if (roomData.gameOver) {
      String gameState = roomData.winningLetter == null
          ? 'draw'
          : roomData.winningLetter == myLetter
              ? 'win'
              : 'lose';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
          context,
          '/result',
          arguments: gameState,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // extracting the passed arguments(information of the room) from the context
    if (roomData == null) {
      roomData = ModalRoute.of(context)!.settings.arguments as RoomData;
      getMyLetter(roomData);
    }

    checkForUpdates();
    checkGameState(roomData);

    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenSize.height / 10,
            ),
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
    );
  }
}
