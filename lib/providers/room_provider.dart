import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room.dart';
import '../providers/device_provider.dart';

final roomsStreamProvider = StreamProvider<List<Room>>((ref) {
  return ref.watch(firestoreServiceProvider).getRooms();
});

final roomCountProvider = Provider<int>((ref) {
  final rooms = ref.watch(roomsStreamProvider).valueOrNull ?? [];
  return rooms.length;
});
