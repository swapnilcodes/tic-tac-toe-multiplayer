import 'package:flutter/cupertino.dart';
import 'package:tic_tac_toe_mobile/screens/about.dart';
import 'package:tic_tac_toe_mobile/screens/game.dart';
import 'package:tic_tac_toe_mobile/screens/join_room.dart';
import 'package:tic_tac_toe_mobile/screens/home_page.dart';
import 'package:tic_tac_toe_mobile/screens/waiting_room.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (BuildContext context) => HomePage(),
  '/about': (BuildContext context) => About(),
  '/joinRoom': (BuildContext context) => JoinRoom(),
  '/waitingRoom': (BuildContext context) => WaitingRoom(),
  '/game': (BuildContext context) => Game(),
};
