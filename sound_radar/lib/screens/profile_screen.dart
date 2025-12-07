import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/profile/song_tile.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _colorFromHex(user.avatarColorHex);

    return GestureDetector(
      // Aquí detectamos el gesto de deslizar
      onHorizontalDragEnd: (details) {
        // primaryVelocity > 0  → desliza hacia la derecha
        if (details.primaryVelocity != null &&
            details.primaryVelocity! > 0) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: const Color(0xFF18181B),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header tipo "Slide back"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Slide Back',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: avatarColor,
                      child: Text(
                        user.name[0],
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Links',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F3F46),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Instagram: ${user.instagram}\nX: ${user.xLink}',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Intelligence Description',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F3F46),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(user.description),
                ),
                const SizedBox(height: 16),
                const Text('Last Songs',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: user.lastSongs.length,
                    itemBuilder: (_, index) =>
                        SongTile(song: user.lastSongs[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
