import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import '../config/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _devAuthKey = 'dev_authenticated';

  final StreamController<User?> _devAuthController = StreamController<User?>.broadcast();

  Stream<User?> get authStateChanges {
    if (AppConstants.devBypass) {
      _checkDevAuth().then((user) => _devAuthController.add(user));
      return _devAuthController.stream;
    }
    return _auth.authStateChanges();
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithEmail(String email, String password) async {
    if (AppConstants.devBypass) {
      await _secureStorage.write(key: _devAuthKey, value: 'true');
      _devAuthController.add(null);
      return;
    }
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _storeToken(result.user);
  }

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (AppConstants.devBypass) {
      await _secureStorage.write(key: _devAuthKey, value: 'true');
      _devAuthController.add(null);
      return;
    }
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await result.user?.updateDisplayName(name);
    await _storeToken(result.user);
  }

  Future<void> signInWithGoogle() async {
    if (AppConstants.devBypass) {
      await _secureStorage.write(key: _devAuthKey, value: 'true');
      _devAuthController.add(null);
      return;
    }
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    await _storeToken(result.user);
  }

  Future<void> sendPasswordReset(String email) async {
    if (AppConstants.devBypass) return;
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _secureStorage.delete(key: _devAuthKey);
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _secureStorage.delete(key: _tokenKey);
  }

  Future<String?> getStoredToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> _storeToken(User? user) async {
    if (user != null) {
      final token = await user.getIdToken();
      if (token != null) {
        await _secureStorage.write(key: _tokenKey, value: token);
      }
    }
  }

  Future<User?> _checkDevAuth() async {
    final devAuth = await _secureStorage.read(key: _devAuthKey);
    if (devAuth == 'true') {
      return _auth.currentUser;
    }
    return null;
  }
}
