import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/constants.dart';
import '../models/device.dart';
import '../models/room.dart';
import '../models/scene.dart';
import '../models/home_user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    if (AppConstants.devBypass) return 'dev_user';
    return _auth.currentUser!.uid;
  }

  DocumentReference get _userDoc =>
      _db.collection('users').doc(_uid);
  CollectionReference get _devices =>
      _userDoc.collection('devices');
  CollectionReference get _rooms =>
      _userDoc.collection('rooms');
  CollectionReference get _scenes =>
      _userDoc.collection('scenes');

  // User profile
  Future<void> saveUserProfile(HomeUser user) async {
    await _db.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<HomeUser?> getUserProfile() async {
    final doc = await _db.collection('users').doc(_uid).get();
    if (!doc.exists) return null;
    return HomeUser.fromJson(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    await _db.collection('users').doc(_uid).update(data);
  }

  // Devices
  Stream<List<Device>> getDevices() {
    return _devices.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  Device.fromJson(doc.id, doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  Future<void> addDevice(Device device) async {
    await _devices.doc(device.id).set(device.toJson());
  }

  Future<void> updateDevice(String deviceId, Map<String, dynamic> data) async {
    await _devices.doc(deviceId).update(data);
  }

  Future<void> removeDevice(String deviceId) async {
    await _devices.doc(deviceId).delete();
  }

  Stream<Device?> getDevice(String deviceId) {
    return _devices.doc(deviceId).snapshots().map(
          (doc) => doc.exists
              ? Device.fromJson(doc.id, doc.data() as Map<String, dynamic>)
              : null,
        );
  }

  // Rooms
  Stream<List<Room>> getRooms() {
    return _rooms.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  Room.fromJson(doc.id, doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  Future<void> addRoom(Room room) async {
    await _rooms.doc(room.id).set(room.toJson());
  }

  Future<void> removeRoom(String roomId) async {
    await _rooms.doc(roomId).delete();
  }

  // Scenes
  Stream<List<Scene>> getScenes() {
    return _scenes.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  Scene.fromJson(doc.id, doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  Future<void> addScene(Scene scene) async {
    await _scenes.doc(scene.id).set(scene.toJson());
  }

  Future<void> updateScene(String sceneId, Map<String, dynamic> data) async {
    await _scenes.doc(sceneId).update(data);
  }

  Future<void> removeScene(String sceneId) async {
    await _scenes.doc(sceneId).delete();
  }
}
