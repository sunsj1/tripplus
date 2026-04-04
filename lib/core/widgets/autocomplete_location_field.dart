import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tripplus/core/services/places_autocomplete_service.dart';
import 'package:tripplus/core/theme/app_colors.dart';
import 'package:tripplus/core/theme/app_text_styles.dart';

class AutocompleteLocationField extends StatefulWidget {
  final TextEditingController controller;
  final PlacesAutocompleteService service;
  final IconData icon;
  final Color iconColor;
  final String hint;
  final bool enabled;

  const AutocompleteLocationField({
    super.key,
    required this.controller,
    required this.service,
    required this.icon,
    required this.iconColor,
    required this.hint,
    this.enabled = true,
  });

  @override
  State<AutocompleteLocationField> createState() =>
      _AutocompleteLocationFieldState();
}

class _AutocompleteLocationFieldState
    extends State<AutocompleteLocationField> {
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<PlacePrediction> _suggestions = [];
  Timer? _debounce;
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!_isSelecting) _removeOverlay();
      });
    }
  }

  void _onTextChanged() {
    if (_isSelecting) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchSuggestions(widget.controller.text);
    });
  }

  Future<void> _fetchSuggestions(String input) async {
    if (input.trim().length < 2) {
      _removeOverlay();
      return;
    }

    final results = await widget.service.getSuggestions(input);
    if (!mounted) return;

    setState(() => _suggestions = results);
    if (results.isNotEmpty && _focusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onSelect(PlacePrediction prediction) {
    _isSelecting = true;
    widget.controller.text = prediction.mainText;
    widget.controller.selection = TextSelection.collapsed(
      offset: prediction.mainText.length,
    );
    _removeOverlay();
    _focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      _isSelecting = false;
    });
  }

  OverlayEntry _buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (_) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 8,
            shadowColor: Colors.black.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
            color: AppColors.surface,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _suggestions
                    .take(5)
                    .map((p) => _SuggestionTile(
                          prediction: p,
                          onTap: () => _onSelect(p),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(widget.icon, size: 20, color: widget.iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
                style: AppTextStyles.titleSmall,
              ),
            ),
            if (widget.controller.text.isNotEmpty && _focusNode.hasFocus)
              GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  _removeOverlay();
                },
                child: const Icon(Icons.close,
                    size: 18, color: AppColors.textTertiary),
              ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final PlacePrediction prediction;
  final VoidCallback onTap;

  const _SuggestionTile({required this.prediction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.location_on_outlined,
                  size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prediction.mainText,
                    style: AppTextStyles.titleSmall.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (prediction.secondaryText.isNotEmpty)
                    Text(
                      prediction.secondaryText,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
