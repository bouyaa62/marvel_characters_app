import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marvel_characters_app/cubit/auth_cubit.dart';
import 'package:marvel_characters_app/cubit/auth_state.dart';
import 'package:marvel_characters_app/cubit/character_cubit.dart';
import 'package:marvel_characters_app/screens/character_details_screen.dart';
import 'package:marvel_characters_app/screens/characters_page.dart';
import 'package:marvel_characters_app/screens/favorites_screen.dart';
import 'package:marvel_characters_app/screens/login_page.dart';
import 'package:marvel_characters_app/services/character_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(FirebaseAuth.instance)),
        BlocProvider(
            create: (context) =>
                CharacterCubit(CharacterRepository())..fetchCharacters()),
      ],
      child: MaterialApp(
        title: 'Flutter Auth App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => AuthGate(),
          '/characters': (context) => CharactersScreen(),
          '/character-details': (context) => CharacterDetailsScreen(),
          '/favorites': (context) => FavoritesScreen(),
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.isAuthenticated) {
          return CharactersScreen();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
