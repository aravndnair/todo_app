import 'package:flutter/material.dart';

class SuccessAnimation extends StatefulWidget {
  final VoidCallback onComplete;

  const SuccessAnimation({
    super.key,
    required this.onComplete,
  });

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _checkController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeInOut,
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await _scaleController.forward();
    await _checkController.forward();
    
    // Wait a moment to show the success state
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Fade out
    await _scaleController.reverse();
    
    widget.onComplete();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _checkAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF34C759),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF34C759).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(60, 60),
                      painter: CheckMarkPainter(_checkAnimation.value),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CheckMarkPainter extends CustomPainter {
  final double animationValue;

  CheckMarkPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Check mark path
    final startX = size.width * 0.2;
    final startY = size.height * 0.5;
    final midX = size.width * 0.45;
    final midY = size.height * 0.7;
    final endX = size.width * 0.8;
    final endY = size.height * 0.3;

    path.moveTo(startX, startY);
    
    if (animationValue <= 0.5) {
      // First part of check mark
      final progress = animationValue * 2;
      final currentX = startX + (midX - startX) * progress;
      final currentY = startY + (midY - startY) * progress;
      path.lineTo(currentX, currentY);
    } else {
      // Complete first part and animate second part
      path.lineTo(midX, midY);
      final progress = (animationValue - 0.5) * 2;
      final currentX = midX + (endX - midX) * progress;
      final currentY = midY + (endY - midY) * progress;
      path.lineTo(currentX, currentY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CheckMarkPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}