import 'package:flutter/material.dart';
import 'profile_screen.dart';
import '../models/user.dart';
import '../models/song.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // usuario dummy para probar navegación
    final user = User(
      id: '1',
      name: 'Purple',
      description: 'Example description based on last song played.',
      avatarColorHex: '#A855F7',
      instagram: 'https://instagram.com/purple',
      xLink: 'https://x.com/purple',
      lastSongs: List.generate(
        8,
        (i) => Song(title: 'Song $i', artist: 'Artist $i'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sound Radar Map'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(user: user),
              ),
            );
          },
          child: const Text('Ir al perfil de ejemplo'),
        ),
      ),
    );
  }
}
