import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthCubit(this._firebaseAuth) : super(AuthState());

  void login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      emit(AuthState(user: userCredential.user, isAuthenticated: true));
    } on FirebaseAuthException catch (e) {
      emit(AuthState(isAuthenticated: false, errorMessage: e.message));
    }
  }

  void logout() async {
    await _firebaseAuth.signOut();
    emit(AuthState(isAuthenticated: false));
  }
}
