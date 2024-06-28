import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_characters_app/cubit/character_cubit.dart';
import 'package:marvel_characters_app/cubit/character_state.dart';
import 'package:marvel_characters_app/models/character.dart';

class CharactersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characters'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
            child: Text(
              'Favorites',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          if (state.isLoading && state.characters.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: state.characters.length + (state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < state.characters.length) {
                  Character character = state.characters[index];
                  bool isFavorite =
                      state.favorites.any((fav) => fav.id == character.id);
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/character-details',
                        arguments: character,
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            character.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          character.name,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text('ID: ${character.id}'),
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            context
                                .read<CharacterCubit>()
                                .toggleFavorite(character);
                          },
                        ),
                      ),
                    ),
                  );
                } else if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  // Placeholder for when loading more characters
                  context.read<CharacterCubit>().fetchCharacters();
                  return Container();
                }
              },
            );
          }
        },
      ),
    );
  }
}
