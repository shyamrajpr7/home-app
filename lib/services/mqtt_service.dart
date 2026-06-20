import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/constants.dart' show AppConstants;

class MqttService {
  MqttServerClient? _client;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  StreamController<Map<String, dynamic>>? _messageController;

  Stream<Map<String, dynamic>>? get messages => _messageController?.stream;

  bool get isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  Future<void> connect() async {
    _messageController = StreamController<Map<String, dynamic>>.broadcast();
    await _doConnect();
  }

  Future<void> _doConnect() async {
    final uid = _uid;
    if (uid == null) return;

    _client = MqttServerClient(
      AppConstants.mqttBrokerUrl,
      '${AppConstants.mqttClientIdPrefix}${DateTime.now().millisecondsSinceEpoch}',
    );
    _client!.port = AppConstants.mqttPort;
    _client!.keepAlivePeriod = 60;
    _client!.connectTimeoutPeriod = 5000;
    _client!.autoReconnect = true;
    _client!.onDisconnected = _onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(_client!.clientIdentifier)
        .startClean()
        .withWillTopic('home/$uid/status')
        .withWillMessage('{"online": false}')
        .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect();
      _reconnectAttempts = 0;
    } catch (e) {
      _scheduleReconnect();
      return;
    }

    // Subscribe to all user device state topics
    _client!.updates?.listen(_onMessage);

    // Publish online status
    publish('home/$uid/status', {'online': true});
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (final msg in messages) {
      final topic = msg.topic;
      final payload = msg.payload as MqttPublishMessage;
      final content = utf8.decode(payload.payload.message);
      try {
        final data = jsonDecode(content) as Map<String, dynamic>;
        data['_topic'] = topic;
        _messageController?.add(data);
      } catch (_) {}
    }
  }

  void _onDisconnected() {
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) return;
    _reconnectAttempts++;
    final delay = Duration(
      seconds: (2 ^ _reconnectAttempts).clamp(1, 60),
    );
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, _doConnect);
  }

  void publish(String topic, Map<String, dynamic> message) {
    if (_client == null || !isConnected) return;
    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonEncode(message));
    _client!.publishMessage(
      topic,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }

  void subscribeToDevice(String deviceId) {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _client == null) return;
    final topic = AppConstants.mqttSubscribeTopic
        .replaceAll('{uid}', uid)
        .replaceAll('{deviceId}', deviceId);
    _client!.subscribe(topic, MqttQos.atLeastOnce);
  }

  void unSubscribeFromDevice(String deviceId) {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _client == null) return;
    final topic = AppConstants.mqttSubscribeTopic
        .replaceAll('{uid}', uid)
        .replaceAll('{deviceId}', deviceId);
    _client!.unsubscribe(topic);
  }

  void sendCommand(String deviceId, Map<String, dynamic> command) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final topic = AppConstants.mqttPublishTopic
        .replaceAll('{uid}', uid)
        .replaceAll('{deviceId}', deviceId);
    publish(topic, command);
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    await _messageController?.close();
    if (_uid != null) {
      publish('home/$_uid/status', {'online': false});
    }
    _client?.disconnect();
  }

  String? get _uid {
    if (AppConstants.devBypass) return 'dev_user';
    return _auth.currentUser?.uid;
  }
}
