import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../models/scene.dart';
import '../../providers/scene_provider.dart';
import '../../providers/device_provider.dart';

class AutomationScreen extends ConsumerWidget {
  const AutomationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenesAsync = ref.watch(scenesStreamProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Automation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/create-scene'),
          ),
        ],
      ),
      body: scenesAsync.when(
        data: (scenes) {
          if (scenes.isEmpty) {
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
                    child: const Icon(
                      Icons.auto_awesome_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No Scenes Yet',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create scenes to automate your home',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.push('/create-scene'),
                    child: const Text('Create Scene'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scenes.length,
            itemBuilder: (context, index) {
              final scene = scenes[index];
              return _SceneCard(scene: scene);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text(
            'Failed to load scenes',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
          ),
        ),
      ),
    );
  }
}

class _SceneCard extends ConsumerWidget {
  final Scene scene;

  const _SceneCard({required this.scene});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scene.isActive
                      ? Theme.of(context).colorScheme.primary.withAlpha(20)
                      : Theme.of(context).colorScheme.onSurface.withAlpha(150).withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _sceneIcon(scene.name),
                  color: scene.isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scene.name,
                      style: const TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${scene.actions.length} devices',
                      style: const TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Switch(
                    value: scene.isActive,
                    onChanged: (value) {
                      ref
                          .read(firestoreServiceProvider)
                          .updateScene(scene.id, {'isActive': value});
                    },
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    scene.trigger.type == SceneTriggerType.time
                        ? scene.trigger.timeOfDay ?? ''
                        : 'Manual',
                    style: const TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _sceneIcon(String name) {
    switch (name.toLowerCase()) {
      case 'good night':
        return Icons.nightlight_round;
      case 'movie time':
        return Icons.movie_outlined;
      case 'away mode':
        return Icons.flight_takeoff;
      case 'morning':
        return Icons.wb_sunny_outlined;
      default:
        return Icons.auto_awesome_outlined;
    }
  }
}
