import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/utils/api.dart';

bool isLoading = false;

class NewGameAI extends StatefulWidget {
  final String aiOpponent;
  const NewGameAI({super.key, required this.aiOpponent});

  @override
  State<NewGameAI> createState() => _NewGameAIState();
}

class _NewGameAIState extends State<NewGameAI> {
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

  Map<int, String> myShips = {};
  List<int> selectedIndexList = [];
  late Map<int, String> moveIndex;

  @override
  void initState() {
    super.initState();
    moveIndex = moves.map((k, v) => MapEntry(v, k));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Your Ships'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              ),
              itemCount: 36,
              itemBuilder: (context, index) {
                bool isSelected = selectedIndexList.contains(index);
                bool isInactive = _inActiveList.contains(index);

                return GestureDetector(
                  onTap: () {
                    if (!isInactive) {
                      setState(() {
                        if (isSelected) {
                          myShips.remove(index);
                          selectedIndexList.remove(index);
                        } else if (myShips.length < 5) {
                          myShips[index] = moveIndex[index]!;
                          selectedIndexList.add(index);
                        }
                      });
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isInactive
                          ? Colors.grey[300]
                          : isSelected
                              ? Colors.indigo
                              : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.5),
                                blurRadius: 6,
                                offset: const Offset(2, 2),
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: isInactive
                          ? Text(
                              labels[index] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            )
                          : isSelected
                              ? const Icon(Icons.directions_boat,
                                  color: Colors.white)
                              : const SizedBox.shrink(),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (selectedIndexList.length == 5) {
                  _addNewGame(selectedIndexList);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select exactly 5 ships!',
                        style: TextStyle(color: Colors.white),
                      ),
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

  Future<void> _addNewGame(List<int> activeList) async {
    try {
      // Convert selected indices to coordinates
      List<String> ships = activeList.map((index) => moveIndex[index]!).toList();

      final token = await SessionManager.getSessionToken();
      Map<String, dynamic> requestBody = {'ships': ships};

      if (widget.aiOpponent.isNotEmpty) {
        requestBody["ai"] = widget.aiOpponent;
      }

      String data = jsonEncode(requestBody);

      setState(() {
        isLoading = true;
      });

      final response = await ApiHelper.callApi('/games', data, token: token);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ships placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error placing ships. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
