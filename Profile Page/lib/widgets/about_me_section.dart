import 'package:flutter/material.dart';

class AboutMeSection extends StatelessWidget {
  final String aboutMeText;

  AboutMeSection({required this.aboutMeText});

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
            'About Me',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            aboutMeText,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
