// // lib/presentation/screens/experience_selection/experience_selection_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/core/constants/app_colors.dart';
// import 'package:flutter_application_1/core/constants/app_dimens.dart';
// import 'package:flutter_application_1/core/constants/app_text_styles.dart';
// import 'package:flutter_application_1/presentation/screens/experience_selection/bloc/experiance_bloc.dart';
// import 'package:flutter_application_1/presentation/screens/experience_selection/bloc/experiance_event.dart';
// import 'package:flutter_application_1/presentation/screens/experience_selection/bloc/experiance_state.dart';
// import 'package:flutter_application_1/presentation/screens/experience_selection/widgets/experience_card.dart';
// import 'package:flutter_application_1/presentation/widgets/custom_button.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ExperienceSelectionScreen extends StatefulWidget {
//   const ExperienceSelectionScreen({Key? key}) : super(key: key);

//   @override
//   State<ExperienceSelectionScreen> createState() => _ExperienceSelectionScreenState();
// }

// class _ExperienceSelectionScreenState extends State<ExperienceSelectionScreen> {
//   final TextEditingController _textController = TextEditingController();

//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: BlocConsumer<ExperienceBloc, ExperienceState>(
//           listener: (context, state) {
//             if (state is ExperienceError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: AppColors.accent,
//                 ),
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state is ExperienceLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   color: AppColors.primary,
//                 ),
//               );
//             }

//             if (state is ExperienceLoaded) {
//               final hasSelection = state.experiences.any((exp) => exp.isSelected);
              
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Top Bar with Back, Progress Wave, Close
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     child: Row(
//                       children: [
//                         // Back Button
//                         IconButton(
//                           icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
//                           onPressed: () => Navigator.pop(context),
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                         ),
                        
//                         const SizedBox(width: 16),
                        
//                         // Animated Wave Progress Indicator
//                         Expanded(
//                           child: CustomPaint(
//                             size: const Size(double.infinity, 20),
//                             painter: WaveProgressPainter(progress: 0.3), // 3 out of 10
//                           ),
//                         ),
                        
//                         const SizedBox(width: 16),
                        
//                         // Close Button
//                         IconButton(
//                           icon: const Icon(Icons.close, color: Colors.white, size: 24),
//                           onPressed: () => Navigator.pop(context),
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // Question Text
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Text(
//                       'What kind of hotspots do you want to host?',
//                       style: AppTextStyles.heading1.copyWith(
//                         fontSize: 32,
//                         fontWeight: FontWeight.w600,
//                         height: 1.2,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 32),

//                   // Experience Stamp Cards (Horizontal Scroll)
//                  // In experience_selection_screen.dart - Update the ListView.builder section:

// // Experience Stamp Cards (Horizontal Scroll)
// SizedBox(
//   height: 140, // Increased height for wave effect
//   child: ListView.builder(
//     scrollDirection: Axis.horizontal,
//     padding: const EdgeInsets.symmetric(horizontal: 24),
//     itemCount: state.experiences.length,
//     itemBuilder: (context, index) {
//       return ExperienceCard(
//         experience: state.experiences[index],
//         index: index, // Pass index for wave calculation
//         onToggle: () {
//           context.read<ExperienceBloc>().add(
//                 ToggleExperienceSelection(
//                   state.experiences[index].id,
//                 ),
//               );
//         },
//       );
      
//     },
//   ),
// ),

//                   const SizedBox(height: 24),

//                   // Description Text Field
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1A1A1A),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: TextField(
//                         controller: _textController,
//                         maxLines: 5,
//                         maxLength: 250,
//                         style: AppTextStyles.body1.copyWith(fontSize: 16),
//                         decoration: InputDecoration(
//                           hintText: 'Describe your perfect hotspot',
//                           hintStyle: AppTextStyles.body2.copyWith(
//                             color: const Color(0xFF4A4A4A),
//                             fontSize: 16,
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.all(20),
//                           counterStyle: AppTextStyles.body2.copyWith(
//                             color: const Color(0xFF4A4A4A),
//                             fontSize: 12,
//                           ),
//                         ),
//                         onChanged: (text) {
//                           final selectedExp = state.experiences.firstWhere(
//                             (exp) => exp.isSelected,
//                             orElse: () => state.experiences.first,
//                           );
//                           context.read<ExperienceBloc>().add(
//                                 UpdateExperienceText(selectedExp.id, text),
//                               );
//                         },
//                       ),
//                     ),
//                   ),

//                   const Spacer(),

//                   // Next Button
//                   Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 56,
//                       child: ElevatedButton(
//                         onPressed: hasSelection
//                             ? () {
//                                 context.read<ExperienceBloc>().add(
//                                       ProceedToNextScreen(),
//                                     );
//                                 Navigator.pushNamed(context, '/question');
//                               }
//                             : null,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: hasSelection 
//                               ? const Color(0xFF6C63FF) 
//                               : const Color(0xFF2A2A2A),
//                           disabledBackgroundColor: const Color(0xFF2A2A2A),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Next',
//                               style: AppTextStyles.button.copyWith(
//                                 fontSize: 16,
//                                 color: hasSelection ? Colors.white : const Color(0xFF4A4A4A),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Icon(
//                               Icons.arrow_forward,
//                               color: hasSelection ? Colors.white : const Color(0xFF4A4A4A),
//                               size: 20,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }

//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
// }

// // Wave Progress Painter
// class WaveProgressPainter extends CustomPainter {
//   final double progress;

//   WaveProgressPainter({required this.progress});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..strokeCap = StrokeCap.round;

//     final path = Path();
//     final waveWidth = size.width / 10; // 10 waves
//     final amplitude = 4.0;

//     // Draw waves
//     for (int i = 0; i < 10; i++) {
//       final x = i * waveWidth;
//       final isActive = i < (progress * 10).round();
      
//       paint.color = isActive ? const Color(0xFF6C63FF) : const Color(0xFF3A3A3A);
      
//       path.reset();
//       path.moveTo(x, size.height / 2);
      
//       // Create wave pattern
//       for (double j = 0; j < waveWidth; j += 2) {
//         final y = size.height / 2 + amplitude * (j % 4 == 0 ? 1 : -1);
//         path.lineTo(x + j, y);
//       }
      
//       canvas.drawPath(path, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(WaveProgressPainter oldDelegate) => oldDelegate.progress != progress;
// }

// lib/presentation/screens/experience_selection/experience_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimens.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/presentation/screens/experience_selection/bloc/experiance_bloc.dart';
import 'package:flutter_application_1/presentation/screens/experience_selection/bloc/experiance_event.dart';
import 'package:flutter_application_1/presentation/screens/experience_selection/bloc/experiance_state.dart';
import 'package:flutter_application_1/presentation/screens/experience_selection/widgets/experience_card.dart';
import 'package:flutter_application_1/presentation/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExperienceSelectionScreen extends StatefulWidget {
  const ExperienceSelectionScreen({Key? key}) : super(key: key);

  @override
  State<ExperienceSelectionScreen> createState() => _ExperienceSelectionScreenState();
}

class _ExperienceSelectionScreenState extends State<ExperienceSelectionScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();

  int _currentFrame = 4;
  final int _totalFrames = 15;

  late AnimationController _animController;
  late Animation<double> _progressAnimation;
  double _progressValue = 0.0; // 0..1

  @override
  void initState() {
    super.initState();
    _progressValue = _currentFrame / _totalFrames;
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    _progressAnimation = Tween<double>(begin: _progressValue, end: _progressValue).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {}); 
      });
  }

  @override
  void dispose() {
    _textController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _animateToFrame(int newFrame, {VoidCallback? onComplete}) {
    newFrame = newFrame.clamp(1, _totalFrames);
    final old = _progressValue;
    final target = newFrame / _totalFrames;

    _progressAnimation = Tween<double>(begin: old, end: target).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _animController
      ..reset()
      ..forward().whenCompleteOrCancel(() {
        _progressValue = target;
        _currentFrame = newFrame;
        if (onComplete != null) onComplete();
      });
  }

  void _onNextPressed(bool hasSelection) {
    if (!hasSelection) return;

 
    final nextFrame = (_currentFrame + 1).clamp(1, _totalFrames);
    _animateToFrame(nextFrame, onComplete: () {
     
      Navigator.pushNamed(context, '/question');
    });
  }

  void _onBackPressed() {
    if (_currentFrame > 1) {
      _animateToFrame(_currentFrame - 1);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final animatedProgress = _progressAnimation.value;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<ExperienceBloc, ExperienceState>(
          listener: (context, state) {
            if (state is ExperienceError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.accent,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ExperienceLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (state is ExperienceLoaded) {
              final hasSelection = state.experiences.any((exp) => exp.isSelected);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                     
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          onPressed: _onBackPressed,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),

                        const SizedBox(width: 16),

                       
                        Expanded(
                          child: SizedBox(
                            height: 26,
                            child: CustomPaint(
                              painter: WaveProgressPainter(
                                progress: animatedProgress,
                                segments: _totalFrames,
                                waveHeight: 6,
                                activeColor: const Color(0xFF6C63FF),
                                inactiveColor: const Color(0xFF3A3A3A),
                              ),
                              size: const Size(double.infinity, 26),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                       
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 24),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'What kind of hotspots do you want to host?',
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: state.experiences.length,
                      itemBuilder: (context, index) {
                        return ExperienceCard(
                          experience: state.experiences[index],
                          index: index, 
                          onToggle: () {
                            context.read<ExperienceBloc>().add(
                                  ToggleExperienceSelection(
                                    state.experiences[index].id,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _textController,
                        maxLines: 5,
                        maxLength: 250,
                        style: AppTextStyles.body1.copyWith(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Describe your perfect hotspot',
                          hintStyle: AppTextStyles.body2.copyWith(
                            color: const Color(0xFF4A4A4A),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                          counterStyle: AppTextStyles.body2.copyWith(
                            color: const Color(0xFF4A4A4A),
                            fontSize: 12,
                          ),
                        ),
                        onChanged: (text) {
                          final selectedExp = state.experiences.firstWhere(
                            (exp) => exp.isSelected,
                            orElse: () => state.experiences.first,
                          );
                          context.read<ExperienceBloc>().add(
                                UpdateExperienceText(selectedExp.id, text),
                              );
                        },
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Next Button
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: hasSelection
                            ? () => _onNextPressed(hasSelection)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasSelection ? const Color(0xFF6C63FF) : const Color(0xFF2A2A2A),
                          disabledBackgroundColor: const Color(0xFF2A2A2A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: AppTextStyles.button.copyWith(
                                fontSize: 16,
                                color: hasSelection ? Colors.white : const Color(0xFF4A4A4A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: hasSelection ? Colors.white : const Color(0xFF4A4A4A),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}


class WaveProgressPainter extends CustomPainter {

  final double progress;
  final int segments;
  final double waveHeight;
  final Color activeColor;
  final Color inactiveColor;

  WaveProgressPainter({
    required this.progress,
    this.segments = 10,
    this.waveHeight = 4.0,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 3.0..strokeCap = StrokeCap.round;
    final waveWidth = size.width / segments;
    final centerY = size.height / 2;

  
    final fullSegments = (progress * segments).floor();
    final partial = (progress * segments) - fullSegments;

    for (int i = 0; i < segments; i++) {
      final xStart = i * waveWidth;
      final xEnd = xStart + waveWidth;
      final isActive = i < fullSegments;
      final isPartial = i == fullSegments && partial > 0;


      if (isActive) {
        paint.color = activeColor;
      } else if (isPartial) {
      
        paint.color = Color.lerp(inactiveColor, activeColor, partial)!;
      } else {
        paint.color = inactiveColor;
      }

      
      final p = Path();
      final segmentStep = waveWidth / 6; 
      p.moveTo(xStart, centerY);

     
      for (int step = 0; step <= 6; step++) {
        final x = xStart + step * segmentStep;
        final up = (step % 2 == 0);
        final y = centerY + (up ? -waveHeight : waveHeight);
       
        if (step == 0) {
          p.lineTo(x, y);
        } else {
          final prevX = x - segmentStep;
          final prevY = ( (step - 1) % 2 == 0 ) ? centerY - waveHeight : centerY + waveHeight;
          final cx = (prevX + x) / 2;
          final cy = (prevY + y) / 2;
          p.quadraticBezierTo(cx, cy, x, y);
        }
      }

    
      if (isPartial) {
       
        final partialX = xStart + waveWidth * partial;
       
        canvas.save();
        canvas.clipRect(Rect.fromLTWH(xStart, 0, partialX - xStart, size.height));
        canvas.drawPath(p, paint);
        canvas.restore();

        
        final remainingPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0
          ..strokeCap = StrokeCap.round
          ..color = inactiveColor;
        canvas.save();
        canvas.clipRect(Rect.fromLTWH(partialX, 0, xEnd - partialX, size.height));
        canvas.drawPath(p, remainingPaint);
        canvas.restore();
      } else {
  
        canvas.drawPath(p, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant WaveProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.segments != segments ||
        oldDelegate.waveHeight != waveHeight ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
