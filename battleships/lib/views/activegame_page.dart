import 'dart:convert';

import 'package:battleships/controllers/homepage.dart';
import 'package:battleships/models/games.dart';
import 'package:battleships/utils/api.dart';
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/battlefieldpage.dart';
import 'package:flutter/material.dart';

bool isLoading = false;
List<Game> games = [];

class OnGames extends StatefulWidget {
  final HomePageController controller;

  const OnGames({Key? key, required this.controller}) : super(key: key);

  @override
  State<OnGames> createState() => _OnGamesState(controller: controller);
}

class _OnGamesState extends State<OnGames> {
  HomePageController controller;

  _OnGamesState({required this.controller}) {
    controller.updateGames = updateGames;
  }

  bool isLoggedIn = false;
  List<Game> games = [];

  @override
  void initState() {
    super.initState();
    controller.ctx = context;
    updateGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Games"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              updateGames();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : games.isEmpty
              ? const Center(
                  child: Text(
                    "No active games available.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    final gameID = game.id;
                    final gameStatus = game.status;
                    final gameTurn = game.turn;
                    final gamePosition = game.position;

                    String gameMsg = '';
                    String battleStatusMsg = '';
                    IconData? gameIcon;

                    if (gameStatus == 0) {
                      gameMsg = 'Waiting for Opponent';
                      battleStatusMsg = 'Matchmaking';
                      gameIcon = Icons.hourglass_empty;
                    } else if (gameStatus == 1) {
                      gameMsg = 'Player 1 Won';
                      battleStatusMsg =
                          gamePosition == 2 ? 'You Lost :(' : 'You Won :)';
                      gameIcon = gamePosition == 2
                          ? Icons.close
                          : Icons.emoji_events;
                    } else if (gameStatus == 2) {
                      gameMsg = 'Player 2 Won';
                      battleStatusMsg =
                          gamePosition == 1 ? 'You Lost :(' : 'You Won :)';
                      gameIcon = gamePosition == 1
                          ? Icons.close
                          : Icons.emoji_events;
                    } else if (gameStatus == 3) {
                      gameMsg =
                          '${game.player1} vs ${game.player2} (Game $gameID)';
                      battleStatusMsg =
                          gameTurn == gamePosition ? 'Your Turn' : "Opponent's Turn";
                      gameIcon = gameTurn == gamePosition
                          ? Icons.play_arrow
                          : Icons.pause_circle_filled;
                    }

                    return (gameStatus == 0 || gameStatus == 3)
                        ? Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Dismissible(
                              key: Key('${game.id}'),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20.0),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) {
                                _deleteGame(context, game.id, index);
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: gameStatus == 1
                                      ? Colors.green
                                      : gameStatus == 2
                                          ? Colors.red
                                          : Colors.blue,
                                  child: Icon(
                                    gameIcon,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  gameMsg,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  battleStatusMsg,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: gameTurn == gamePosition
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  if (gameStatus != 0 &&
                                      (gameTurn == gamePosition)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PlayBattle(game: game),
                                      ),
                                    ).then((value) => {updateGames()});
                                  }
                                },
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
    );
  }

Future<void> updateGames() async {
  try {
    final token = await SessionManager.getSessionToken();
    final response = await ApiHelper.callApiGet('/games', jsonEncode({}), token: token);

    if (!mounted) return; // Exit if the widget is no longer mounted

    setState(() {
      isLoading = true;
    });

    if (response.statusCode == 200) {
      final jsonRes = jsonDecode(response.body);
      List<Game> newGames = [];

      for (var game in jsonRes['games']) {
        newGames.add(Game.fromJson(game));
      }

      if (!mounted) return; // Exit if the widget is no longer mounted
      setState(() {
        games = newGames;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch active games.')),
        );
      }
    }
  } catch (e) {
    print('An error occurred: $e');
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}



Future<void> _deleteGame(BuildContext context, int id, int index) async {
  try {
    final token = await SessionManager.getSessionToken();
    final response =
        await ApiHelper.callApiDelete('/games/$id', jsonEncode({}), token: token);

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          games.removeAt(index);
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Game deleted successfully.')),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete the game.')),
        );
      }
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}
}
