import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  clientId: dotenv.env['GOOGLE_CLIENT_ID'],
);

/// Utility function to sign in with Google and return the ID token
Future<String?> getGoogleIdToken() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    return googleAuth.idToken;
  } catch (error) {
    debugPrint('Error getting Google ID token: $error');
    return null;
  }
}
