import 'package:flutter/material.dart';
import '../models/device.dart';
import '../config/theme.dart';
import 'custom_toggle.dart';
import 'custom_slider.dart';

class DeviceControlRow extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double>? onBrightnessChanged;
  final ValueChanged<int>? onSpeedChanged;
  final ValueChanged<double>? onTemperatureChanged;

  const DeviceControlRow({
    super.key,
    required this.device,
    required this.onTap,
    required this.onToggle,
    this.onBrightnessChanged,
    this.onSpeedChanged,
    this.onTemperatureChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  _deviceIcon(device.type),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          device.isOn ? 'On' : 'Off',
                          style: TextStyle(
                            color: device.isOn
                                ? AppTheme.accentTeal
                                : AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusDot(device.status),
                  const SizedBox(width: 12),
                  CustomToggle(
                    value: device.isOn,
                    onChanged: onToggle,
                    size: 36,
                  ),
                ],
              ),
              if (device.isOn) ...[
                const SizedBox(height: 12),
                if (device.type == DeviceType.light)
                  CustomBrightnessSlider(
                    value: device.brightness,
                    onChanged: onBrightnessChanged ?? (_) {},
                  ),
                if (device.type == DeviceType.fan)
                  CustomSpeedSlider(
                    value: device.speed,
                    onChanged: onSpeedChanged ?? (_) {},
                  ),
                if (device.type == DeviceType.ac)
                  _TemperatureStepper(
                    value: device.targetTemperature,
                    onChanged: onTemperatureChanged ?? (_) {},
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceIcon(DeviceType type) {
    IconData icon;
    switch (type) {
      case DeviceType.light:
        icon = Icons.lightbulb_outline;
      case DeviceType.fan:
        icon = Icons.air;
      case DeviceType.ac:
        icon = Icons.ac_unit;
      case DeviceType.sensor:
        icon = Icons.sensors;
      case DeviceType.outlet:
        icon = Icons.power_settings_new;
      case DeviceType.lock:
        icon = Icons.lock_outline;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.accentTeal.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppTheme.accentTeal, size: 22),
    );
  }

  Widget _statusDot(DeviceStatus status) {
    Color color;
    switch (status) {
      case DeviceStatus.online:
        color = AppTheme.statusGreen;
      case DeviceStatus.offline:
        color = AppTheme.statusRed;
      case DeviceStatus.error:
        color = AppTheme.accentAmber;
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _TemperatureStepper extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _TemperatureStepper({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Temperature',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        _TempButton(
          icon: Icons.remove,
          onTap: () => onChanged((value - 1).clamp(16, 30)),
        ),
        const SizedBox(width: 16),
        Text(
          '${value.toInt()}°C',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 16),
        _TempButton(
          icon: Icons.add,
          onTap: () => onChanged((value + 1).clamp(16, 30)),
        ),
      ],
    );
  }
}

class _TempButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TempButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppTheme.accentTeal.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.accentTeal, size: 18),
      ),
    );
  }
}
