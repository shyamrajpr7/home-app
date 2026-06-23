class DeviceSchedule {
  final String id;
  final int hour;
  final int minute;
  final bool action;
  final List<int> repeatDays;
  final bool isEnabled;

  DeviceSchedule({
    required this.id,
    required this.hour,
    required this.minute,
    required this.action,
    this.repeatDays = const [],
    this.isEnabled = true,
  });

  DeviceSchedule copyWith({
    String? id,
    int? hour,
    int? minute,
    bool? action,
    List<int>? repeatDays,
    bool? isEnabled,
  }) {
    return DeviceSchedule(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      action: action ?? this.action,
      repeatDays: repeatDays ?? this.repeatDays,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'hour': hour,
        'minute': minute,
        'action': action,
        'repeatDays': repeatDays,
        'isEnabled': isEnabled,
      };

  factory DeviceSchedule.fromJson(Map<String, dynamic> json) => DeviceSchedule(
        id: json['id'] as String,
        hour: json['hour'] as int,
        minute: json['minute'] as int,
        action: json['action'] as bool,
        repeatDays: (json['repeatDays'] as List<dynamic>?)?.cast<int>() ?? [],
        isEnabled: json['isEnabled'] as bool? ?? true,
      );

  String get timeString {
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${h.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  String get repeatLabel {
    if (repeatDays.isEmpty) return 'Once';
    if (repeatDays.length == 7) return 'Everyday';
    if (repeatDays.length == 5 &&
        repeatDays.every((d) => d >= 0 && d <= 4)) {
      return 'Weekdays';
    }
    if (repeatDays.length == 2 &&
        repeatDays.contains(5) &&
        repeatDays.contains(6)) {
      return 'Weekends';
    }
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return repeatDays.map((d) => dayNames[d]).join(', ');
  }
}
