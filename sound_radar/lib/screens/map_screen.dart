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
      lastSongs: List.generate(
        8,
        (i) => Song(title: 'Song $i', artist: 'Artist $i'),
      ),
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
          lastSongs: [Song(title: 'As It Was', artist: 'Harry Styles')],
        ),
        User(
          id: 'u2',
          name: 'Saro',
          description: 'Always discovering new sounds.',
          avatarColorHex: '#22C55E',
          instagram: 'https://instagram.com/sara',
          xLink: 'https://x.com/sara',
          lastSongs: [Song(title: 'Levitating', artist: 'Dua Lipa')],
        ),
        User(
          id: 'u3',
          name: 'Marco',
          description: 'Hip-hop head.',
          avatarColorHex: '#EF4444',
          instagram: 'https://instagram.com/marco',
          xLink: 'https://x.com/marco',
          lastSongs: [Song(title: 'Lose Yourself', artist: 'Eminem')],
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

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3F3F46),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Username
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF27272A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Song / Artist
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF27272A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(song?.title ?? 'Song Name',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(song?.artist ?? 'Artist',
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Go to user
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF27272A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                    child: const Text('Go To User'),
                  ),
                ),
              ],
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
