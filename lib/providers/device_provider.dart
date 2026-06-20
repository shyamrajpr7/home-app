import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/device.dart';
import '../services/firestore_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

final devicesStreamProvider = StreamProvider<List<Device>>((ref) {
  return ref.watch(firestoreServiceProvider).getDevices();
});

final deviceProvider =
    StreamProvider.family<Device?, String>((ref, deviceId) {
  return ref.watch(firestoreServiceProvider).getDevice(deviceId);
});

final devicesByRoomProvider = Provider.family<List<Device>, String>((ref, room) {
  final devices = ref.watch(devicesStreamProvider).valueOrNull ?? [];
  return devices.where((d) => d.room == room).toList();
});

final deviceCountProvider = Provider<int>((ref) {
  final devices = ref.watch(devicesStreamProvider).valueOrNull ?? [];
  return devices.length;
});

final onlineDeviceCountProvider = Provider<int>((ref) {
  final devices = ref.watch(devicesStreamProvider).valueOrNull ?? [];
  return devices.where((d) => d.status == DeviceStatus.online).length;
});
