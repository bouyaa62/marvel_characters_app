import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_characters_app/models/character.dart';
import 'package:marvel_characters_app/services/character_repository.dart';
import 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  final CharacterRepository _repository;
  final int _pageSize = 10;
  int _currentPage = 0;

  CharacterCubit(this._repository)
      : super(CharacterState(characters: [], isLoading: false));

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
    }
  }
}
