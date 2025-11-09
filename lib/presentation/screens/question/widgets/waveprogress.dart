// lib/presentation/widgets/wave_progress_bar.dart
import 'package:flutter/material.dart';

class WaveProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final int segments;
  final double height;
  final double waveHeight;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;

  const WaveProgressBar({
    Key? key,
    required this.progress,
    this.segments = 15,
    this.height = 26,
    this.waveHeight = 6.0,
    this.activeColor = const Color(0xFF6C63FF),
    this.inactiveColor = const Color(0xFF3A3A3A),
    this.duration = const Duration(milliseconds: 420),
  })  : assert(progress >= 0 && progress <= 1.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: progress),
        duration: duration,
        curve: Curves.easeInOut,
        builder: (context, animatedValue, child) {
          return CustomPaint(
            size: Size(double.infinity, height),
            painter: _WaveProgressPainter(
              progress: animatedValue,
              segments: segments,
              waveHeight: waveHeight,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          );
        },
      ),
    );
  }
}

class _WaveProgressPainter extends CustomPainter {
  final double progress;
  final int segments;
  final double waveHeight;
  final Color activeColor;
  final Color inactiveColor;

  _WaveProgressPainter({
    required this.progress,
    required this.segments,
    required this.waveHeight,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final waveWidth = size.width / segments;
    final centerY = size.height / 2;

    final fullSegments = (progress * segments).floor();
    final partial = (progress * segments) - fullSegments;

    for (int i = 0; i < segments; i++) {
      final xStart = i * waveWidth;
      final xEnd = xStart + waveWidth;

      final isActive = i < fullSegments;
      final isPartial = i == fullSegments && partial > 0;

      paint.color = isActive
          ? activeColor
          : (isPartial ? Color.lerp(inactiveColor, activeColor, partial)! : inactiveColor);

      final path = Path();
      final steps = 6;
      final stepWidth = waveWidth / steps;
      path.moveTo(xStart, centerY);

      for (int s = 0; s <= steps; s++) {
        final x = xStart + s * stepWidth;
        final up = s % 2 == 0;
        final y = centerY + (up ? -waveHeight : waveHeight);

        if (s == 0) {
          path.lineTo(x, y);
        } else {
          final prevX = x - stepWidth;
          final prevUp = (s - 1) % 2 == 0;
          final prevY = centerY + (prevUp ? -waveHeight : waveHeight);
          final cx = (prevX + x) / 2;
          final cy = (prevY + y) / 2;
          path.quadraticBezierTo(cx, cy, x, y);
        }
      }

      if (isPartial) {
        final partialX = xStart + waveWidth * partial;
        canvas.save();
        canvas.clipRect(Rect.fromLTWH(xStart, 0, partialX - xStart, size.height));
        canvas.drawPath(path, paint);
        canvas.restore();

        final remainingPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = paint.strokeWidth
          ..strokeCap = paint.strokeCap
          ..isAntiAlias = paint.isAntiAlias
          ..color = inactiveColor;

        canvas.save();
        canvas.clipRect(Rect.fromLTWH(partialX, 0, xEnd - partialX, size.height));
        canvas.drawPath(path, remainingPaint);
        canvas.restore();
      } else {
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WaveProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
