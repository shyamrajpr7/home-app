class AppConstants {
  static const String appName = 'HomeAuto';
  static const String appVersion = '1.0.0';

  // Firebase
  static const String firebaseApiKey = 'AIzaSyAkUbXluy_z2IcF0b0R0vyx-Rnknp-jYTM';
  static const String firebaseAppId = '1:620303359377:android:4562b1a767c8a1f97e0e30';
  static const String firebaseMessagingSenderId = '620303359377';
  static const String firebaseProjectId = 'homeautomation-55779';

  // Set to true to bypass Firebase Auth for development
  static const bool devBypass = true;

  // Firestore collections
  static const String usersCollection = 'users';
  static const String devicesCollection = 'devices';
  static const String roomsCollection = 'rooms';
  static const String scenesCollection = 'scenes';

  // MQTT
  static const String mqttBrokerUrl = 'broker.emqx.io';
  static const int mqttPort = 1883;
  static const String mqttPublishTopic = 'home/{uid}/{deviceId}/set';
  static const String mqttSubscribeTopic = 'home/{uid}/{deviceId}/state';
  static const String mqttClientIdPrefix = 'home_auto_';

  // BLE
  static const String bleServiceUUID = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  static const String bleCharacteristicUUID = 'beb5483e-36e1-4688-b7f5-ea07361b26a8';

  // Animation durations
  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration mediumAnim = Duration(milliseconds: 400);
  static const Duration longAnim = Duration(milliseconds: 600);

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Card radius
  static const double cardRadiusSm = 12.0;
  static const double cardRadiusMd = 16.0;
  static const double cardRadiusLg = 20.0;
}
