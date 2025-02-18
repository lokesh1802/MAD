import 'package:battleships/controllers/homepage.dart';
import 'package:battleships/models/games.dart';
import 'package:flutter/material.dart';
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/activegame_page.dart';
import 'package:battleships/views/loginpage.dart';
import 'package:battleships/views/copletedgame.dart';
import 'package:battleships/views/newgame.dart';

bool isLoading = false;
Game gameDemo = Game(
    id: 4, player1: 'test1', player2: 'test2', position: 1, status: 1, turn: 1);

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FirstPage> {
  int _selectedIndex = 0;
  String sessionUser = '';

  final HomePageController myController = HomePageController();

  void _changeSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    final user = await SessionManager.getSessionUser();
    if (mounted) {
      setState(() {
        sessionUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Battleships"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              myController.updateGames();
            },
          )
        ],
      ),
      drawer: MyDrawer(
        sessionUser: sessionUser,
        selected: _selectedIndex,
        changeSelection: _changeSelection,
        controller: myController,
      ),
      body: switch (_selectedIndex) {
        0 => OnGames(controller: myController),
        1 => const NewGameAI(aiOpponent: ''),
        2 => const NewGameAI(aiOpponent: 'random'),
        3 => CompleteGames(),
        _ => OnGames(controller: myController)
      },
    );
  }
}

class MyDrawer extends StatelessWidget {
  final String sessionUser;
  final int selected;
  final void Function(int index) changeSelection;
  final HomePageController controller;

  const MyDrawer({
    required this.sessionUser,
    required this.selected,
    required this.changeSelection,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF3A58F2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Battleships",
                  textAlign: TextAlign.center,
                  textScaleFactor: 2.0,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Logged in as $sessionUser",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                )
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.add,
            text: "New Game",
            isSelected: selected == 1,
            onTap: () {
              changeSelection(0);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewGameAI(aiOpponent: ''),
                ),
              ).then((value) => {controller.updateGames()});
            },
          ),
          _buildDrawerItem(
            icon: Icons.computer,
            text: "New Game (AI)",
            isSelected: selected == 2,
            onTap: () {
              changeSelection(0);
              Navigator.pop(context);
              _setAI(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.list,
            text: "Show completed games",
            isSelected: selected == 3,
            onTap: () {
              changeSelection(0);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompleteGames()),
              ).then((value) => {controller.updateGames()});
            },
          ),
          const Spacer(),
          _buildDrawerItem(
            icon: Icons.logout,
            text: "Logout",
            isSelected: selected == 4,
            onTap: () {
              _doLogout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.black),
      title: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }

  Future<void> _doLogout(BuildContext context) async {
    await SessionManager.clearSession();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _setAI(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select an AI Opponent',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildOptionItem('Random', context, 'random'),
                _buildOptionItem('Perfect', context, 'perfect'),
                _buildOptionItem('One Ship (A1)', context, 'oneship'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(
      String option, BuildContext context, String aiOpponent) {
    return ListTile(
      title: Text(option),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewGameAI(aiOpponent: aiOpponent),
          ),
        ).then((value) => {controller.updateGames()});
      },
    );
  }
}
