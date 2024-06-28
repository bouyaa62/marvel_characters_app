import 'package:marvel_characters_app/models/character.dart';

class CharacterState {
  final List<Character> characters;
  final List<Character> favorites;
  final bool isLoading;

  CharacterState({
    required this.characters,
    required this.favorites,
    this.isLoading = false,
  });

  CharacterState copyWith({
    List<Character>? characters,
    List<Character>? favorites,
    bool? isLoading,
  }) {
    return CharacterState(
      characters: characters ?? this.characters,
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
