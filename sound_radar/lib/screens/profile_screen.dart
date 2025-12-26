import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/profile/song_tile.dart';
import '../services/gemini_service.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragOffsetX = 0.0; // desplazamiento actual en X
  late String _description;
  bool _loadingDescription = false;
  final GeminiService _gemini = const GeminiService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _description = widget.user.description.trim().isEmpty
        ? _fallbackDescription(widget.user)
        : widget.user.description.trim();

    _maybeGenerateDescription();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _fallbackDescription(User user) {
    final artists = user.lastSongs.map((s) => s.artist).toList();
    final unique = <String>{};
    final top = <String>[];
    for (final artist in artists) {
      if (unique.add(artist)) top.add(artist);
      if (top.length == 3) break;
    }
    if (top.isEmpty) return 'Explorando música nueva últimamente.';
    if (top.length == 1) return 'Últimamente escuchando mucho a ${top[0]}.';
    if (top.length == 2) {
      return 'Últimamente entre ${top[0]} y ${top[1]}.';
    }
    return 'Últimamente entre ${top[0]}, ${top[1]} y ${top[2]}.';
  }

  Future<void> _maybeGenerateDescription() async {
    if (widget.user.lastSongs.isEmpty) return;
    if (_loadingDescription) return;

    setState(() {
      _loadingDescription = true;
    });

    try {
      final generated = await _gemini.generateUserDescriptionFromSongs(
        widget.user.lastSongs,
        language: 'es',
      );
      if (!mounted) return;
      setState(() {
        _description = generated;
      });
    } catch (_) {
      // mantenemos fallback/description existente
    } finally {
      if (!mounted) return;
      setState(() {
        _loadingDescription = false;
      });
    }
  }

  Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  void _animateTo(double from, double to, VoidCallback onEnd) {
    _controller.stop();
    _animation = Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {
          _dragOffsetX = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          onEnd();
        }
      });

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _colorFromHex(widget.user.avatarColorHex);
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      // arrastre horizontal: movemos la pantalla con el dedo
      onHorizontalDragUpdate: (details) {
        setState(() {
          // solo permitimos arrastrar hacia la derecha
          _dragOffsetX += details.delta.dx;
          if (_dragOffsetX < 0) _dragOffsetX = 0;
        });
      },
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;

        // condición para completar el "back":
        // - que haya arrastrado más del 30% del ancho
        // - o que suelte con un gesto rápido hacia la derecha
        final shouldPop =
            _dragOffsetX > screenWidth * 0.3 || velocity > 500;

        if (shouldPop) {
          // animamos hasta fuera de pantalla y luego hacemos pop
          _animateTo(_dragOffsetX, screenWidth, () {
            Navigator.pop(context);
          });
        } else {
          // vuelve a su sitio (0)
          _animateTo(_dragOffsetX, 0, () {});
        }
      },
      child: Transform.translate(
        offset: Offset(_dragOffsetX, 0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
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
                        onPressed: () {
                          _animateTo(_dragOffsetX, screenWidth, () {
                            Navigator.pop(context);
                          });
                        },
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
                          widget.user.name[0],
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.user.name,
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
                      'Instagram: ${widget.user.instagram}\nX: ${widget.user.xLink}',
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(_description)),
                        if (_loadingDescription) ...[
                          const SizedBox(width: 12),
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Last Songs',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.user.lastSongs.length,
                      itemBuilder: (_, index) =>
                          SongTile(song: widget.user.lastSongs[index]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
