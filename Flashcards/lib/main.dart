import 'package:flutter/material.dart';
import 'views/deck_list_page.dart';
import '../utils/json_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final JSONLoader loader = JSONLoader();
  await loader.loadInitialData();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeckListPage(),
    );
  }
}
