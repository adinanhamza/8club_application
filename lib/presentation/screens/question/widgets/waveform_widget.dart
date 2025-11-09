// lib/presentation/screens/question/widgets/waveform_widget.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class WaveformWidget extends StatefulWidget {
  final bool isRecording;

  const WaveformWidget({
    Key? key,
    required this.isRecording,
  }) : super(key: key);

  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _amplitudes = List.generate(50, (index) => 0.0);
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      if (widget.isRecording && mounted) {
        setState(() {
          _amplitudes.removeAt(0);
          _amplitudes.add(_random.nextDouble());
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: CustomPaint(
        painter: WaveformPainter(amplitudes: _amplitudes),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;

  WaveformPainter({required this.amplitudes});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / amplitudes.length;

    for (var i = 0; i < amplitudes.length; i++) {
      final barHeight = amplitudes[i] * size.height * 0.8;
      final x = i * barWidth + barWidth / 2;
      final y = (size.height - barHeight) / 2;

      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) => true;
}