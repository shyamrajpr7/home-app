import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mqtt_service.dart';

final mqttServiceProvider = Provider<MqttService>((ref) => MqttService());

final mqttConnectionStateProvider = StateProvider<bool>((ref) => false);

final deviceMqttStateProvider =
    StateProvider.family<Map<String, dynamic>, String>(
  (ref, deviceId) => {},
);
