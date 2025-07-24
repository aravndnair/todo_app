import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingElements extends StatelessWidget {
  final AnimationController controller;

  const FloatingElements({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          ...List.generate(8, (index) {
            return AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final double animationValue = controller.value;
                final double delay = index * 0.125;
                final double adjustedValue = (animationValue + delay) % 1.0;
                
                return Positioned(
                  left: _getXPosition(index, adjustedValue, context),
                  top: _getYPosition(index, adjustedValue, context),
                  child: Transform.rotate(
                    angle: adjustedValue * 2 * math.pi,
                    child: Container(
                      width: _getSize(index),
                      height: _getSize(index),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getColor(index),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  double _getXPosition(int index, double animationValue, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseX = (index * 50.0) % screenWidth;
    final offsetX = math.sin(animationValue * 2 * math.pi + index) * 30;
    return (baseX + offsetX).clamp(0, screenWidth - 20);
  }

  double _getYPosition(int index, double animationValue, BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final baseY = (index * 80.0) % screenHeight;
    final offsetY = math.cos(animationValue * 2 * math.pi + index) * 40;
    return (baseY + offsetY).clamp(0, screenHeight - 20);
  }

  double _getSize(int index) {
    return (8 + (index % 3) * 4).toDouble();
  }

  Color _getColor(int index) {
    final colors = [
      const Color(0xFF007AFF).withOpacity(0.1),
      const Color(0xFF34C759).withOpacity(0.08),
      const Color(0xFFFF9500).withOpacity(0.08),
      const Color(0xFFAF52DE).withOpacity(0.08),
    ];
    return colors[index % colors.length];
  }
}