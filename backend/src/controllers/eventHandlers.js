const { generateBoxes, checkWin, boxesRemaning } = require('./Game.js');
const xid = require('xid');
const {
  addRoom,
  getRoomOfAPlayer,
  emitUpdate,
  removeRoom,
  flipTurn,
  getRoomFromRoomId,
  replaceWithNewRoom,
} = require('./Rooms.js');

/**
 * Creates a room and adds the player who created the room
 * @param {Socket} socket data of the player who created the room
 */
function handleCreate(socket) {
  let roomId = xid.generateId(); // generates a random room id

  let boxes = generateBoxes();

  let players = {
    X: socket.id,
    O: null,
  }; // object of players

  let turn = null;

  let winningLetter = null;

  let gameOver = false;

  let room = { roomId, boxes, players, turn, winningLetter, gameOver }; // binding up all data to form a room

  addRoom(room); // pushing the room to the main object

  socket.join(roomId); // joining socket io room

  socket.emit('joined_room', { roomData: room }); // sending the room data to the user
}

/**
 * handles room join request
 * @param {Socket} socket accepts Socket object
 * @param {String} roomId id of the room
 * @param {*} io accepts Io object
 */
function handleJoin(socket, roomId, io) {
  let room = getRoomFromRoomId(roomId);

  // handling invalid roomId
  if (room == null) {
    socket.emit('error', 'invalid room id');
    return;
  }

  if (room.players.X === null) {
    room.players.X = socket.id; // setting the player to X
    socket.join(roomId);
    socket.emit('joined_room', { roomData: room }); // sending the room data to the user
  } else if (room.players.O === null) {
    room.players.O = socket.id; // setting the player to O

    // updating the turn to start the game
    room.turn = 'X';

    replaceWithNewRoom(room);

    // joining the socket io room
    socket.join(roomId);
    socket.emit('joined_room', { roomData: room });

    // starting the game
    emitUpdate(roomId, io);
  } else {
    socket.emit('error', 'room is full!');
  }
}

/**
 * This function handles play event in socket io
 * @param {*} socket socket object
 * @param {String} roomId
 * @param {*} io io object
 * @param {String} letter letter to be filled in the box, accepts String value
 * @param {*} box the box in which the letter should be filled, needs to be in the format: {positionX: number, positionY: number}
 */
function handlePlay(args) {
  const { socket, io, letter, xPosition, yPosition } = args;

  let room = getRoomOfAPlayer(socket);

  if (room === null) {
    socket.emit('error', 'Please join a room before!');
  }

  if (room.turn !== letter) {
    socket.emit('error', 'not your turn!');
    return;
  }

  if (room.boxes[yPosition][xPosition] != 'empty') {
    socket.emit(
      'error',
      'box is already filled bro, dont think you are a hacker'
    );
    return;
  }
  // updating boxes object in the room
  room.boxes[yPosition][xPosition] = letter;

  replaceWithNewRoom(room);

  // checking for the winner
  let winningLetter = checkWin(room.boxes);
  room.winningLetter = winningLetter;
  if (winningLetter != null) {
    room.gameOver = true;
  }

  // checking for draws
  if (!boxesRemaning(room.boxes)) {
    room.gameOver = true;
  }

  flipTurn(room.roomId);

  emitUpdate(room.roomId, io);
}

/**
 * This function handles leaveRoom request sent by the user
 * @param {String} roomId
 * @param {*} socket
 */
function handleLeave(socket) {
  let room = getRoomOfAPlayer(socket);

  if (room.players.X === socket.id) {
    if (room.players.O === null) {
      removeRoom(room.roomId);
    } else {
      room.players.X = null;
      socket.to(room.roomId).emit('error', 'Other player left the game');
    }
  } else {
    if (room.players.O === socket.id) {
      if (room.players.X === null) {
        removeRoom(room.roomId);
      } else {
        room.players.O = null;
        socket.to(room.roomId).emit('error', 'Other player left the game');
      }
    }
  }

  if (socket.leave) {
    socket.leave(room.roomId);
  }
}

/**
 * This function handles socket io dissconnection
 * @param {Socket} socket
 */
function handleDisconnect(socket) {
  const room = getRoomOfAPlayer(socket);
  if (room) {
    handleLeave(socket);
  }
}

module.exports = {
  handleCreate,
  handleJoin,
  handlePlay,
  handleLeave,
  handleDisconnect,
};
