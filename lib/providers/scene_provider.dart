import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scene.dart';
import '../providers/device_provider.dart';

final scenesStreamProvider = StreamProvider<List<Scene>>((ref) {
  return ref.watch(firestoreServiceProvider).getScenes();
});

final sceneCountProvider = Provider<int>((ref) {
  final scenes = ref.watch(scenesStreamProvider).valueOrNull ?? [];
  return scenes.length;
});
