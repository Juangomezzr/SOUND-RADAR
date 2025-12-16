import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../models/user.dart';
import '../models/song.dart';
import 'profile_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;

  // Usuario dummy que usaremos como "usuario actual"
  late final User _currentUser;

  @override
  void initState() {
    super.initState();

    // controlador del mapa usando la posición del usuario
    _mapController = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
    );

    // usuario de ejemplo (puedes mover esto luego a DummyDataService)
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
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _goToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileScreen(user: _currentUser),
      ),
    );
  }

  void _centerOnUser() async {
    try {
      // centra el mapa en la ubicación actual del usuario
      await _mapController.currentLocation();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo centrar en tu ubicación'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🗺️ MAPA OSM OCUPANDO TODA LA PANTALLA
          OSMFlutter(
            controller: _mapController,
            
            osmOption: OSMOption(
            

              
              userTrackingOption: const UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              zoomOption: const ZoomOption(
                initZoom: 16,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.purpleAccent,
                    size: 48,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.navigation,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
             
              ),
          ),

              // 🔘 BOTONES ABAJO A LA DERECHA (centrar + perfil)
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'center_button',
                onPressed: _centerOnUser,
                backgroundColor: const Color(0xFF3F3F46),
                child: const Icon(Icons.my_location),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                heroTag: 'profile_button',
                onPressed: _goToProfile,
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
