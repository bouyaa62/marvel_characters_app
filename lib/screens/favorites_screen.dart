import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_characters_app/cubit/character_cubit.dart';
import 'package:marvel_characters_app/cubit/character_state.dart';
import 'package:marvel_characters_app/models/character.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          if (state.favorites.isEmpty) {
            return Center(child: Text('No favorites yet.'));
          } else {
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                Character character = state.favorites[index];
                return Card(
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
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        context
                            .read<CharacterCubit>()
                            .toggleFavorite(character);
                      },
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/character-details',
                        arguments: character,
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
