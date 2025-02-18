import 'package:flutter/material.dart';
import 'views/main_game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yahtzee',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[700],
          elevation: 0,
        ),
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Yahtzee Game', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: MainGame(),
      ),
    );
  }
}
