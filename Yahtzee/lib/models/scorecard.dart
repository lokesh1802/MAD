enum ScoreCategory {
  ones,
  twos,
  threes,
  fours,
  fives,
  sixes,
  threeOfAKind,
  fourOfAKind,
  fullHouse,
  smallStraight,
  largeStraight,
  yahtzee,
  chance,
}

class ScoreCard {
  final Map<ScoreCategory, int?> _scores = {};

  ScoreCard() {
    for (var category in ScoreCategory.values) {
      _scores[category] = null;
    }
  }

  void registerScore(ScoreCategory category, List<int> dice) {
    if (_scores[category] != null) {
      throw Exception("Category already scored.");
    }
    _scores[category] = _calculateScore(category, dice);
  }

  int? operator [](ScoreCategory category) => _scores[category];

  bool get completed => _scores.values.every((score) => score != null);

  int get total => _scores.values.where((score) => score != null).fold(0, (acc, score) => acc + score!);

  void clear() {
    for (var category in ScoreCategory.values) {
      _scores[category] = null;
    }
  }

  int _calculateScore(ScoreCategory category, List<int> dice) {
    switch (category) {
      case ScoreCategory.ones:
        return _sumDice(dice, 1);
      case ScoreCategory.twos:
        return _sumDice(dice, 2);
      case ScoreCategory.threes:
        return _sumDice(dice, 3);
      case ScoreCategory.fours:
        return _sumDice(dice, 4);
      case ScoreCategory.fives:
        return _sumDice(dice, 5);
      case ScoreCategory.sixes:
        return _sumDice(dice, 6);
      case ScoreCategory.threeOfAKind:
        return _sumIfNOfAKind(dice, 3);
      case ScoreCategory.fourOfAKind:
        return _sumIfNOfAKind(dice, 4);
      case ScoreCategory.fullHouse:
        return _isFullHouse(dice) ? 25 : 0;
      case ScoreCategory.smallStraight:
        return _isSmallStraight(dice) ? 30 : 0;
      case ScoreCategory.largeStraight:
        return _isLargeStraight(dice) ? 40 : 0;
      case ScoreCategory.yahtzee:
        return _isYahtzee(dice) ? 50 : 0;
      case ScoreCategory.chance:
        return dice.reduce((a, b) => a + b);
      default:
        return 0;
    }
  }

  int _sumDice(List<int> dice, int value) {
    return dice.where((die) => die == value).fold(0, (sum, die) => sum + die);
  }

  int _sumIfNOfAKind(List<int> dice, int n) {
    for (var die in dice) {
      if (dice.where((d) => d == die).length >= n) {
        return dice.reduce((a, b) => a + b);
      }
    }
    return 0;
  }

  bool _isFullHouse(List<int> dice) {
    var counts = _getCounts(dice);
    return counts.contains(3) && counts.contains(2);
  }

  bool _isSmallStraight(List<int> dice) {
    var uniqueSortedDice = dice.toSet().toList()..sort();
    return _checkSubsequence(uniqueSortedDice, [1, 2, 3, 4]) ||
           _checkSubsequence(uniqueSortedDice, [2, 3, 4, 5]) ||
           _checkSubsequence(uniqueSortedDice, [3, 4, 5, 6]);
  }

  bool _isLargeStraight(List<int> dice) {
    var uniqueSortedDice = dice.toSet().toList()..sort();
    return _checkSubsequence(uniqueSortedDice, [1, 2, 3, 4, 5]) ||
           _checkSubsequence(uniqueSortedDice, [2, 3, 4, 5, 6]);
  }

  bool _isYahtzee(List<int> dice) {
    return dice.toSet().length == 1;
  }

  bool _checkSubsequence(List<int> dice, List<int> subsequence) {
    return subsequence.every((value) => dice.contains(value));
  }

  List<int> _getCounts(List<int> dice) {
    var counts = List.filled(6, 0);
    for (var die in dice) {
      counts[die - 1]++;
    }
    return counts;
  }
}
