const e = require('cors');
const { Socket } = require('socket.io');
const xid = require('xid');
const { generateBoxes, checkWin, boxesRemaning } = require('./Game.js');

let rooms = []; // array of rooms

/**
 * Creates a room and adds the player who created the room
 * @param {Socket} socket data of the player who created the room
 */
function handleCreate(socket) {
  let roomId = xid.generateId(); // generates a random room id

  console.log(`roomId: ${roomId}`);

  let boxes = generateBoxes();

  let players = {
    X: socket.id,
    O: null,
  }; // object of players

  let turn = null;

  let room = { roomId, boxes, players, turn }; // binding up all data to form a room

  rooms.push(room); // pushing the room to the main object

  socket.join(roomId); // joining socket io room

  socket.emit('joined_room', { roomData: room }); // sending the room data to the user
}

/**
 * This function returns the room which contains the socket connection provided
 * @param {Socket} socket accepts Socket object
 * @returns the room which contains the socket connection provided
 */
function getRoomOfAPlayer(socket) {
  const room = rooms.filter(
    (value) => value.players.X === socket.id || value.players.O == socket.id
  )[0];
  return room;
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
    console.log('invalid room id');
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
    console.log('joined the room');
    // starting the game
    emitTurn(roomId, io);
  } else {
    console.log('room is full');
    socket.emit('error', 'room is full!');
  }
}

/**
 * This functions emits turn event to the particular room
 * @param {String} roomId id of the room
 * @param {*} io accepts IO Object
 */
function emitTurn(roomId, io) {
  console.log('emitting turn');
  console.log(`box here ${getRoomFromRoomId(roomId).boxes[1][1]}`);
  io.to(roomId).emit('turn', getRoomFromRoomId(roomId));
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
  console.log(room);
  console.log(letter);
  if (room.turn !== letter) {
    console.log('not your turn!');
    socket.emit('error', 'not your turn!');
    return;
  }

  console.log(`row: ${boxes[yPosition]}`);

  if (room.boxes[yPosition][xPosition] != 'empty') {
    console.log('box already full!');
    socket.emit(
      'error',
      'box is already filled bro, dont think you are a hacker'
    );
    return;
  }
  // updating boxes object in the room
  room.boxes[yPosition][xPosition] = letter;
  console.log(
    `box ${getRoomFromRoomId(room.roomId).boxes[yPosition][xPosition]}`
  );
  replaceWithNewRoom(room);
  // checking for the winner
  let winningLetter = checkWin(room.roomId, room.boxes, io);

  if (winningLetter != null) {
    io.to(room.roomId).emit('game_over', { winner: letter }); // emitting the results if the game is overs
    removeRoom(room.roomId);
  } else {
    // checking for draws
    if (boxesRemaning(room.boxes)) {
      // continuing the game
      flipTurn(room.roomId);
      emitTurn(room.roomId, io);
    } else {
      // emitting draws
      io.to(room.roomId).emit('game_over', { winner: 'draw' });
      removeRoom(room.roomId);
    }
  }
}

/**
 * This function removes the room with the given roomId from the rooms object
 * @param {String} roomId id of the room
 */
function removeRoom(roomId) {
  rooms = rooms.filter((value) => value.roomId != roomId);
}

/**
 * This function gives the turn to the other player
 * @param {String} roomId id of the room
 */
function flipTurn(roomId) {
  let room = getRoomFromRoomId(roomId);
  if (room.turn === 'X') {
    room.turn = 'O';
  } else {
    room.turn = 'X';
  }

  replaceWithNewRoom(room);
}

/**
 * This function returns the room with the given roomID
 * @param {String} roomId id of the room
 * @returns room with the given roomId
 */
function getRoomFromRoomId(roomId) {
  return rooms.filter((value) => value.roomId === roomId)[0];
}

/**
 * This function replaces the room with the same id as the one provided in the arguments from the rooms array to the one provided in the arguments.
 * @param {Object} room
 */
function replaceWithNewRoom(room) {
  let newRooms = rooms.filter((value) => value.roomId != room.roomId);
  newRooms.push(room);
  rooms = newRooms;
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

  socket.leave(room.roomId);
}

function handleDisconnect(socket) {
  const room = rooms.filter(
    (value) => value.players.X === socket.id || value.players.O === socket.id
  )[0];
  if (room != null) {
    handleLeave(room.roomId, socket);
  }
}

module.exports = {
  handleCreate,
  handleJoin,
  handlePlay,
  handleLeave,
  handleDisconnect,
};
