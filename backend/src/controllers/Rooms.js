let rooms = []; // array of rooms

/**
 * This function adds the given room to the rooms object
 * @param {Object} room
 */
function addRoom(room) {
  rooms.push(room);
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
 * This functions emits update event to the particular room
 * @param {String} roomId id of the room
 * @param {*} io accepts IO Object
 */
function emitUpdate(roomId, io) {
  io.to(roomId).emit('update', getRoomFromRoomId(roomId));
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

module.exports = {
  addRoom,
  getRoomOfAPlayer,
  emitUpdate,
  removeRoom,
  flipTurn,
  getRoomFromRoomId,
  replaceWithNewRoom,
};
