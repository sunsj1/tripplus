import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/community/data/community_photo_compress.dart';

class StationReportStepPhoto extends StatelessWidget {
  final Uint8List? jpegBytes;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback onClear;

  const StationReportStepPhoto({
    super.key,
    required this.jpegBytes,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'One photo (optional)',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Max ${maxPickBytes ~/ (1024 * 1024)} MB from gallery. We shrink it so it fits safely.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Material(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: onPickGallery,
                borderRadius: BorderRadius.circular(18),
                child: jpegBytes == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 48,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Tap to add',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(
                              jpegBytes!,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton.filled(
                                onPressed: onClear,
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Colors.black.withValues(alpha: 0.45),
                                ),
                                icon: const Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPickGallery,
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: const Text('Gallery'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPickCamera,
                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: const Text('Camera'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
