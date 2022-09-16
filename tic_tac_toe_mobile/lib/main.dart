import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe_mobile/services/socketio.dart';
import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SocketExporter();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Tic Tac Toe',
      routes: routes,
    );
  }
}
