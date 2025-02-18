import 'package:flutter/material.dart';

class InterestsSection extends StatelessWidget {
  final List<String> interests;

  InterestsSection({required this.interests});

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
            'Interests',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: interests.map((interest) {
              return Chip(
                label: Text(interest),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
