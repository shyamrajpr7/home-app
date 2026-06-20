import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
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
                    style: const TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  loading: () => const Text(
                    'Hello!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  error: (_, __) => const Text(
                    'Hello!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
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
                    const Text(
                      'Rooms',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
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
                            itemCount: rooms.length,
                            itemBuilder: (context, index) {
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
                    const Text(
                      'Quick Access',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
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
                            const Text(
                              'No devices yet',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  context.push('/add-device'),
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
                  style: const TextStyle(
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
          const Icon(Icons.error_outline,
              color: Theme.of(context).colorScheme.error, size: 48),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(150))),
        ],
      ),
    );
  }
}
