import 'package:flutter/material.dart';
import 'dart:math' as math;

class NeonAddButton extends StatefulWidget {
  final VoidCallback onPressed;

  const NeonAddButton({super.key, required this.onPressed});

  @override
  State<NeonAddButton> createState() => _NeonAddButtonState();
}

class _NeonAddButtonState extends State<NeonAddButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.12 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = (math.sin(_controller.value * math.pi * 2) + 1) / 2;

            final gradientColors = [
              Color.lerp(Colors.blueAccent, Colors.purpleAccent, t)!,
              Color.lerp(Colors.pinkAccent, Colors.deepPurpleAccent, 1 - t)!,
            ];

            final glowColor = Color.lerp(
              Colors.pinkAccent,
              Colors.blueAccent,
              t,
            )!;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: glowColor.withOpacity(0.8),
                          blurRadius: 25,
                          spreadRadius: 6,
                        ),
                      ]
                    : [],
              ),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: widget.onPressed,
                label: const Text(
                  "Add Entry",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
