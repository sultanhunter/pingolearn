import 'dart:convert';

class WordData {
  final String meaning;
  final String example;
  final String? imageUrl;

  WordData(this.meaning, this.example, this.imageUrl);

  Map<String, dynamic> toMap() {
    return {
      'meaning': meaning,
      'example': example,
      'imageUrl': imageUrl,
    };
  }

  factory WordData.fromMap(Map<String, dynamic> map) {
    return WordData(
      map['definition'] ?? '',
      map['example'] ?? '',
      map['image_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WordData.fromJson(String source) =>
      WordData.fromMap(json.decode(source));
}
