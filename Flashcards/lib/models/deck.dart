
class Deck {
  final int? id;
  final String title;

  Deck({this.id, required this.title});

  Map<String, dynamic> toMap() => {'id': id, 'title': title};
  factory Deck.fromMap(Map<String, dynamic> map) => Deck(id: map['id'], title: map['title']);
}