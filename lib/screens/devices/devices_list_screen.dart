import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/device_provider.dart';
import '../../widgets/device_control.dart';

class DevicesListScreen extends ConsumerWidget {
  const DevicesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(devicesStreamProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/add-device'),
          ),
        ],
      ),
      body: devicesAsync.when(
        data: (devices) {
          if (devices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withAlpha(15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.devices_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Devices Yet',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first smart device',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
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
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
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
        error: (_, __) => Center(
          child: Text(
            'Failed to load devices',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
          ),
        ),
      ),
    );
  }
}
