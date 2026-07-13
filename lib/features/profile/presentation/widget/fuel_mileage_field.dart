import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journeyplus/core/domain/vehicle.dart';
import 'package:journeyplus/core/theme/app_colors.dart';
import 'package:journeyplus/core/theme/app_text_styles.dart';

/// Optional km/l override for petrol, diesel, and bike profiles.
class FuelMileageField extends StatefulWidget {
  const FuelMileageField({
    super.key,
    required this.vehicle,
    required this.onChanged,
  });

  final Vehicle? vehicle;
  final ValueChanged<Vehicle> onChanged;

  @override
  State<FuelMileageField> createState() => _FuelMileageFieldState();
}

class _FuelMileageFieldState extends State<FuelMileageField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _textFor(widget.vehicle));
  }

  @override
  void didUpdateWidget(FuelMileageField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _textFor(widget.vehicle);
    if (_textFor(oldWidget.vehicle) != next && _controller.text != next) {
      _controller.text = next;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _textFor(Vehicle? vehicle) {
    final kmpl = vehicle?.fuelEfficiencyKmpl;
    if (kmpl == null) return '';
    final rounded = kmpl == kmpl.roundToDouble()
        ? kmpl.round().toString()
        : kmpl.toStringAsFixed(1);
    return rounded;
  }

  void _commit(String raw) {
    final vehicle = widget.vehicle;
    if (vehicle == null || !vehicle.burnsFuel) return;

    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      widget.onChanged(vehicle.copyWith(fuelEfficiencyKmpl: null));
      return;
    }

    final parsed = double.tryParse(trimmed);
    if (parsed == null || parsed < 5 || parsed > 120) return;

    widget.onChanged(vehicle.copyWith(fuelEfficiencyKmpl: parsed));
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.vehicle;
    if (vehicle == null || !vehicle.burnsFuel) return const SizedBox.shrink();

    final defaultKmpl = vehicle.type.defaultFuelEfficiencyKmpl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My mileage (km/l)',
          style: AppTextStyles.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,1})?')),
          ],
          decoration: InputDecoration(
            hintText: 'e.g. ${defaultKmpl.round()}',
            helperText:
                'Optional — leave blank to use default ${defaultKmpl.round()} km/l for ${vehicle.type.label.toLowerCase()}',
            helperMaxLines: 2,
            filled: true,
            fillColor: AppColors.surfaceElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            suffixText: 'km/l',
          ),
          onChanged: _commit,
          onSubmitted: _commit,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
