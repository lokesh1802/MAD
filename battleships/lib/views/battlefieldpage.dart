import 'dart:convert';
import 'package:battleships/controllers/homepage.dart';
import 'package:battleships/models/game_mode.dart';
import 'package:battleships/models/games.dart';
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/utils/api.dart';
import 'package:battleships/views/activegame_page.dart';
import 'package:flutter/material.dart';

late GameMode gameMode;
bool isLoading = true;
bool firstTimePlay = false;

class PlayBattle extends StatefulWidget {
  final Game game;
  

  const PlayBattle({Key? key, required this.game}) : super(key: key);

  @override
  State<PlayBattle> createState() => _PlayBattleState();
}

class _PlayBattleState extends State<PlayBattle> {
  int _selectedCellIndex = 0;

  final List<int> _inActiveList = [0, 1, 2, 3, 4, 5, 6, 12, 18, 24, 30];

  final Map<int, String> labels = {
    1: "1",
    2: "2",
    3: "3",
    4: "4",
    5: "5",
    6: "A",
    12: "B",
    18: "C",
    24: "D",
    30: "E",
  };

  final Map<String, int> moves = {
    "A1": 7,
    "A2": 8,
    "A3": 9,
    "A4": 10,
    "A5": 11,
    "B1": 13,
    "B2": 14,
    "B3": 15,
    "B4": 16,
    "B5": 17,
    "C1": 19,
    "C2": 20,
    "C3": 21,
    "C4": 22,
    "C5": 23,
    "D1": 25,
    "D2": 26,
    "D3": 27,
    "D4": 28,
    "D5": 29,
    "E1": 31,
    "E2": 32,
    "E3": 33,
    "E4": 34,
    "E5": 35,
  };

  late Map<int, String> moveIndex;

  @override
  void initState() {
    super.initState();
    moveIndex = moves.map((k, v) => MapEntry(v, k));
    _getGameMode(context, widget.game.id);

    if (widget.game.status == 3) {
      firstTimePlay = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(firstTimePlay ? 'Play Game' : 'Game History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _getGameMode(context, widget.game.id);
            },
          ),
        ],
        backgroundColor: Colors.indigo,
      ),
      body: isLoading || gameMode == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                    ),
                    itemCount: 36,
                    itemBuilder: (context, index) {
                      final isInactive = _inActiveList.contains(index);
                      final isSelected = _selectedCellIndex == index;

                      Color cellColor = Colors.white;
                      Widget cellIcon = const SizedBox.shrink();

                      if (gameMode.ships.contains(moveIndex[index])) {
                        cellColor = Colors.blue[300]!;
                        cellIcon = const Icon(Icons.directions_boat, color: Colors.white);
                      } else if (gameMode.wrecks.contains(moveIndex[index])) {
                        cellColor = Colors.blue[800]!;
                        cellIcon = const Icon(Icons.water, color: Colors.white);
                      } else if (gameMode.sunk.contains(moveIndex[index])) {
                        cellColor = Colors.green;
                        cellIcon = const Icon(Icons.check_circle, color: Colors.white);
                      } else if (gameMode.shots.contains(moveIndex[index])) {
                        cellColor = Colors.red[400]!;
                        cellIcon = const Icon(Icons.whatshot, color: Colors.white);
                      }

                      return GestureDetector(
                        onTap: () {
                          if (!isInactive &&
                              !gameMode.sunk.contains(moveIndex[index]) &&
                              !gameMode.shots.contains(moveIndex[index]) &&
                              gameMode.status == 3) {
                            setState(() {
                              _selectedCellIndex = index;
                            });
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: isInactive
                                ? Colors.grey[300]
                                : isSelected
                                    ? Colors.amber
                                    : cellColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.amber.withOpacity(0.5),
                                      blurRadius: 6,
                                      offset: const Offset(2, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Center(child: isInactive ? Text(labels[index] ?? '') : cellIcon),
                        ),
                      );
                    },
                  ),
                ),
                if (gameMode.status == 4 || gameMode.status == 5) // Game over conditions
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _resetGame();
                      },
                      child: const Text(
                        'Reset Game',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (gameMode.status == 3) // Active game status
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_selectedCellIndex != 0) {
                          _playShot(context, widget.game.id,
                              moveIndex[_selectedCellIndex]!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No shot selected!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Future<void> _getGameMode(BuildContext context, int id,
      {bool showLoading = true}) async {
    try {
      final token = await SessionManager.getSessionToken();

      if (showLoading) {
        setState(() {
          isLoading = true;
        });
      }

      final response =
          await ApiHelper.callApiGet('/games/$id', jsonEncode({}), token: token);

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);
        if (jsonRes['status'] == 2 && firstTimePlay) {
          _showDialog('Sorry', 'You lost!', () {
            firstTimePlay = false;
            Navigator.pop(context);
          });
        }

        setState(() {
          gameMode = GameMode.fromJson(jsonRes);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch game data.')),
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _playShot(BuildContext context, int id, String move) async {
    setState(() {
      _selectedCellIndex = 0; // Reset selection
    });

    try {
      final token = await SessionManager.getSessionToken();
      final response = await ApiHelper.callApiPut(
          '/games/$id', jsonEncode({'shot': move}), token: token);

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);
        String msg = jsonRes['sunk_ship']
            ? 'Enemy ship sunk!'
            : 'Missed the target.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );

        if (jsonRes['won']) {
          _showDialog('Congratulations', 'You won!', () {
            Navigator.pop(context);
          });
        }

        _getGameMode(context, id, showLoading: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to make a move.')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _resetGame() {
    setState(() {
      isLoading = true;
      _selectedCellIndex = 0;
    });
    _getGameMode(context, widget.game.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Game has been reset!'),
        backgroundColor: Colors.green,
      ),
    );
  }


void _showDialog(String title, String message, VoidCallback callback) {
  // Use `showDialog` with a builder to create the dialog
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog using the dialog's context
            Navigator.of(dialogContext).pop();

            // Execute any additional callback logic
            callback();

            // Navigate to OnGames after a slight delay
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnGames(controller: HomePageController()),
                  ),
                  (route) => false, // Clears all previous routes
                );
              }
            });
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}







}