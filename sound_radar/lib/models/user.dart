import 'song.dart';

class User {
  final String id;
  final String name;
  final String description;
  final String avatarColorHex; // por simplicidad
  final String instagram;
  final String xLink;
  final List<Song> lastSongs;

  User({
    required this.id,
    required this.name,
    required this.description,
    required this.avatarColorHex,
    required this.instagram,
    required this.xLink,
    required this.lastSongs,
  });
}
