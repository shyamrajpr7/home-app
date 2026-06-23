import 'device_schedule.dart';

enum DeviceType { light, fan, ac, sensor, outlet, lock }

enum DeviceStatus { online, offline, error }

class Device {
  final String id;
  final String name;
  final String room;
  final DeviceType type;
  final DeviceStatus status;
  final bool isOn;
  final double brightness;
  final int speed;
  final double temperature;
  final double targetTemperature;
  final String? firmwareVersion;
  final String? mqttTopic;
  final String? localIp;
  final DateTime lastSeen;
  final int signalStrength;
  final List<DeviceSchedule> schedules;
  final DateTime createdAt;

  Device({
    required this.id,
    required this.name,
    required this.room,
    required this.type,
    this.status = DeviceStatus.offline,
    this.isOn = false,
    this.brightness = 100,
    this.speed = 1,
    this.temperature = 24.0,
    this.targetTemperature = 24.0,
    this.firmwareVersion,
    this.mqttTopic,
    this.localIp,
    DateTime? lastSeen,
    this.signalStrength = 0,
    this.schedules = const [],
    DateTime? createdAt,
  })  : lastSeen = lastSeen ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  Device copyWith({
    String? name,
    String? room,
    DeviceType? type,
    DeviceStatus? status,
    bool? isOn,
    double? brightness,
    int? speed,
    double? temperature,
    double? targetTemperature,
    String? firmwareVersion,
    String? mqttTopic,
    String? localIp,
    DateTime? lastSeen,
    int? signalStrength,
    List<DeviceSchedule>? schedules,
  }) {
    return Device(
      id: id,
      name: name ?? this.name,
      room: room ?? this.room,
      type: type ?? this.type,
      status: status ?? this.status,
      isOn: isOn ?? this.isOn,
      brightness: brightness ?? this.brightness,
      speed: speed ?? this.speed,
      temperature: temperature ?? this.temperature,
      targetTemperature: targetTemperature ?? this.targetTemperature,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      mqttTopic: mqttTopic ?? this.mqttTopic,
      localIp: localIp ?? this.localIp,
      lastSeen: lastSeen ?? this.lastSeen,
      signalStrength: signalStrength ?? this.signalStrength,
      schedules: schedules ?? this.schedules,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'room': room,
      'type': type.name,
      'status': status.name,
      'isOn': isOn,
      'brightness': brightness,
      'speed': speed,
      'temperature': temperature,
      'targetTemperature': targetTemperature,
      'firmwareVersion': firmwareVersion,
      'mqttTopic': mqttTopic,
      'localIp': localIp,
      'lastSeen': lastSeen.toIso8601String(),
      'signalStrength': signalStrength,
      'schedules': schedules.map((s) => s.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Device.fromJson(String id, Map<String, dynamic> json) {
    return Device(
      id: id,
      name: json['name'] as String? ?? '',
      room: json['room'] as String? ?? '',
      type: DeviceType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => DeviceType.light,
      ),
      status: DeviceStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => DeviceStatus.offline,
      ),
      isOn: json['isOn'] as bool? ?? false,
      brightness: (json['brightness'] as num?)?.toDouble() ?? 100,
      speed: (json['speed'] as num?)?.toInt() ?? 1,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 24.0,
      targetTemperature: (json['targetTemperature'] as num?)?.toDouble() ?? 24.0,
      firmwareVersion: json['firmwareVersion'] as String?,
      mqttTopic: json['mqttTopic'] as String?,
      localIp: json['localIp'] as String?,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : DateTime.now(),
      signalStrength: (json['signalStrength'] as num?)?.toInt() ?? 0,
      schedules: (json['schedules'] as List<dynamic>?)
              ?.map((s) => DeviceSchedule.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
