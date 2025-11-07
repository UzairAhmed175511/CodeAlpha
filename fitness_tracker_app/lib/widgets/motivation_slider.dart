import 'dart:async';
import 'package:flutter/material.dart';

class MotivationSlider extends StatefulWidget {
  const MotivationSlider({super.key});

  @override
  State<MotivationSlider> createState() => _MotivationSliderState();
}

class _MotivationSliderState extends State<MotivationSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _quotes = [
    "Push yourself, because no one else is going to do it for you.",
    "The body achieves what the mind believes.",
    "Don’t limit your challenges, challenge your limits!",
    "It always seems impossible until it’s done.",
    "Small steps every day lead to big results.",
    "Fall in love with taking care of yourself.",
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Auto slide every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % _quotes.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _quotes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, color: Colors.white, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    _quotes[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
