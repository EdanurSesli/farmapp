import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInScreen extends StatefulWidget {
  @override
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userInfo = 'Henüz giriş yapılmadı.';

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _userInfo = 'Giriş iptal edildi.';
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      setState(() {
        _userInfo = 'İsim: ${userCredential.user?.displayName}\n'
            'Email: ${userCredential.user?.email}\n'
            'ID: ${userCredential.user?.uid}';
      });
    } catch (e) {
      setState(() {
        _userInfo = 'Hata oluştu: $e';
      });
    }
  }

  Future<void> _signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    setState(() {
      _userInfo = 'Henüz giriş yapılmadı.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In with Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: Text('Google ile Giriş Yap'),
            ),
            SizedBox(height: 20),
            Text(
              _userInfo,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: Text('Çıkış Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
