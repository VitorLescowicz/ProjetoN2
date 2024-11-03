// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // _user será atualizado pelo listener
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Erro de autenticação';
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // _user será atualizado pelo listener
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Erro de autenticação';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  void _onAuthStateChanged(User? firebaseUser) {
    _user = firebaseUser;
    notifyListeners();
  }
}
