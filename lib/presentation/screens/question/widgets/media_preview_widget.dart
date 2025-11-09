
// media_preview_widget.dart
import 'package:flutter/material.dart' show Border, BorderRadius, BoxDecoration, BuildContext, Column, Container, EdgeInsets, Expanded, Icon, IconButton, Icons, Key, Row, SizedBox, StatelessWidget, VoidCallback, Widget;
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_dimens.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';

enum MediaType { audio, video }

class MediaPreviewWidget extends StatelessWidget {
  final MediaType type;
  final String path;
  final VoidCallback onDelete;

  const MediaPreviewWidget({
    Key? key,
    required this.type,
    required this.path,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              type == MediaType.audio ? Icons.audiotrack : Icons.video_library,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type == MediaType.audio ? 'Audio Recorded' : 'Video Recorded',
                  style: AppTextStyles.body1,
                ),
                Text(
                  'Tap to play',
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.accent),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
      
    