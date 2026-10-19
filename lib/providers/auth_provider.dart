import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider; 

class AuthProvider extends ChangeNotifier {
  // TODO 1: simpan state login di sini (_isAuthenticated + _token + getter).


  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;

  bool get isAuthenticated => _user != null;
  String? get token => null;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      _user = cred.user;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _pesanError(e.code);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      _user = cred.user;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _pesanError(e.code);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future <void> logout() async {
    await _auth.signOut();
  }

  String _pesanError(String code) {
    if(code == 'user-not-found' || code == 'invalid-credential') {
      return 'Email atau Password Salah Cik.';
    }
    if(code == 'email-already-in-use') return 'Email Sudah terpakai.';
    if(code == 'weak-password') return 'Password Minimal 6 Karakter.';
    if(code == 'invalid-email') return 'Format Email salah cuk.';
    if(code == 'configuration-not-found') {
      return 'Auth belum diaktifkan di console: enable Email/Password dulu.';
    }
    if(code == 'network-request-failed') {
    return 'Tidak Ada Paket yah.';
    }
    return 'Gagal ($code)';
  }
}