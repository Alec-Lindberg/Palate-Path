import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String id;
  final String? email;

  AppUser({required this.id, this.email});

  factory AppUser.fromFirebase(User user) {
    return AppUser(id: user.uid, email: user.email);
  }
}
