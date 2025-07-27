import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;

class ConfettiSuccess extends StatefulWidget {
  final VoidCallback onComplete;
  final String message;

  const ConfettiSuccess({
    super.key,
    required this.onComplete,
    this.message = 'Success!',
  });

  @override
  State<ConfettiSuccess> createState() => _ConfettiSuccessState();
}

class _ConfettiSuccessState extends State<ConfettiSuccess> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _startAnimation();
  }

  void _startAnimation() async {
    _confettiController.play();
    
    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 4));
    
    widget.onComplete();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          children: [
            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: math.pi / 2, // Changed from Math.pi to math.pi
                maxBlastForce: 5,
                minBlastForce: 2,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.2,
                colors: const [
                  Colors.blue,
                  Colors.green,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
            
            // Success message
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF34C759),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF34C759),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}