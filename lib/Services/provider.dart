import 'package:codepandas/Services/fire_auth_service.dart';
import 'package:codepandas/Services/fire_filestore_service.dart';
import 'package:codepandas/Services/fire_store_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ProviderService extends ChangeNotifier {
  final AuthService authService = AuthService();
  final FileStorageService storage = FileStorageService();
  final DatabaseService db = DatabaseService();

  bool userIn = false;
  

  ProviderService() {
    authService.auth.authStateChanges().listen((User? user) {
      if (user == null) {
        userIn = false;
        print("signed out");
        notifyListeners();
      } else {
        userIn = true;
        print("signed in");
        notifyListeners();
      }
    });
  }
}
