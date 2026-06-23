import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';
import '../../config/theme.dart';
import '../../models/device.dart';
import '../../models/device_schedule.dart';
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
                      Text(
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
                            style: TextStyle(
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
                    Text(
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
    final schedules = device.schedules;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.schedule_outlined,
                color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Schedule',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _showAddScheduleDialog(context, device),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (schedules.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No schedules yet. Tap Add to create one.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          ...schedules.map((schedule) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ScheduleRow(
                  schedule: schedule,
                  onToggle: (enabled) =>
                      _toggleSchedule(device, schedule, enabled),
                  onDelete: () => _deleteSchedule(device, schedule),
                  onEdit: () =>
                      _showEditScheduleDialog(context, device, schedule),
                ),
              )),
      ],
    );
  }

  void _toggleSchedule(
      Device device, DeviceSchedule schedule, bool enabled) {
    final schedules = device.schedules.map((s) {
      if (s.id == schedule.id) return s.copyWith(isEnabled: enabled);
      return s;
    }).toList();
    ref.read(firestoreServiceProvider).updateDevice(device.id, {
      'schedules': schedules.map((s) => s.toJson()).toList(),
    });
  }

  void _deleteSchedule(Device device, DeviceSchedule schedule) {
    final schedules =
        device.schedules.where((s) => s.id != schedule.id).toList();
    ref.read(firestoreServiceProvider).updateDevice(device.id, {
      'schedules': schedules.map((s) => s.toJson()).toList(),
    });
  }

  void _showAddScheduleDialog(BuildContext context, Device device) {
    int hour = 7;
    int minute = 0;
    bool action = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Schedule',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close,
                            color:
                                Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Time',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(150),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Hour',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withAlpha(120),
                                      fontSize: 11,
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: CupertinoSlider(
                                      value: hour.toDouble(),
                                      min: 0,
                                      max: 23,
                                      divisions: 23,
                                      onChanged: (v) =>
                                          setSheetState(
                                              () => hour = v.toInt()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Minute',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withAlpha(120),
                                      fontSize: 11,
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: CupertinoSlider(
                                      value: minute.toDouble(),
                                      min: 0,
                                      max: 45,
                                      divisions: 11,
                                      onChanged: (v) =>
                                          setSheetState(() =>
                                              minute = v.toInt()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Action',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(150),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setSheetState(() => action = true),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: action
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withAlpha(25)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: action
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.power_settings_new,
                                          size: 18,
                                          color: action
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withAlpha(120)),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Turn On',
                                        style: TextStyle(
                                          color: action
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withAlpha(120),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setSheetState(() => action = false),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: !action
                                        ? Theme.of(context)
                                            .colorScheme
                                            .error
                                            .withAlpha(25)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: !action
                                          ? Theme.of(context).colorScheme.error
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.power_settings_new,
                                          size: 18,
                                          color: !action
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .error
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withAlpha(120)),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Turn Off',
                                        style: TextStyle(
                                          color: !action
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .error
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withAlpha(120),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final uuid = const Uuid();
                        final newSchedule = DeviceSchedule(
                          id: uuid.v4(),
                          hour: hour,
                          minute: minute,
                          action: action,
                          isEnabled: true,
                        );
                        final schedules = [
                          ...device.schedules,
                          newSchedule,
                        ];
                        ref
                            .read(firestoreServiceProvider)
                            .updateDevice(device.id, {
                          'schedules':
                              schedules.map((s) => s.toJson()).toList(),
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Schedule'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditScheduleDialog(
      BuildContext context, Device device, DeviceSchedule schedule) {
    int hour = schedule.hour;
    int minute = schedule.minute;
    bool action = schedule.action;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Schedule',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close,
                            color:
                                Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Time',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(150),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Hour',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withAlpha(120),
                                      fontSize: 11,
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: CupertinoSlider(
                                      value: hour.toDouble(),
                                      min: 0,
                                      max: 23,
                                      divisions: 23,
                                      onChanged: (v) =>
                                          setSheetState(
                                              () => hour = v.toInt()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Minute',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withAlpha(120),
                                      fontSize: 11,
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: CupertinoSlider(
                                      value: minute.toDouble(),
                                      min: 0,
                                      max: 45,
                                      divisions: 11,
                                      onChanged: (v) =>
                                          setSheetState(() =>
                                              minute = v.toInt()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Action',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(150),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setSheetState(() => action = true),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: action
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withAlpha(25)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: action
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.power_settings_new,
                                          size: 18,
                                          color: action
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withAlpha(120)),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Turn On',
                                        style: TextStyle(
                                          color: action
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withAlpha(120),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setSheetState(() => action = false),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: !action
                                        ? Theme.of(context)
                                            .colorScheme
                                            .error
                                            .withAlpha(25)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: !action
                                          ? Theme.of(context).colorScheme.error
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.power_settings_new,
                                          size: 18,
                                          color: !action
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .error
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withAlpha(120)),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Turn Off',
                                        style: TextStyle(
                                          color: !action
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .error
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withAlpha(120),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _deleteSchedule(device, schedule);
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                            side: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.error),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Delete'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            final schedules = device.schedules.map((s) {
                              if (s.id == schedule.id) {
                                return s.copyWith(
                                  hour: hour,
                                  minute: minute,
                                  action: action,
                                );
                              }
                              return s;
                            }).toList();
                            ref
                                .read(firestoreServiceProvider)
                                .updateDevice(device.id, {
                              'schedules':
                                  schedules.map((s) => s.toJson()).toList(),
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUsage(Device device) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
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
                          style: TextStyle(
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

class _ScheduleRow extends StatelessWidget {
  final DeviceSchedule schedule;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ScheduleRow({
    required this.schedule,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onEdit,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.timeString,
                  style: TextStyle(
                    color: schedule.isEnabled
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurface.withAlpha(80),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: schedule.isEnabled
                        ? null
                        : TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  schedule.action ? 'Turn On' : 'Turn Off',
                  style: TextStyle(
                    color: schedule.isEnabled
                        ? (schedule.action
                            ? AppTheme.statusGreen
                            : Theme.of(context).colorScheme.error)
                        : Theme.of(context).colorScheme.onSurface.withAlpha(80),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: schedule.isEnabled
                    ? Theme.of(context).colorScheme.primary.withAlpha(20)
                    : Theme.of(context).colorScheme.onSurface.withAlpha(10),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                schedule.repeatLabel,
                style: TextStyle(
                  color: schedule.isEnabled
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withAlpha(80),
                  fontSize: 11,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CustomToggle(
            value: schedule.isEnabled,
            onChanged: onToggle,
            size: 28,
          ),
        ],
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
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
