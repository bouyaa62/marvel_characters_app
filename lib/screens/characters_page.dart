import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_characters_app/cubit/character_cubit.dart';
import 'package:marvel_characters_app/cubit/character_state.dart';
import 'package:marvel_characters_app/models/character.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharactersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Characters')),
      body: BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          if (state.isLoading && state.characters.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: state.characters.length + 1,
              itemBuilder: (context, index) {
                if (index < state.characters.length) {
                  Character character = state.characters[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/character-details',
                        arguments: character,
                      );
                    },
                    child: ListTile(
                      leading: Image.network(character.imageUrl),
                      title: Text(character.name),
                      subtitle: Text('ID: ${character.id}'),
                      trailing: FavoriteButton(character: character),
                    ),
                  );
                } else if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  // Trigger load more characters
                  context.read<CharacterCubit>().fetchCharacters();
                  return Container(); // Placeholder widget
                }
              },
            );
          }
        },
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final Character character;

  const FavoriteButton({Key? key, required this.character}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.character.id.toString()) ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final newStatus = !isFavorite;
    await prefs.setBool(widget.character.id.toString(), newStatus);
    setState(() {
      isFavorite = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
