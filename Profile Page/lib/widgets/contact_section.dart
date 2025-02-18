import 'package:flutter/material.dart';
import '../user_info.dart';

class ContactSection extends StatelessWidget {
  final UserInfo userInfo;

  ContactSection({required this.userInfo});

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
            'Contact Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text('Email: ${userInfo.email}'),
          Text('Phone: ${userInfo.phone}'),
          Text('Location: ${userInfo.location}'),
        ],
      ),
    );
  }
}
