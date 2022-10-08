/// This file contains the model for using the data of a room

class RoomData {
  late final String roomId;
  late List<dynamic> boxes;
  late final Map<String, dynamic> players;
  late dynamic turn;
  late dynamic winningLetter;
  late bool gameOver;

  RoomData(
    this.roomId,
    this.boxes,
    this.players,
    this.turn,
    this.winningLetter,
    this.gameOver,
  );

  /// Seperate Constructor so that we can directly pass the maps as the argument
  RoomData.extractFromMap(Map<String, dynamic> roomData) {
    print(roomData['players']);
    // making players as a seperate variable because socket io returns it as a _InternalLinkedHashMap and this class requires it as a Map
    Map<String, dynamic> players = {
      'X': roomData['players']['X'],
      'O': roomData['players']['O'],
    };
    this.roomId = roomData['roomId'];
    this.boxes = roomData['boxes'];
    this.players = players;
    this.turn = roomData['turn'];
    this.winningLetter = roomData['winningLetter'];
    this.gameOver = roomData['gameOver'];
  }
}
