import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static Future<User?> signInWithGoogle() async {
    User? user;

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser != null) {
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      try {
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        // if (e.code == 'account-exists-with-different-credential') {
        //   Get.showSnackbar(const GetSnackBar(
        //     message:
        //         "You already have an account with this email. Use other login method.",
        //     duration: Duration(seconds: 3),
        //   ));
        // }
        if (e.code == 'invalid-credential') {
          const SnackBar(
            content: Text("Invalid Credential!"),
            duration: Duration(seconds: 3),
          );
        } else if (e.code == 'wrong-password') {
          const SnackBar(
            content: Text("Wrong password!"),
            duration: Duration(seconds: 3),
          );
        }
      } catch (e) {
        const SnackBar(
          content: Text("Unknown Error. Try again later"),
          duration: Duration(seconds: 3),
        );
      }
    }
    return user;
  }
}
