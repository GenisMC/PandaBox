import 'package:codepandas/Classes/user_group.dart';

class AppUser {
  String uid;
  String name;
  String email;
  String profilePhoto;
  List<UserGroup> groups;

  AppUser(
      {required this.uid,
      required this.name,
      required this.email,
      required this.profilePhoto,
      required this.groups});
}
