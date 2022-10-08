// imports
const { createServer } = require('http');
const { Server } = require('socket.io');
const {
  handleCreate,
  handleJoin,
  handlePlay,
  handleLeave,
  handleDisconnect,
} = require('./controllers/eventHandlers.js');

// configuring the server
const httpServer = createServer((req, res) => {
  res.write('hello bhai');
  res.end();
});
const PORT = 5000; // port number

// configuring socket io
const io = new Server(httpServer, {
  cors: { origin: '*' },
});

// handling socket io connections
io.on('connection', (socket) => {
  socket.on('create_room', () => handleCreate(socket));

  socket.on('join_room', (args) => handleJoin(socket, args.roomId, io));

  socket.on('play', (args) =>
    handlePlay({
      socket,
      io,
      letter: args.letter,
      xPosition: args.xPosition,
      yPosition: args.yPosition,
    })
  );

  socket.on('leave_room', () => handleLeave(socket));

  socket.on('disconnect', () => handleDisconnect(socket));
});

// starting the server
httpServer.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});
