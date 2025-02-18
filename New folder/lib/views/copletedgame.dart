import 'dart:convert';
import 'package:battleships/models/games.dart';
import 'package:battleships/utils/api.dart';
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/battlefieldpage.dart';
import 'package:flutter/material.dart';

bool isLoading = false;
List<Game> games = [];

class CompleteGames extends StatefulWidget {
  const CompleteGames({Key? key}) : super(key: key);

  @override
  State<CompleteGames> createState() => _CompleteGamesState();
}

class _CompleteGamesState extends State<CompleteGames> {
  bool isLoggedIn = false;
  List<Game> games = [];

  @override
  void initState() {
    super.initState();
    updateGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Games'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              updateGames();
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (games.isEmpty)
              ? const Center(
                  child: Text(
                    'No completed games to display!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    // Prepare game data
                    final game = games[index];
                    final gameID = game.id;
                    String gameMsg = '';
                    int gameStatus = game.status;
                    String gameStatusMsg = '';
                    int gameTurn = game.turn;
                    int gamePosition = game.position;

                    if (gameStatus == 0) {
                      gameMsg = 'Waiting for Opponent';
                      gameStatusMsg = 'Matchmaking';
                    } else if (gameStatus == 1) {
                      gameMsg = 'Player 1 Won';
                      gameStatusMsg = gamePosition == 2 ? 'You Lost' : 'You Won';
                    } else if (gameStatus == 2) {
                      gameMsg = 'Player 2 Won';
                      gameStatusMsg = gamePosition == 1 ? 'You Lost' : 'You Won';
                    } else if (gameStatus == 3) {
                      gameMsg = '${game.player1} vs ${game.player2}';
                      gameStatusMsg =
                          gameTurn == gamePosition ? 'Your Turn' : 'Opponent\'s Turn';
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: gameStatus == 1
                              ? Colors.green
                              : gameStatus == 2
                                  ? Colors.red
                                  : Colors.blue,
                          child: const Icon(Icons.videogame_asset,
                              color: Colors.white),
                        ),
                        title: Text(
                          '#$gameID $gameMsg',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(gameStatusMsg),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          if (game.status != 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlayBattle(game: game)),
                            ).then((value) => {updateGames()});
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> updateGames() async {
    try {
      final token = await SessionManager.getSessionToken();

      String data = jsonEncode(<String, String>{});

      setState(() {
        isLoading = true;
      });

      final response = await ApiHelper.callApiGet('/games', data, token: token);
      final jsonRes = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Parse games data
        List<Game> newGames = [];
        final jsonGames = jsonRes['games'];

        for (var i = 0; i < jsonGames.length; i++) {
          newGames.add(Game.fromJson(jsonGames[i]));
        }

        if (!mounted) return;

        setState(() {
          games = newGames;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch games')),
        );
      }
    } catch (e) {
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while fetching games')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
