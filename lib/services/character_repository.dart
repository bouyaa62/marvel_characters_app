import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:marvel_characters_app/models/character.dart';

class CharacterRepository {
  static const String _baseUrl = 'https://gateway.marvel.com/v1/public';
  final String _apiKey =
      '00d777b62d5eb935e16f26bb317b70ca'; // Replace with your Marvel public API key
  final String _privateKey =
      '10fcf4b614116a6dcc6db23e66389a7b19e130f0'; // Replace with your Marvel private API key

  String _generateHash(String timeStamp) {
    var bytes = utf8.encode('$timeStamp$_privateKey$_apiKey');
    var hash = crypto.md5.convert(bytes);
    return hash.toString();
  }

  Future<List<Character>> getCharacters(int limit, int offset) async {
    final String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String hash = _generateHash(timeStamp);
    final Uri uri = Uri.parse(
        '$_baseUrl/characters?limit=$limit&offset=$offset&apikey=$_apiKey&ts=$timeStamp&hash=$hash');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<Character> characters = (jsonData['data']['results'] as List)
            .map((character) => Character.fromJson(character))
            .toList();
        return characters;
      } else {
        throw Exception('Failed to load characters: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }
}
