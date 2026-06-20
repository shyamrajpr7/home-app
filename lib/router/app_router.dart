import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/dashboard/room_detail_screen.dart';
import '../screens/devices/add_device_screen.dart';
import '../screens/devices/device_detail_screen.dart';
import '../screens/automation/create_scene_screen.dart';
import '../models/room.dart';
import '../models/device.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: ':tab',
            builder: (context, state) => HomeScreen(
              tab: state.pathParameters['tab'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/room/:roomId',
        builder: (context, state) {
          final room = state.extra as Room;
          return RoomDetailScreen(room: room);
        },
      ),
      GoRoute(
        path: '/add-device',
        builder: (context, state) => const AddDeviceScreen(),
      ),
      GoRoute(
        path: '/device/:deviceId',
        builder: (context, state) {
          final device = state.extra as Device;
          return DeviceDetailScreen(device: device);
        },
      ),
      GoRoute(
        path: '/create-scene',
        builder: (context, state) => const CreateSceneScreen(),
      ),
    ],
  );
});
