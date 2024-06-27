import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final User? user;
  final bool isAuthenticated;
  final String? errorMessage;

  AuthState({this.user, this.isAuthenticated = false, this.errorMessage});
}
