import 'package:flutter/material.dart';

class AuthCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const AuthCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outline.withValues(alpha: 0.18);
    final radius = BorderRadius.circular(16);

    return Material(
      color: const Color(0xFF27272A),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.14),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: borderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 320,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title.trim().isNotEmpty) ...[
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ) ??
                      const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
              ],
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
