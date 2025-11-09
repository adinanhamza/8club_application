

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimens.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/presentation/screens/question/widgets/audio_recorder_widget.dart';
import 'package:flutter_application_1/presentation/screens/question/widgets/media_preview_widget.dart';
import 'package:flutter_application_1/presentation/screens/question/widgets/video_recorder_widget.dart';
import 'package:flutter_application_1/presentation/screens/question/widgets/waveform_widget.dart'; // waveform for recorder
import 'package:flutter_application_1/presentation/screens/question/widgets/waveprogress.dart';
// ogress bar
import 'package:flutter_application_1/presentation/widgets/custom_button.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _audioPath;
  String? _videoPath;
  bool _isRecordingAudio = false;
  bool _isRecordingVideo = false;

  // Example flow state for the wave:
  int _currentQuestionIndex = 1;
  final int _totalQuestions = 15;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  double get _progressValue => (_currentQuestionIndex / _totalQuestions).clamp(0.0, 1.0);

  void _goToNext() {
    if (_currentQuestionIndex < _totalQuestions) {
      setState(() => _currentQuestionIndex++);
      // Optionally delay navigation to next screen / question until animation completes
    } else {
      // last question — submit or navigate away
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completed all questions!')),
      );
    }
  }

  void _goBack() {
    if (_currentQuestionIndex > 1) {
      setState(() => _currentQuestionIndex--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAudio = _audioPath != null;
    final hasVideo = _videoPath != null;
    final showRecordButtons = !hasAudio || !hasVideo;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with persistent wave progress at top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: _goBack,
                  ),

                  const SizedBox(width: 8),

                  // Expand the wave progress to fill available space
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question $_currentQuestionIndex',
                          style: AppTextStyles.heading2,
                        ),
                        const SizedBox(height: 6),
                        // Use WaveProgressBar here (progress 0..1). WaveformWidget is for recorder.
                        WaveProgressBar(
                          progress: _progressValue, // 0..1
                          segments: _totalQuestions,
                          height: 26,
                          waveHeight: 6,
                          activeColor: const Color(0xFF6C63FF),
                          inactiveColor: const Color(0xFF3A3A3A),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                ),
                child: Column(
                  children: [
                    // Text Answer Field
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadius,
                        ),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: TextField(
                        controller: _textController,
                        maxLines: 8,
                        maxLength: 600,
                        style: AppTextStyles.body1,
                        decoration: InputDecoration(
                          hintText: 'Type your answer here...',
                          hintStyle: AppTextStyles.body2,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(
                            AppDimensions.paddingMedium,
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {}); // can be used to enable next
                        },
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    // Recording Area & preview logic (kept same as before)
                    if (_isRecordingAudio)
                      AudioRecorderWidget(
                        onAudioRecorded: (path) {
                          setState(() {
                            _audioPath = path;
                            _isRecordingAudio = false;
                          });
                        },
                        onCancel: () {
                          setState(() => _isRecordingAudio = false);
                        },
                      )
                    else if (_isRecordingVideo)
                      VideoRecorderWidget(
                        onVideoRecorded: (path) {
                          setState(() {
                            _videoPath = path;
                            _isRecordingVideo = false;
                          });
                        },
                        onCancel: () {
                          setState(() => _isRecordingVideo = false);
                        },
                      )
                    else ...[
                      if (hasAudio)
                        MediaPreviewWidget(
                          type: MediaType.audio,
                          path: _audioPath!,
                          onDelete: () {
                            setState(() => _audioPath = null);
                          },
                        ),
                      if (hasAudio && hasVideo) const SizedBox(height: AppDimensions.paddingMedium),
                      if (hasVideo)
                        MediaPreviewWidget(
                          type: MediaType.video,
                          path: _videoPath!,
                          onDelete: () {
                            setState(() => _videoPath = null);
                          },
                        ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Actions
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Recording Buttons
                  if (showRecordButtons && !_isRecordingAudio && !_isRecordingVideo)
                    Row(
                      children: [
                        if (!hasAudio) ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() => _isRecordingAudio = true);
                              },
                              icon: const Icon(Icons.mic, color: AppColors.primary),
                              label: const Text(
                                'Record Audio',
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadius,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (!hasVideo) const SizedBox(width: AppDimensions.paddingMedium),
                        ],
                        if (!hasVideo)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() => _isRecordingVideo = true);
                              },
                              icon: const Icon(Icons.videocam, color: AppColors.primary),
                              label: const Text(
                                'Record Video',
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadius,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                  if (showRecordButtons && !_isRecordingAudio && !_isRecordingVideo)
                    const SizedBox(height: AppDimensions.paddingMedium),

                  // Next Button with internal wave update
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Next',
                      onPressed: _canProceed()
                          ? () {
                              // Advance the question (wave auto animates because progress changed)
                              _goToNext();
                              // Keep your original behavior (e.g., navigation) if needed
                            }
                          : null,
                      isEnabled: _canProceed(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    return _textController.text.trim().isNotEmpty || _audioPath != null || _videoPath != null;
  }
}
