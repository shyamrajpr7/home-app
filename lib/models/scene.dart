class SceneAction {
  final String deviceId;
  final String deviceName;
  final Map<String, dynamic> targetState;

  SceneAction({
    required this.deviceId,
    required this.deviceName,
    required this.targetState,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'targetState': targetState,
    };
  }

  factory SceneAction.fromJson(Map<String, dynamic> json) {
    return SceneAction(
      deviceId: json['deviceId'] as String? ?? '',
      deviceName: json['deviceName'] as String? ?? '',
      targetState: json['targetState'] as Map<String, dynamic>? ?? {},
    );
  }
}

enum SceneTriggerType { manual, time }

class SceneTrigger {
  final SceneTriggerType type;
  final String? timeOfDay; // HH:mm format if time-based
  final List<int>? repeatDays; // 0=Mon, 6=Sun

  SceneTrigger({
    this.type = SceneTriggerType.manual,
    this.timeOfDay,
    this.repeatDays,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'timeOfDay': timeOfDay,
      'repeatDays': repeatDays,
    };
  }

  factory SceneTrigger.fromJson(Map<String, dynamic> json) {
    return SceneTrigger(
      type: SceneTriggerType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => SceneTriggerType.manual,
      ),
      timeOfDay: json['timeOfDay'] as String?,
      repeatDays: (json['repeatDays'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );
  }
}

class Scene {
  final String id;
  final String name;
  final List<SceneAction> actions;
  final SceneTrigger trigger;
  final bool isActive;
  final DateTime createdAt;

  Scene({
    required this.id,
    required this.name,
    this.actions = const [],
    SceneTrigger? trigger,
    this.isActive = true,
    DateTime? createdAt,
  })  : trigger = trigger ?? SceneTrigger(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'actions': actions.map((a) => a.toJson()).toList(),
      'trigger': trigger.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Scene.fromJson(String id, Map<String, dynamic> json) {
    return Scene(
      id: id,
      name: json['name'] as String? ?? '',
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => SceneAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      trigger: json['trigger'] != null
          ? SceneTrigger.fromJson(json['trigger'] as Map<String, dynamic>)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
