// lib/user_info.dart
class UserInfo {
  final String name;
  final String aboutMe; // Field for "About Me"
  final String bio;     // Field for "Bio"
  final String profession;
  final String company;
  final String location;
  final String email;
  final String phone;
  final List<String> languages;
  final List<String> interests;
  final List<String> photos;
  final String profilePhoto;

  UserInfo({
    required this.name,
    required this.aboutMe, // Add this parameter
    required this.bio,     // Add this parameter
    required this.profession,
    required this.company,
    required this.location,
    required this.email,
    required this.languages,
    required this.phone,
    required this.interests,
    required this.photos,
    required this.profilePhoto,
  });
}
