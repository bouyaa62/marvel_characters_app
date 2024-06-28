class Character {
  final int id;
  final String name;
  final String imageUrl;
  final Map<String, String> urls;

  Character({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.urls,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      imageUrl:
          '${json['thumbnail']['path']}.${json['thumbnail']['extension']}',
      urls: Map.fromEntries((json['urls'] as List<dynamic>)
          .map((url) => MapEntry(url['type'], url['url']))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnail': {
        'path': imageUrl.split('.').first,
        'extension': imageUrl.split('.').last,
      },
      'urls': urls.entries
          .map((entry) => {'type': entry.key, 'url': entry.value})
          .toList(),
    };
  }
}
