// lib/main.dart
import 'package:cs442_mp2/widgets/language_section.dart';
import 'package:flutter/material.dart';
import 'user_info.dart';
import 'widgets/header_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/interests_section.dart';
import 'widgets/photos_section.dart';
import 'widgets/about_me_section.dart';

void main() {
  UserInfo userInfo = UserInfo(
    name: 'Prabhas',
    aboutMe: 'With a passion for portraying diverse characters, I rose to international fame through the Baahubali series, which became one of India\'s biggest cinematic successes. I constantly strive to explore new genres and push the boundaries of storytelling. Beyond acting, I enjoy maintaining a private, grounded lifestyle, cherishing time with family and friends.',
    bio: 'i am an actor',
    profession: 'Movie star',
    company: 'TFI',
    location: 'Hyderabad',
    languages: ['Telugu', 'Hindi', 'English'],
    email: 'prabhas@TFIrebel.com',
    phone: '(986) 623-4568',
    interests: ['Food', 'Cars', 'Traveling', 'Movies'],
    photos: [
      'assets/images/photo2.jpg',
      'assets/images/photo4.jpg',
      'assets/images/photo5.webp',
    ],
    profilePhoto: 'assets/images/photo1.jpeg', // Profile photo path
  );

  runApp(MaterialApp(home: UserInfoPage(userInfo: userInfo)));
}

class UserInfoPage extends StatelessWidget {
  final UserInfo userInfo;

  UserInfoPage({required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${userInfo.name}\'s Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(userInfo: userInfo),
            AboutMeSection(aboutMeText: userInfo.aboutMe), // Use the new aboutMe field
            LanguageSection(languages: userInfo.languages),
            ContactSection(userInfo: userInfo),
            InterestsSection(interests: userInfo.interests),
            PhotosSection(photos: userInfo.photos),
          ],
        ),
      ),
    );
  }
}
