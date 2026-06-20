import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int divisions;
  final String? label;
  final Color activeColor;

  const CustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.divisions = 100,
    this.label,
    this.activeColor = AppTheme.accentTeal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label!,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: activeColor,
                  inactiveTrackColor: activeColor.withAlpha(40),
                  thumbColor: activeColor,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                  overlayColor: activeColor.withAlpha(20),
                  trackHeight: 4,
                  trackShape: const RoundedRectSliderTrackShape(),
                ),
                child: Slider(
                  value: value.clamp(min, max),
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: onChanged,
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 36,
              child: Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomBrightnessSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const CustomBrightnessSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSlider(
      value: value,
      onChanged: onChanged,
      label: 'Brightness',
      activeColor: AppTheme.accentAmber,
    );
  }
}

class CustomSpeedSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const CustomSpeedSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSlider(
      value: value.toDouble(),
      onChanged: (v) => onChanged(v.toInt()),
      min: 1,
      max: 5,
      divisions: 4,
      label: 'Speed',
      activeColor: AppTheme.accentTeal,
    );
  }
}
