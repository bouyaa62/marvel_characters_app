import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_characters_app/models/character.dart';
import 'package:marvel_characters_app/services/character_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'character_state.dart';
import 'dart:convert';

class CharacterCubit extends Cubit<CharacterState> {
  final CharacterRepository _repository;
  final int _pageSize = 10;
  int _currentPage = 0;

  CharacterCubit(this._repository)
      : super(CharacterState(characters: [], favorites: [], isLoading: false)) {
    _loadFavorites();
  }

  void fetchCharacters() async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));
      final List<Character> characters =
          await _repository.getCharacters(_pageSize, _currentPage * _pageSize);
      emit(state.copyWith(
        characters: [...state.characters, ...characters],
        isLoading: false,
      ));
      _currentPage++;
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Handle error
      print('Error fetching characters: $e');
    }
  }

  void toggleFavorite(Character character) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Character> updatedFavorites = List.from(state.favorites);

    if (updatedFavorites.any((fav) => fav.id == character.id)) {
      updatedFavorites.removeWhere((fav) => fav.id == character.id);
    } else {
      updatedFavorites.add(character);
    }

    emit(state.copyWith(favorites: updatedFavorites));
    prefs.setString('favorites',
        jsonEncode(updatedFavorites.map((c) => c.toJson()).toList()));
  }

  void _loadFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString('favorites');
    if (favoritesJson != null) {
      final List<dynamic> decodedFavorites = jsonDecode(favoritesJson);
      final List<Character> favorites =
          decodedFavorites.map((c) => Character.fromJson(c)).toList();
      emit(state.copyWith(favorites: favorites));
    }
  }
}
