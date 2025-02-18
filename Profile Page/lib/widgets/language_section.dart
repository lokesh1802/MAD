import 'package:flutter/material.dart';

class LanguageSection extends StatelessWidget {
  final List<String> languages;

  LanguageSection({required this.languages});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Languages',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: languages.map((language) {
              return Chip(
                label: Text(language),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
