import 'package:flutter/material.dart';
import '../user_info.dart';

class HeaderSection extends StatelessWidget {
  final UserInfo userInfo;

  HeaderSection({required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light gray background for the header
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile Photo
          ClipOval(
            child: Image.asset(
              userInfo.profilePhoto,
              width: MediaQuery.of(context).size.width * 0.2, // 20% of screen width
              height: MediaQuery.of(context).size.width * 0.2,
              fit: BoxFit.cover,
            ),
          ),
          // User Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userInfo.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userInfo.profession,
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  Text(userInfo.location),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
