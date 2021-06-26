class Manga {
  int id;
  String title;
  String cover;
  String poster;
  String author;
  String artist;
  String synopsis;
  int chaptersCount;

  Manga({
    required this.id,
    required this.title,
    required this.cover,
    required this.poster,
    required this.author,
    required this.artist,
    required this.synopsis,
    required this.chaptersCount,
  });

  factory Manga.fromJson(Map<String, dynamic> json) => Manga(
        id: json['id'] as int,
        title: json['title'] as String,
        cover: json['cover'] as String,
        poster: json['poster'] as String,
        author: json['author'] as String,
        artist: json['artist'] as String,
        synopsis: json['synopsis'] as String,
        chaptersCount: json['chapters_count'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'cover': cover,
        'poster': poster,
        'author': author,
        'artist': artist,
        'synopsis': synopsis,
        'chapters_count': chaptersCount,
      };
}
