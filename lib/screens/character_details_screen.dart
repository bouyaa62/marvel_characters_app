import 'package:flutter/material.dart';
import 'package:marvel_characters_app/models/character.dart';

class CharacterDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Character character =
        ModalRoute.of(context)!.settings.arguments as Character;

    return Scaffold(
      appBar: AppBar(title: Text('Character Details')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(character.imageUrl),
          SizedBox(height: 20),
          Text('Name: ${character.name}'),
          SizedBox(height: 20),
          Text('Comics:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ...character.urls.entries.map((entry) {
            return ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value),
              onTap: () {},
            );
          }).toList(),
        ],
      ),
    );
  }
}
