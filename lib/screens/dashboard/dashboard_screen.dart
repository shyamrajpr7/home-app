import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../config/theme.dart';
import '../../models/device.dart';
import '../../models/room.dart';
import '../../providers/auth_provider.dart';
import '../../providers/device_provider.dart';
import '../../providers/room_provider.dart';
import '../../widgets/device_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _uuid = const Uuid();

  static const _roomIcons = [
    'living_room', 'bedroom', 'kitchen', 'bathroom',
    'garage', 'office', 'outdoor', 'home',
  ];

  void _showAddRoomSheet() {
    final nameCtrl = TextEditingController();
    var selectedIcon = 'living_room';
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        bool saving = false;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Room',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Room Name',
                        prefixIcon: Icon(Icons.room_outlined),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Enter a room name' : null,
                      autofocus: true,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Icon',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _roomIcons.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final iconName = _roomIcons[i];
                          final selected = selectedIcon == iconName;
                          return GestureDetector(
                            onTap: () => setSheetState(() => selectedIcon = iconName),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: selected
                                    ? Theme.of(context).colorScheme.primary.withAlpha(25)
                                    : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                _roomIconData(iconName),
                                color: selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface.withAlpha(150),
                                size: 28,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: saving
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                setSheetState(() => saving = true);
                                final room = Room(
                                  id: _uuid.v4(),
                                  name: nameCtrl.text.trim(),
                                  icon: selectedIcon,
                                );
                                await ref.read(firestoreServiceProvider).addRoom(room);
                                setSheetState(() => saving = false);
                                if (ctx.mounted) Navigator.pop(ctx);
                              },
                        child: saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Add Room'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddDeviceSheet() {
    DeviceType deviceType = DeviceType.light;
    String selectedRoom = '';
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final roomsAsync = ref.read(roomsStreamProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        bool saving = false;
        final rooms = roomsAsync.valueOrNull ?? [];
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Device',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Device Name',
                        prefixIcon: Icon(Icons.label_outline),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Enter a name' : null,
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Type',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: DeviceType.values
                          .where((t) => t == DeviceType.light || t == DeviceType.fan || t == DeviceType.ac || t == DeviceType.outlet)
                          .map((type) {
                        final selected = deviceType == type;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: type == DeviceType.light ? 6 : (type == DeviceType.fan ? 6 : (type == DeviceType.ac ? 6 : 0)),
                            ),
                            child: GestureDetector(
                              onTap: () => setSheetState(() => deviceType = type),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? Theme.of(context).colorScheme.primary.withAlpha(25)
                                      : Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      _deviceTypeIcon(type),
                                      color: selected
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.onSurface.withAlpha(150),
                                      size: 28,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      type.name[0].toUpperCase() + type.name.substring(1),
                                      style: TextStyle(
                                        color: selected
                                            ? Theme.of(context).colorScheme.primary
                                            : Theme.of(context).colorScheme.onSurface.withAlpha(150),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedRoom.isEmpty ? null : selectedRoom,
                      decoration: const InputDecoration(
                        labelText: 'Room',
                        prefixIcon: Icon(Icons.room_outlined),
                      ),
                      items: [
                        if (rooms.isEmpty)
                          const DropdownMenuItem(
                            value: '',
                            child: Text('No rooms — create one first'),
                          ),
                        ...rooms.map(
                          (r) => DropdownMenuItem(
                            value: r.name,
                            child: Text(r.name),
                          ),
                        ),
                      ],
                      onChanged: (v) => setSheetState(() => selectedRoom = v ?? ''),
                      dropdownColor: Theme.of(context).colorScheme.surface,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: saving || selectedRoom.isEmpty
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                setSheetState(() => saving = true);
                                final device = Device(
                                  id: _uuid.v4(),
                                  name: nameCtrl.text.trim(),
                                  room: selectedRoom,
                                  type: deviceType,
                                  status: DeviceStatus.online,
                                  lastSeen: DateTime.now(),
                                );
                                await ref.read(firestoreServiceProvider).addDevice(device);
                                setSheetState(() => saving = false);
                                if (ctx.mounted) Navigator.pop(ctx);
                              },
                        child: saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Add Device'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _roomIconData(String icon) {
    switch (icon) {
      case 'living_room': return Icons.weekend;
      case 'bedroom': return Icons.bed;
      case 'kitchen': return Icons.kitchen;
      case 'bathroom': return Icons.bathtub;
      case 'garage': return Icons.garage;
      case 'office': return Icons.desk;
      case 'outdoor': return Icons.grass;
      default: return Icons.home;
    }
  }

  IconData _deviceTypeIcon(DeviceType type) {
    switch (type) {
      case DeviceType.light: return Icons.lightbulb_outline;
      case DeviceType.fan: return Icons.air;
      case DeviceType.ac: return Icons.ac_unit;
      case DeviceType.outlet: return Icons.power_settings_new;
      default: return Icons.devices_other;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileProvider);
    final devicesAsync = ref.watch(devicesStreamProvider);
    final roomsAsync = ref.watch(roomsStreamProvider);
    final onlineCount = ref.watch(onlineDeviceCountProvider);
    final deviceCount = ref.watch(deviceCountProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                userAsync.when(
                  data: (user) => Text(
                    'Hello, ${user?.name ?? 'there'}!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  loading: () => Text(
                    'Hello!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  error: (_, __) => Text(
                    'Hello!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Control your home',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _StatusCard(
                      label: 'Devices',
                      value: '$deviceCount',
                      icon: Icons.devices_outlined,
                    ),
                    const SizedBox(width: 12),
                    _StatusCard(
                      label: 'Online',
                      value: '$onlineCount',
                      icon: Icons.wifi_outlined,
                      valueColor: AppTheme.statusGreen,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rooms',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: _showAddRoomSheet,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                roomsAsync.when(
                  data: (rooms) => SizedBox(
                    height: 150,
                    child: rooms.isEmpty
                        ? Center(
                            child: Text(
                              'No rooms yet',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: rooms.length + 1,
                            itemBuilder: (context, index) {
                              if (index == rooms.length) {
                                return _AddRoomCard(onTap: _showAddRoomSheet);
                              }
                              final room = rooms[index];
                              final devices = ref
                                  .watch(devicesStreamProvider)
                                  .valueOrNull ?? [];
                              final count = devices
                                  .where((d) => d.room == room.name)
                                  .length;
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 12),
                                child: RoomCard(
                                  name: room.name,
                                  icon: room.icon,
                                  deviceCount: count,
                                  onTap: () => context.push(
                                    '/room/${room.id}',
                                    extra: room,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  loading: () => const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox(
                    height: 150,
                    child: Center(child: Text('Failed to load rooms')),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Access',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _showAddDeviceSheet,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                devicesAsync.when(
                  data: (devices) {
                    if (devices.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: Theme.of(context).colorScheme.primary.withAlpha(100),
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No devices yet',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _showAddDeviceSheet,
                              child: const Text('Add Device'),
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: devices.length.clamp(0, 4),
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        return DeviceCard(
                          device: device,
                          onTap: () => context.push(
                            '/device/${device.id}',
                            extra: device,
                          ),
                          onToggle: (value) {
                            ref
                                .read(firestoreServiceProvider)
                                .updateDevice(
                                  device.id,
                                  {'isOn': value},
                                );
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (_, __) => const AppErrorWidget(
                    message: 'Failed to load devices',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _StatusCard({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? Theme.of(context).colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppErrorWidget extends StatelessWidget {
  final String message;

  const AppErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              color: Theme.of(context).colorScheme.error, size: 48),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(150))),
        ],
      ),
    );
  }
}

class _AddRoomCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddRoomCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withAlpha(120),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withAlpha(40),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Room',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
