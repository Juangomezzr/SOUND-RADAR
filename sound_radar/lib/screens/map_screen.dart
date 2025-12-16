import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/user.dart';
import '../models/song.dart';
import 'profile_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  LatLng? _myLatLng;

  // Usuario actual (dummy)
  late final User _currentUser;

  // Usuarios cercanos dummy + sus posiciones (cerca de tu ubicación real)
  final List<User> _nearbyUsers = [];
  final List<LatLng> _nearbyPositions = [];

  @override
  void initState() {
    super.initState();

    _currentUser = User(
      id: 'me',
      name: 'Purple',
      description: 'Example description based on last song played.',
      avatarColorHex: '#A855F7',
      instagram: 'https://instagram.com/purple',
      xLink: 'https://x.com/purple',
      lastSongs: [
                    Song(title: 'Midnight City', artist: 'M83'),
                    Song(title: 'After Dark', artist: 'Mr.Kitty'),
                    Song(title: 'Blinding Lights', artist: 'The Weeknd'),
                    Song(title: 'Electric Feel', artist: 'MGMT'),
                    Song(title: 'Do I Wanna Know?', artist: 'Arctic Monkeys'),
                    Song(title: 'Starboy', artist: 'The Weeknd'),
                    Song(title: 'Sunset Lover', artist: 'Petit Biscuit'),
                    Song(title: 'Nightcall', artist: 'Kavinsky'),
                    Song(title: 'Feels Like We Only Go Backwards', artist: 'Tame Impala'),
                    Song(title: 'The Less I Know The Better', artist: 'Tame Impala'),
                    Song(title: 'Sweater Weather', artist: 'The Neighbourhood'),
                    Song(title: 'Somebody Else', artist: 'The 1975'),
                    Song(title: 'Kids', artist: 'MGMT'),
                    Song(title: 'Riptide', artist: 'Vance Joy'),
                    Song(title: 'Cold Heart', artist: 'Elton John & Dua Lipa'),
                    Song(title: 'Levitating', artist: 'Dua Lipa'),
                    Song(title: '505', artist: 'Arctic Monkeys'),
                    Song(title: 'Time', artist: 'Hans Zimmer'),
                    Song(title: 'Intro', artist: 'The xx'),
                    Song(title: 'A Moment Apart', artist: 'ODESZA'),
                  ],
    );

    _initLocation();
  }

  Future<void> _initLocation() async {
    // 1) Comprobar si el GPS está activado
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activa el servicio de ubicación')),
      );
      return;
    }

    // 2) Permisos
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación denegado')),
      );
      return;
    }

    // 3) Obtener posición
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final my = LatLng(pos.latitude, pos.longitude);

    // 4) Generar usuarios cerca (coordenadas falsas alrededor)
    _nearbyUsers
      ..clear()
      ..addAll([
        User(
          id: 'u1',
          name: 'Alex',
          description: 'Nearby music lover.',
          avatarColorHex: '#7C3AED',
          instagram: 'https://instagram.com/alex',
          xLink: 'https://x.com/alex',
          lastSongs: [Song(title: 'Levitating', artist: 'Dua Lipa'),
                      Song(title: 'Don’t Start Now', artist: 'Dua Lipa'),
                      Song(title: 'Style', artist: 'Taylor Swift'),
                      Song(title: 'Cruel Summer', artist: 'Taylor Swift'),
                      Song(title: 'Happier Than Ever', artist: 'Billie Eilish'),
                      Song(title: 'Kill Bill', artist: 'SZA'),
                      Song(title: 'Good 4 U', artist: 'Olivia Rodrigo'),
                      Song(title: 'Anti-Hero', artist: 'Taylor Swift'),
                      Song(title: 'Dance Monkey', artist: 'Tones and I'),
                      Song(title: 'Titanium', artist: 'David Guetta'),
                      Song(title: 'Blinding Lights', artist: 'The Weeknd'),
                      Song(title: 'Flowers', artist: 'Miley Cyrus'),
                      Song(title: 'Shake It Off', artist: 'Taylor Swift'),
                      Song(title: 'Watermelon Sugar', artist: 'Harry Styles'),
                      Song(title: 'Bad Guy', artist: 'Billie Eilish'),
                      Song(title: 'Someone You Loved', artist: 'Lewis Capaldi'),
                      Song(title: 'Drivers License', artist: 'Olivia Rodrigo'),
                      Song(title: 'Halo', artist: 'Beyoncé'),
                      Song(title: 'Firework', artist: 'Katy Perry'),
                      Song(title: 'Blank Space', artist: 'Taylor Swift'),],
        ),
        User(
          id: 'u2',
          name: 'Saro',
          description: 'Always discovering new sounds.',
          avatarColorHex: '#22C55E',
          instagram: 'https://instagram.com/sara',
          xLink: 'https://x.com/sara',
          lastSongs: [Song(title: 'Lose Yourself', artist: 'Eminem'),
                      Song(title: 'HUMBLE.', artist: 'Kendrick Lamar'),
                      Song(title: 'SICKO MODE', artist: 'Travis Scott'),
                      Song(title: 'God’s Plan', artist: 'Drake'),
                      Song(title: 'Stronger', artist: 'Kanye West'),
                      Song(title: 'Industry Baby', artist: 'Lil Nas X'),
                      Song(title: 'Lucid Dreams', artist: 'Juice WRLD'),
                      Song(title: 'No Role Modelz', artist: 'J. Cole'),
                      Song(title: 'Mask Off', artist: 'Future'),
                      Song(title: 'Still D.R.E.', artist: 'Dr. Dre'),
                      Song(title: 'POWER', artist: 'Kanye West'),
                      Song(title: 'Alright', artist: 'Kendrick Lamar'),
                      Song(title: 'Goosebumps', artist: 'Travis Scott'),
                      Song(title: 'DNA.', artist: 'Kendrick Lamar'),
                      Song(title: 'Stan', artist: 'Eminem'),
                      Song(title: 'Hate It Or Love It', artist: 'The Game'),
                      Song(title: 'Many Men', artist: '50 Cent'),
                      Song(title: 'In Da Club', artist: '50 Cent'),
                      Song(title: 'Still Not a Player', artist: 'Big Pun'),
                      Song(title: 'Shook Ones, Pt. II', artist: 'Mobb Deep'),],
        ),
        User(
          id: 'u3',
          name: 'Marco',
          description: 'Hip-hop head.',
          avatarColorHex: '#EF4444',
          instagram: 'https://instagram.com/marco',
          xLink: 'https://x.com/marco',
          lastSongs: [ Song(title: 'As It Was', artist: 'Harry Styles'),
                        Song(title: 'Blinding Lights', artist: 'The Weeknd'),
                        Song(title: 'Levitating', artist: 'Dua Lipa'),
                        Song(title: 'Sunflower', artist: 'Post Malone'),
                        Song(title: 'Heat Waves', artist: 'Glass Animals'),
                        Song(title: 'bad guy', artist: 'Billie Eilish'),
                        Song(title: 'Starboy', artist: 'The Weeknd'),
                        Song(title: 'Believer', artist: 'Imagine Dragons'),
                        Song(title: 'Shivers', artist: 'Ed Sheeran'),
                        Song(title: 'Flowers', artist: 'Miley Cyrus'),
                        Song(title: 'Watermelon Sugar', artist: 'Harry Styles'),
                        Song(title: 'Peaches', artist: 'Justin Bieber'),
                        Song(title: 'Can’t Feel My Face', artist: 'The Weeknd'),
                        Song(title: 'Senorita', artist: 'Shawn Mendes'),
                        Song(title: 'Stay', artist: 'The Kid LAROI'),
                        Song(title: 'Closer', artist: 'The Chainsmokers'),
                        Song(title: 'Cheap Thrills', artist: 'Sia'),
                        Song(title: 'Circles', artist: 'Post Malone'),
                        Song(title: 'Don’t Start Now', artist: 'Dua Lipa'),
                        Song(title: 'Perfect', artist: 'Ed Sheeran'),],
                              ),
      ]);

    final positions = _generateNearbyPoints(my, _nearbyUsers.length);

    setState(() {
      _myLatLng = my;
      _nearbyPositions
        ..clear()
        ..addAll(positions);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
  if (!mounted) return;
  _mapController.move(my, 16);

});


  }

  List<LatLng> _generateNearbyPoints(LatLng center, int count) {
    // offsets ~ 50-250m aprox (depende de latitud)
    final offsets = <Offset>[
      const Offset(0.0007, 0.0004),
      const Offset(-0.0006, 0.0005),
      const Offset(0.0004, -0.0008),
      const Offset(-0.0009, -0.0003),
      const Offset(0.0010, 0.0009),
    ];

    return List.generate(count, (i) {
      final o = offsets[i % offsets.length];
      return LatLng(center.latitude + o.dx, center.longitude + o.dy);
    });
  }

  Color _colorFromHex(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
  void _centerOnUser() {
    if (_myLatLng == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
  if (!mounted) return;
  _mapController.move(_myLatLng!, 16);
});
  }

  void _goToMyProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProfileScreen(user: _currentUser)),
    );
  }

  void _showUserPopup(User user) {
  final song = user.lastSongs.isNotEmpty ? user.lastSongs.first : null;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3D), // gris oscuro más claro
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // USERNAME
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F2F33),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // SONG
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F2F33),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        song?.title ?? 'Song',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        song?.artist ?? 'Artist',
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // BOTÓN GO TO USER (destacado)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF4F46E5), // acento sutil
                      foregroundColor: Colors.white,
                      elevation: 6, // sombra ligera
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: user),
                        ),
                      );
                    },
                    child: const Text(
                      'Go To User',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    if (_myLatLng == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    const tilesUrl =
        'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';
    const subs = ['a', 'b', 'c', 'd'];

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _myLatLng!,
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate: tilesUrl,
                subdomains: subs,
                userAgentPackageName: 'com.example.sound_radar',
              ),
              MarkerLayer(
                markers: [
                  // my location
                  Marker(
                    point: _myLatLng!,
                    width: 22,
                    height: 22,
                    child: const Icon(Icons.circle, color: Colors.red, size: 18),
                  ),

                  // dummy users
                  ...List.generate(_nearbyUsers.length, (i) {
                    final user = _nearbyUsers[i];
                    final point = _nearbyPositions[i];
                    final userColor = _colorFromHex(user.avatarColorHex);

                    return Marker(
                      point: point,
                      width: 46,
                      height: 46,
                      child: GestureDetector(
                        onTap: () => _showUserPopup(user),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: userColor,
                            border: Border.all(color: Colors.white24, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              user.name[0],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // Botones abajo derecha: centrar + perfil
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'center_btn',
                    onPressed: _centerOnUser,
                    backgroundColor: const Color(0xFF3F3F46),
                    child: const Icon(Icons.my_location),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton(
                    heroTag: 'profile_btn',
                    onPressed: _goToMyProfile,
                    backgroundColor: const Color(0xFF3F3F46),
                    child: const Icon(Icons.person),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
