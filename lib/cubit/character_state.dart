import 'package:marvel_characters_app/models/character.dart';

class CharacterState {
  final List<Character> characters;
  final bool isLoading;

  CharacterState({
    required this.characters,
    this.isLoading = false,
  });

  CharacterState copyWith({
    List<Character>? characters,
    bool? isLoading,
  }) {
    return CharacterState(
      characters: characters ?? this.characters,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
