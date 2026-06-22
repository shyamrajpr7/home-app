import 'package:flutter/material.dart';
import '../models/device.dart';
import '../config/theme.dart';
import 'custom_toggle.dart';
import 'custom_slider.dart';


class DeviceControlRow extends StatefulWidget {
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
  State<DeviceControlRow> createState() => _DeviceControlRowState();
}

class _DeviceControlRowState extends State<DeviceControlRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.device;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  _deviceIcon(context, device.type, device.isOn),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          device.isOn ? 'On' : 'Off',
                          style: TextStyle(
                            color: device.isOn
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface.withAlpha(150),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusDot(context, device.status),
                  const SizedBox(width: 12),
                  CustomToggle(
                    value: device.isOn,
                    onChanged: widget.onToggle,
                    size: 36,
                  ),
                ],
              ),
              if (device.isOn) ...[
                const SizedBox(height: 12),
                if (device.type == DeviceType.light)
                  CustomBrightnessSlider(
                    value: device.brightness,
                    onChanged: widget.onBrightnessChanged ?? (_) {},
                  ),
                if (device.type == DeviceType.fan)
                  CustomSpeedSlider(
                    value: device.speed,
                    onChanged: widget.onSpeedChanged ?? (_) {},
                  ),
                if (device.type == DeviceType.ac)
                  _TemperatureStepper(
                    value: device.targetTemperature,
                    onChanged: widget.onTemperatureChanged ?? (_) {},
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceIcon(BuildContext context, DeviceType type, bool isOn) {
    final color = isOn
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface.withAlpha(150);

    Widget iconWidget;
    switch (type) {
      case DeviceType.light:
        iconWidget = isOn
            ? Icon(Icons.lightbulb, color: Color(0xFFFFD54F), size: 22)
            : Icon(Icons.lightbulb_outline, color: color, size: 22);
      case DeviceType.fan:
        iconWidget = _FanIcon(color: color, isOn: isOn);
      case DeviceType.ac:
        iconWidget = Icon(Icons.ac_unit, color: color, size: 22);
      case DeviceType.sensor:
        iconWidget = Icon(Icons.sensors, color: color, size: 22);
      case DeviceType.outlet:
        iconWidget = Icon(Icons.power_settings_new, color: color, size: 22);
      case DeviceType.lock:
        iconWidget = Icon(Icons.lock_outline, color: color, size: 22);
    }

    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isOn && type == DeviceType.light
                ? [
                    BoxShadow(
                      color: Color(0xFFFFD54F).withAlpha((80 * _glowAnim.value).toInt()),
                      blurRadius: 14 * _glowAnim.value,
                      spreadRadius: 4 * _glowAnim.value,
                    ),
                  ]
                : null,
          ),
          child: iconWidget,
        );
      },
    );
  }

  Widget _statusDot(BuildContext context, DeviceStatus status) {
    Color color;
    switch (status) {
      case DeviceStatus.online:
        color = AppTheme.statusGreen;
      case DeviceStatus.offline:
        color = Theme.of(context).colorScheme.error;
      case DeviceStatus.error:
        color = Theme.of(context).colorScheme.secondary;
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
        Text(
          'Temperature',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
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
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
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
          color: Theme.of(context).colorScheme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18),
      ),
    );
  }
}

class _FanIcon extends StatefulWidget {
  final Color color;
  final bool isOn;

  const _FanIcon({required this.color, required this.isOn});

  @override
  State<_FanIcon> createState() => _FanIconState();
}

class _FanIconState extends State<_FanIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    if (widget.isOn) _spinController.repeat();
  }

  @override
  void didUpdateWidget(_FanIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOn != oldWidget.isOn) {
      if (widget.isOn) {
        _spinController.repeat();
      } else {
        _spinController.stop();
        _spinController.reset();
      }
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _spinController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _spinController.value * 6.2832,
          child: Icon(Icons.air, color: widget.color, size: 22),
        );
      },
    );
  }
}
