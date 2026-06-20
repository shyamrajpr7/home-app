import 'package:flutter/material.dart';
import '../models/device.dart';
import '../config/theme.dart';
import 'custom_toggle.dart';

class DeviceCard extends StatefulWidget {
  final Device device;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onTap,
    required this.onToggle,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    final isOnline = device.status == DeviceStatus.online;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: device.isOn
                ? AppTheme.surfaceColor
                : AppTheme.surfaceColor.withAlpha(180),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOnline
                  ? AppTheme.statusGreen.withAlpha(30)
                  : Colors.transparent,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: device.isOn
                    ? AppTheme.accentTeal.withAlpha(15)
                    : Colors.black.withAlpha(20),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _deviceIcon(device.type, device.isOn),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isOnline
                          ? AppTheme.statusGreen
                          : AppTheme.statusRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                device.name,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    device.isOn ? 'On' : 'Off',
                    style: TextStyle(
                      color: device.isOn
                          ? AppTheme.accentTeal
                          : AppTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomToggle(
                    value: device.isOn,
                    onChanged: widget.onToggle,
                    size: 32,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceIcon(DeviceType type, bool isOn) {
    final color = isOn ? AppTheme.accentTeal : AppTheme.textSecondary;
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

class RoomCard extends StatelessWidget {
  final String name;
  final String icon;
  final int deviceCount;
  final VoidCallback onTap;

  const RoomCard({
    super.key,
    required this.name,
    required this.icon,
    required this.deviceCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              _iconFromString(icon),
              color: AppTheme.accentTeal,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '$deviceCount devices',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFromString(String icon) {
    switch (icon) {
      case 'living_room':
        return Icons.weekend;
      case 'bedroom':
        return Icons.bed;
      case 'kitchen':
        return Icons.kitchen;
      case 'bathroom':
        return Icons.bathtub;
      case 'garage':
        return Icons.garage;
      case 'office':
        return Icons.desk;
      case 'outdoor':
        return Icons.grass;
      default:
        return Icons.home;
    }
  }
}
