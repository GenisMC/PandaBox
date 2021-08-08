// ignore_for_file: import_of_legacy_library_into_null_safe
// ignore_for_file: avoid_print
import 'package:codepandas/Services/fire_store_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final DatabaseService db = DatabaseService();

  //Sign in anonymously
  Future signInAnonym() async {
    try {
      UserCredential result = await auth.signInAnonymously();
      User user = result.user!;
      print(user);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await auth.signInWithCredential(credential);

      await db.setUserData(auth.currentUser!.uid, auth.currentUser!.displayName,
          auth.currentUser!.email, auth.currentUser!.photoURL);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      rethrow;
    }
  }

  Future signOutFromGoogle() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
