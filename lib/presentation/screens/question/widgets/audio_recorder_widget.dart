// lib/presentation/screens/question/widgets/audio_recorder_widget.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimens.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/presentation/screens/question/widgets/waveform_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderWidget extends StatefulWidget {
  final Function(String) onAudioRecorded;
  final VoidCallback onCancel;

  const AudioRecorderWidget({
    Key? key,
    required this.onAudioRecorded,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final AudioRecorder _recorder = AudioRecorder(); // FIXED: Use AudioRecorder
  bool _isRecording = false;
  Duration _duration = Duration.zero;
  Timer? _timer;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _startRecording();
  }

  Future<void> _startRecording() async {
    try {
      final hasPerm = await _recorder.hasPermission();
      if (!hasPerm) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied')),
        );
        widget.onCancel();
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final path = '${directory.path}/$fileName';

      // FIXED: Use RecordConfig
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      if (!mounted) return;
      setState(() {
        _isRecording = true;
        _filePath = path;
        _duration = Duration.zero;
      });

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() => _duration = Duration(seconds: timer.tick));
      });
    } catch (e, st) {
      debugPrint('startRecording error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start recording: $e')),
        );
        widget.onCancel();
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      _timer?.cancel();
      final path = await _recorder.stop();
      
      if (!mounted) return;
      setState(() {
        _isRecording = false;
      });

      final finalPath = path ?? _filePath;
      if (finalPath != null && await File(finalPath).exists()) {
        widget.onAudioRecorded(finalPath);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recording failed or file missing')),
          );
        }
      }
    } catch (e, st) {
      debugPrint('stopRecording error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to stop recording: $e')),
        );
      }
    }
  }

  Future<void> _cancelRecording() async {
    try {
      _timer?.cancel();
      try {
        await _recorder.stop();
      } catch (_) {}
      
      if (_filePath != null) {
        final f = File(_filePath!);
        if (await f.exists()) await f.delete();
      }
    } catch (e) {
      debugPrint('cancelRecording error: $e');
    } finally {
      widget.onCancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose(); // FIXED: dispose the recorder
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          WaveformWidget(isRecording: _isRecording),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            _formatDuration(_duration),
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.accent),
                iconSize: 32,
                onPressed: _cancelRecording,
              ),
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.stop, color: Colors.white),
                  iconSize: 32,
                  onPressed: _stopRecording,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}