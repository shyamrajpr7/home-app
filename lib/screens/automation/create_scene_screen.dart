import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../config/theme.dart';
import '../../models/scene.dart';
import '../../providers/device_provider.dart';
import '../../widgets/custom_toggle.dart';

class CreateSceneScreen extends ConsumerStatefulWidget {
  const CreateSceneScreen({super.key});

  @override
  ConsumerState<CreateSceneScreen> createState() =>
      _CreateSceneScreenState();
}

class _CreateSceneScreenState extends ConsumerState<CreateSceneScreen> {
  final _nameController = TextEditingController();
  final Map<String, Map<String, dynamic>> _selectedDevices = {};
  SceneTriggerType _triggerType = SceneTriggerType.manual;
  TimeOfDay? _selectedTime;
  bool _isSaving = false;

  final _uuid = const Uuid();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveScene() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a scene name')),
      );
      return;
    }
    if (_selectedDevices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one device')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final sceneId = _uuid.v4();
      final scene = Scene(
        id: sceneId,
        name: _nameController.text.trim(),
        actions: _selectedDevices.entries.map((e) {
          return SceneAction(
            deviceId: e.key,
            deviceName: e.value['name'] as String? ?? '',
            targetState: e.value,
          );
        }).toList(),
        trigger: _triggerType == SceneTriggerType.time &&
                _selectedTime != null
            ? SceneTrigger(
                type: SceneTriggerType.time,
                timeOfDay:
                    '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
              )
            : SceneTrigger(type: SceneTriggerType.manual),
      );

      await ref.read(firestoreServiceProvider).addScene(scene);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scene "${scene.name}" created'),
            backgroundColor: AppTheme.statusGreen,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create scene')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(devicesStreamProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Create Scene'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveScene,
            child: Text(
              'Save',
              style: TextStyle(
                color: _isSaving
                    ? Theme.of(context).colorScheme.onSurface.withAlpha(150)
                    : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Scene Name',
                hintText: 'e.g., Good Night, Movie Time',
                prefixIcon: Icon(Icons.auto_awesome_outlined),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Trigger',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _TriggerOption(
                    icon: Icons.touch_app_outlined,
                    label: 'Manual',
                    isSelected: _triggerType == SceneTriggerType.manual,
                    onTap: () =>
                        setState(() => _triggerType = SceneTriggerType.manual),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TriggerOption(
                    icon: Icons.schedule_outlined,
                    label: 'Time',
                    isSelected: _triggerType == SceneTriggerType.time,
                    onTap: () async {
                      setState(
                          () => _triggerType = SceneTriggerType.time);
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (context, child) => Theme(
                          data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: Theme.of(context).colorScheme.primary,
                          ),
                          ),
                          child: child!,
                        ),
                      );
                      if (time != null) {
                        setState(() => _selectedTime = time);
                      }
                    },
                  ),
                ),
              ],
            ),
            if (_selectedTime != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule,
                        color: Theme.of(context).colorScheme.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Triggers at ${_selectedTime!.format(context)}',
style: TextStyle(
                         color: Theme.of(context).colorScheme.primary,
                         fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Devices',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select devices and set their desired state',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            devicesAsync.when(
              data: (devices) {
                if (devices.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Add devices first',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    final isSelected =
                        _selectedDevices.containsKey(device.id);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary.withAlpha(10)
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary.withAlpha(60)
                              : Colors.transparent,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedDevices.remove(device.id);
                            } else {
                              _selectedDevices[device.id] = {
                                'name': device.name,
                                'isOn': true,
                              };
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withAlpha(20),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.devices_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  device.name,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'ON',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    CustomToggle(
                                      value: true,
                                      onChanged: (v) {
                                        setState(() {
                                          _selectedDevices[device.id] =
                                              {'name': device.name, 'isOn': v};
                                        });
                                      },
                                      size: 28,
                                    ),
                                  ],
                                ),
                              if (!isSelected)
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(
                child: Text('Failed to load devices'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TriggerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TriggerOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withAlpha(20)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withAlpha(150),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
