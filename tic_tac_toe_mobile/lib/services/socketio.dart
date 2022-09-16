import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ListenableEvents { joined_room, error, turn, game_over }

enum EmmitableEvents { join_room, play, create_room, leave_room }

extension ToString on Enum {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

/// This class creates a modal for the socket io functions that will be used in all the screens.
class Socket {
  // main socket object
  late IO.Socket socket;

  final String backendUrl = 'http://192.168.29.79:5000';

  /// Constructor, initializes the socket object
  Socket() {
    this.socket = IO.io(backendUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
  }

  void connect() {
    socket.connect();
  }

  void addConnectionListener(void onConnection(dynamic)) {
    socket.onConnect(onConnection);
  }

  void addConnectionErrorListener(void onConnectionError(dynamic)) {
    socket.onConnectError(onConnectionError);
  }

  void addJoinedRoomListener(void onJoinedRoom(dynamic)) {
    socket.on(ListenableEvents.joined_room.toShortString(), onJoinedRoom);
  }

  void addErrorListener(void onError(dynamic)) {
    socket.on(ListenableEvents.error.toShortString(), onError);
  }

  void addTurnListener(void onTurn(dynamic)) {
    socket.on(ListenableEvents.turn.toShortString(), onTurn);
  }

  void addGameOverListener(void onGameOver(dynamic)) {
    socket.on(ListenableEvents.game_over.toShortString(), onGameOver);
  }

  void emitJoinRoomEvent(String roomId) {
    socket.emit(EmmitableEvents.join_room.toShortString(), roomId);
  }

  void emitPlayEvent(String letter, int xPosition, int yPosition) {
    print(letter);
    Map arguments = {
      'letter': letter,
      'xPosition': xPosition,
      'yPosition': yPosition,
    };
    socket.emit(EmmitableEvents.play.toShortString(), arguments);
  }

  void emitLeaveRoomEvent() {
    socket.emit(EmmitableEvents.leave_room.toShortString());
  }

  void emitCreateRoomEvent() {
    socket.emit(EmmitableEvents.create_room.toShortString());
  }
}

/// This class makes a single [Socket] class object available for global use.
class SocketExporter {
  static late Socket socket = new Socket();

  SocketExporter() {
    socket.connect();
  }

  static Socket getSocket() {
    return socket;
  }
}
