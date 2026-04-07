import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';
import 'package:tripplus/features/community/data/community_photo_compress.dart';
import 'package:tripplus/features/community/domain/models/station_community_submit_input.dart';
import 'package:tripplus/features/community/presentation/widgets/station_report_handle_bar.dart';
import 'package:tripplus/features/community/presentation/widgets/station_report_modal_container.dart';
import 'package:tripplus/features/community/presentation/widgets/station_report_step_amenities.dart';
import 'package:tripplus/features/community/presentation/widgets/station_report_step_intro.dart';
import 'package:tripplus/features/community/presentation/widgets/station_report_step_photo.dart';
import 'package:tripplus/features/community/presentation/widgets/station_report_step_pulse.dart';
import 'package:tripplus/features/community/presentation/widgets/station_report_step_rating.dart';
import 'package:tripplus/features/community/presentation/widgets/station_report_step_review.dart';
import 'package:tripplus/features/community/presentation/widgets/station_report_step_washroom.dart';
import 'package:tripplus/features/community/presentation/widgets/station_report_wizard_footer.dart';

/// Opens the multi-step report flow. Returns `true` if a report was stored.
Future<bool?> showStationReportSheet({
  required BuildContext context,
  required ChargingStation station,
  required String stationKey,
  required String userId,
  required String displayName,
  required Future<Either<String, Unit>> Function(
    StationCommunitySubmitInput input,
  )
  onSubmit,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _StationReportSheetBody(
      station: station,
      stationKey: stationKey,
      userId: userId,
      displayName: displayName,
      onSubmit: onSubmit,
    ),
  );
}

class _StationReportSheetBody extends StatefulWidget {
  final ChargingStation station;
  final String stationKey;
  final String userId;
  final String displayName;
  final Future<Either<String, Unit>> Function(StationCommunitySubmitInput input)
  onSubmit;

  const _StationReportSheetBody({
    required this.station,
    required this.stationKey,
    required this.userId,
    required this.displayName,
    required this.onSubmit,
  });

  @override
  State<_StationReportSheetBody> createState() =>
      _StationReportSheetBodyState();
}

class _StationReportSheetBodyState extends State<_StationReportSheetBody> {
  static const _lastPage = 6;

  final _picker = ImagePicker();
  final _pageController = PageController();
  final _costController = TextEditingController();
  final _commentController = TextEditingController();

  int _page = 0;
  bool _busy = false;

  int _rating = 4;
  String _condition = 'working';
  bool _fastCharger = false;
  final Set<String> _amenities = {};
  bool? _washroomAvailable;
  bool? _washroomClean;
  bool? _womenFriendlyWashroom;
  Uint8List? _photoJpeg;

  @override
  void dispose() {
    _pageController.dispose();
    _costController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final next = (_page + delta).clamp(0, _lastPage);
    setState(() => _page = next);
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  bool get _isLikelyIosSimulator {
    if (!Platform.isIOS) return false;
    return Platform.environment.containsKey('SIMULATOR_DEVICE_NAME') ||
        Platform.environment.containsKey('SIMULATOR_UDID');
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      if (source == ImageSource.camera && _isLikelyIosSimulator) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Camera is not available in iOS Simulator. Use Gallery.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final x = await _picker.pickImage(
        source: source,
        maxWidth: 2000,
        maxHeight: 2000,
      );
      if (x == null) return;
      final file = File(x.path);
      final compressed = await compressReportPhotoFile(file);
      if (!mounted) return;
      if (compressed == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not use that image. Pick one under 5 MB or try another.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      setState(() => _photoJpeg = compressed);
    } on PlatformException catch (e) {
      if (!mounted) return;
      final isPermissionError =
          e.code.contains('denied') || e.code.contains('permission');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isPermissionError
                ? 'Photo permission denied. Please allow it in app settings.'
                : 'Photo access unavailable on this device.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open image picker. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _conditionLabel() {
    return switch (_condition) {
      'down' => 'Offline or blocked',
      'issues' => 'Mixed / issues',
      _ => 'Smooth / usable',
    };
  }

  String _washroomSummary() {
    if (_washroomAvailable == null) return 'Washroom not specified';
    if (_washroomAvailable == false) return 'No washroom';
    final clean = _washroomClean == true
        ? 'clean'
        : _washroomClean == false
        ? 'not clean'
        : 'cleanliness not specified';
    final w = _womenFriendlyWashroom == true
        ? 'women-friendly'
        : _womenFriendlyWashroom == false
        ? 'women access: no or unsure'
        : 'women access not specified';
    return 'Washroom · $clean · $w';
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    final costRaw = _costController.text.trim();
    final input = StationCommunitySubmitInput(
      stationKey: widget.stationKey,
      stationNameSnapshot: widget.station.name,
      reporterUserId: widget.userId,
      reporterDisplayName: widget.displayName,
      rating: _rating,
      condition: _condition,
      availableAmenityLabels: _amenities.toList()..sort(),
      washroomAvailable: _washroomAvailable,
      washroomClean: _washroomAvailable == true ? _washroomClean : null,
      womenFriendlyWashroom: _washroomAvailable == true
          ? _womenFriendlyWashroom
          : null,
      photoBase64: _photoJpeg != null ? encodeJpegBase64(_photoJpeg!) : null,
      comment: _commentController.text.trim().isEmpty
          ? null
          : _commentController.text.trim(),
      costPerKwh: costRaw.isEmpty ? null : costRaw,
      fastChargerAvailable: _fastCharger,
    );
    final result = await widget.onSubmit(input);
    if (!mounted) return;
    setState(() => _busy = false);
    result.fold((msg) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
      );
    }, (_) => Navigator.of(context).pop(true));
  }

  @override
  Widget build(BuildContext context) {
    return StationReportModalContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const StationReportHandleBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                    _page == 0 ? 'Community pulse' : 'Station pulse',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleSmall,
                  ),
                ),
                IconButton(
                  onPressed: _busy ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _page = i),
              children: [
                StationReportStepIntro(
                  stationName: widget.station.name,
                  onBegin: () => _go(1),
                ),
                StationReportStepRating(
                  rating: _rating,
                  onRating: (n) => setState(() => _rating = n),
                ),
                StationReportStepPulse(
                  condition: _condition,
                  onCondition: (c) => setState(() => _condition = c),
                  costController: _costController,
                  fastChargerAvailable: _fastCharger,
                  onFastCharger: (v) => setState(() => _fastCharger = v),
                ),
                StationReportStepAmenities(
                  selectedLabels: _amenities,
                  onToggle: (label, v) => setState(() {
                    if (v) {
                      _amenities.add(label);
                    } else {
                      _amenities.remove(label);
                    }
                  }),
                ),
                StationReportStepWashroom(
                  washroomAvailable: _washroomAvailable,
                  onWashroomAvailable: (v) =>
                      setState(() => _washroomAvailable = v),
                  washroomClean: _washroomClean,
                  onWashroomClean: (v) => setState(() => _washroomClean = v),
                  womenFriendlyWashroom: _womenFriendlyWashroom,
                  onWomenFriendly: (v) =>
                      setState(() => _womenFriendlyWashroom = v),
                ),
                StationReportStepPhoto(
                  jpegBytes: _photoJpeg,
                  onPickGallery: () => _pickPhoto(ImageSource.gallery),
                  onPickCamera: () => _pickPhoto(ImageSource.camera),
                  onClear: () => setState(() => _photoJpeg = null),
                ),
                StationReportStepReview(
                  rating: _rating,
                  conditionLabel: _conditionLabel(),
                  amenityCount: _amenities.length,
                  washroomSummary: _washroomSummary(),
                  hasPhoto: _photoJpeg != null,
                  commentController: _commentController,
                ),
              ],
            ),
          ),
          if (_page > 0)
            StationReportWizardFooter(
              stepIndex: _page - 1,
              stepCount: _lastPage,
              canBack: _page > 1,
              busy: _busy,
              primaryLabel: _page == _lastPage ? 'Submit pulse' : 'Next',
              onBack: () => _go(-1),
              onPrimary: () {
                if (_page == _lastPage) {
                  _submit();
                } else {
                  _go(1);
                }
              },
            ),
        ],
      ),
    );
  }
}
