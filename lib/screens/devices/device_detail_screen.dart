import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/theme.dart';
import '../../models/device.dart';
import '../../providers/device_provider.dart';
import '../../widgets/custom_toggle.dart';
import '../../widgets/custom_slider.dart';

class DeviceDetailScreen extends ConsumerStatefulWidget {
  final Device device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  ConsumerState<DeviceDetailScreen> createState() =>
      _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends ConsumerState<DeviceDetailScreen> {
  bool _showDeleteConfirm = false;
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final deviceAsync = ref.watch(deviceProvider(widget.device.id));
    final device = deviceAsync.valueOrNull ?? widget.device;
    final isOnline = device.status == DeviceStatus.online;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(device.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => setState(() => _showDeleteConfirm = true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Main toggle area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: device.isOn
                          ? Theme.of(context).colorScheme.primary.withAlpha(25)
                          : Theme.of(context).colorScheme.onSurface.withAlpha(15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _deviceIcon(device.type),
                      color: device.isOn
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withAlpha(150),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    device.isOn ? 'On' : 'Off',
                    style: TextStyle(
                      color: device.isOn
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withAlpha(150),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomToggle(
                    value: device.isOn,
                    onChanged: (value) {
                      ref.read(firestoreServiceProvider).updateDevice(
                            device.id,
                            {'isOn': value},
                          );
                    },
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOnline
                              ? AppTheme.statusGreen
                              : Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: isOnline
                              ? AppTheme.statusGreen
                              : Theme.of(context).colorScheme.error,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Controls (based on type)
            if (device.isOn) ...[
              if (device.type == DeviceType.light)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CustomBrightnessSlider(
                    value: device.brightness,
                    onChanged: (value) {
                      ref.read(firestoreServiceProvider).updateDevice(
                            device.id,
                            {'brightness': value},
                          );
                    },
                  ),
                ),
              if (device.type == DeviceType.fan)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CustomSpeedSlider(
                    value: device.speed,
                    onChanged: (value) {
                      ref.read(firestoreServiceProvider).updateDevice(
                            device.id,
                            {'speed': value},
                          );
                    },
                  ),
                ),
              if (device.type == DeviceType.ac)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Temperature',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              final newTemp =
                                  (device.targetTemperature - 1)
                                      .clamp(16, 30);
                              ref
                                  .read(firestoreServiceProvider)
                                  .updateDevice(
                                    device.id,
                                    {'targetTemperature': newTemp},
                                  );
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                            color: Theme.of(context).colorScheme.primary,
                            iconSize: 32,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${device.targetTemperature.toInt()}°C',
                            style: const TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () {
                              final newTemp =
                                  (device.targetTemperature + 1)
                                      .clamp(16, 30);
                              ref
                                  .read(firestoreServiceProvider)
                                  .updateDevice(
                                    device.id,
                                    {'targetTemperature': newTemp},
                                  );
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            color: Theme.of(context).colorScheme.primary,
                            iconSize: 32,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
            ],

            // Tabs: Schedule, Usage, Info
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _TabButton(
                        label: 'Schedule',
                        isActive: _selectedTab == 0,
                        onTap: () =>
                            setState(() => _selectedTab = 0),
                      ),
                      _TabButton(
                        label: 'Usage',
                        isActive: _selectedTab == 1,
                        onTap: () =>
                            setState(() => _selectedTab = 1),
                      ),
                      _TabButton(
                        label: 'Info',
                        isActive: _selectedTab == 2,
                        onTap: () =>
                            setState(() => _selectedTab = 2),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildTabContent(device),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Remove button
            if (_showDeleteConfirm)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withAlpha(15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withAlpha(40),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Remove this device?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(
                                () => _showDeleteConfirm = false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                              side: BorderSide(
                                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await ref
                                  .read(firestoreServiceProvider)
                                  .removeDevice(device.id);
                              if (mounted) context.pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                            child: const Text('Remove'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(Device device) {
    switch (_selectedTab) {
      case 0:
        return _buildSchedule(device);
      case 1:
        return _buildUsage(device);
      case 2:
        return _buildInfo(device);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSchedule(Device device) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.schedule_outlined,
                color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Schedule',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '07:00',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Turn On',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Mon-Fri',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomToggle(
                value: true,
                onChanged: (_) {},
                size: 28,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '23:00',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Turn Off',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Everyday',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomToggle(
                value: true,
                onChanged: (_) {},
                size: 28,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUsage(Device device) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Usage (hours)',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 24,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.toInt()}h',
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                      if (value.toInt() < days.length) {
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                            fontSize: 10,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 6,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                _makeBar(0, 6),
                _makeBar(1, 8),
                _makeBar(2, 5),
                _makeBar(3, 10),
                _makeBar(4, 7),
                _makeBar(5, 4),
                _makeBar(6, 3),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _makeBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Theme.of(context).colorScheme.primary,
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(Device device) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: 'Device ID', value: device.id),
        const SizedBox(height: 12),
        _InfoRow(
          label: 'Firmware',
          value: device.firmwareVersion ?? 'Unknown',
        ),
        const SizedBox(height: 12),
        _InfoRow(
          label: 'Last Seen',
          value: _formatTime(device.lastSeen),
        ),
        const SizedBox(height: 12),
        _InfoRow(
          label: 'Signal Strength',
          value: '${device.signalStrength} dBm',
        ),
        const SizedBox(height: 12),
        _InfoRow(
          label: 'Type',
          value: device.type.name.toUpperCase(),
        ),
        const SizedBox(height: 12),
        _InfoRow(
          label: 'Room',
          value: device.room,
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  IconData _deviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return Icons.lightbulb_outline;
      case DeviceType.fan:
        return Icons.air;
      case DeviceType.ac:
        return Icons.ac_unit;
      case DeviceType.sensor:
        return Icons.sensors;
      case DeviceType.outlet:
        return Icons.power_settings_new;
      case DeviceType.lock:
        return Icons.lock_outline;
    }
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? Theme.of(context).colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withAlpha(150),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
