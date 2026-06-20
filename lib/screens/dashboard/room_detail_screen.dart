import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../models/room.dart';
import '../../providers/device_provider.dart';
import '../../widgets/device_control.dart';

class RoomDetailScreen extends ConsumerWidget {
  final Room room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(devicesStreamProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(room.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/add-device'),
          ),
        ],
      ),
      body: devicesAsync.when(
        data: (devices) {
          final roomDevices =
              devices.where((d) => d.room == room.name).toList();

          if (roomDevices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.devices_outlined,
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(80),
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No devices in this room',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/add-device'),
                    child: const Text('Add Device'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: roomDevices.length,
            itemBuilder: (context, index) {
              final device = roomDevices[index];
              return DeviceControlRow(
                device: device,
                onTap: () =>
                    context.push('/device/${device.id}', extra: device),
                onToggle: (value) {
                  ref
                      .read(firestoreServiceProvider)
                      .updateDevice(device.id, {'isOn': value});
                },
                onBrightnessChanged: (value) {
                  ref.read(firestoreServiceProvider).updateDevice(
                        device.id,
                        {'brightness': value},
                      );
                },
                onSpeedChanged: (value) {
                  ref.read(firestoreServiceProvider).updateDevice(
                        device.id,
                        {'speed': value},
                      );
                },
                onTemperatureChanged: (value) {
                  ref.read(firestoreServiceProvider).updateDevice(
                        device.id,
                        {'targetTemperature': value},
                      );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text('Failed to load devices',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
        ),
      ),
    );
  }
}
