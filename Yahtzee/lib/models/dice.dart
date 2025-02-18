import 'dart:math';

class Dice {
  final List<int> _values;
  final List<bool> _held;
  final int numberOfDice;
  final Random random = Random();

  Dice(this.numberOfDice) 
      : _values = List.filled(numberOfDice, 0),
        _held = List.filled(numberOfDice, false);

  List<int> get values => List.unmodifiable(_values);
  bool isHeld(int index) => _held[index];
  
  void roll() {
    for (int i = 0; i < numberOfDice; i++) {
      if (!_held[i]) {
        _values[i] = random.nextInt(6) + 1;
      }
    }
  }

  void toggleHold(int index) {
    _held[index] = !_held[index];
  }

  void clear() {
    for (int i = 0; i < numberOfDice; i++) {
      _held[i] = false;
      _values[i] = 0;
    }
  }
}
