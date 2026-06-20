import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../config/theme.dart';
import '../../models/device.dart';
import '../../services/ble_service.dart';
import '../../providers/device_provider.dart';
import '../../providers/room_provider.dart';

class AddDeviceScreen extends ConsumerStatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  ConsumerState<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends ConsumerState<AddDeviceScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Step 2: BLE
  final BleService _bleService = BleService();
  final List<BleDevice> _foundDevices = [];
  BleDevice? _selectedDevice;
  bool _isScanning = false;
  String? _scanError;

  // Step 3: Wi-Fi
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSendingWifi = false;

  // Step 4: Connecting
  String? _connectError;
  int _connectAttempts = 0;

  // Step 5: Success
  final _deviceNameController = TextEditingController();
  String _selectedRoom = '';
  DeviceType _selectedType = DeviceType.light;
  bool _isSaving = false;

  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _deviceNameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _ssidController.dispose();
    _passwordController.dispose();
    _deviceNameController.dispose();
    _bleService.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _foundDevices.clear();
      _scanError = null;
    });

    try {
      await _bleService.startScan(
        onDeviceFound: (device) {
          if (mounted) {
            setState(() => _foundDevices.add(device));
          }
        },
      );
    } catch (e) {
      setState(() => _scanError = 'Failed to scan for devices');
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _sendWifiCredentials() async {
    if (_selectedDevice == null) return;
    setState(() {
      _isSendingWifi = true;
    });

    try {
      await _bleService.sendWifiCredentials(
        deviceId: _selectedDevice!.id,
        ssid: _ssidController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) _nextStep();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send Wi-Fi credentials')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSendingWifi = false);
    }
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveDevice() async {
    setState(() => _isSaving = true);
    try {
      final deviceId = _uuid.v4();
      final device = Device(
        id: deviceId,
        name: _deviceNameController.text.trim(),
        room: _selectedRoom,
        type: _selectedType,
        status: DeviceStatus.online,
        lastSeen: DateTime.now(),
      );
      await ref.read(firestoreServiceProvider).addDevice(device);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${device.name} added successfully'),
            backgroundColor: AppTheme.statusGreen,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save device')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBg,
      appBar: AppBar(
        title: const Text('Add Device'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _StepIndicator(currentStep: _currentStep, totalSteps: 4),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
                _buildStep5(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 1: Instructions
  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.accentTeal.withAlpha(20),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.bluetooth_searching,
              color: AppTheme.accentTeal,
              size: 48,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Prepare Your Device',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _InstructionStep(
            number: 1,
            text: 'Plug in your ESP32 device',
          ),
          _InstructionStep(
            number: 2,
            text: 'Press and hold the setup button for 3 seconds',
          ),
          _InstructionStep(
            number: 3,
            text: 'Wait for the LED to blink blue (setup mode)',
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextStep,
              child: const Text('Device is ready'),
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: BLE Scan
  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Your Device',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose your ESP32 device from the list below',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isScanning ? null : _startScan,
              icon: _isScanning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(_isScanning ? 'Scanning...' : 'Scan for Devices'),
            ),
          ),
          const SizedBox(height: 16),
          if (_scanError != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.statusRed.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: AppTheme.statusRed, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _scanError!,
                      style: const TextStyle(color: AppTheme.statusRed),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: _foundDevices.isEmpty
                ? Center(
                    child: Text(
                      _isScanning
                          ? 'Searching for nearby devices...'
                          : 'No devices found. Tap Scan to search.',
                      style: TextStyle(
                        color: AppTheme.textSecondary.withAlpha(120),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _foundDevices.length,
                    itemBuilder: (context, index) {
                      final device = _foundDevices[index];
                      final isSelected =
                          _selectedDevice?.id == device.id;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.accentTeal.withAlpha(20)
                              : AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accentTeal
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.accentTeal.withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.memory,
                              color: AppTheme.accentTeal,
                            ),
                          ),
                          title: Text(
                            device.name,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'Signal: ${device.rssi} dBm',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Radio<String>(
                            value: device.id,
                            groupValue: _selectedDevice?.id,
                            activeColor: AppTheme.accentTeal,
                            onChanged: (_) {
                              setState(() => _selectedDevice = device);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _selectedDevice != null ? _nextStep : null,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Wi-Fi Credentials
  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wi-Fi Setup',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter your home Wi-Fi credentials',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _ssidController,
            decoration: const InputDecoration(
              labelText: 'Wi-Fi SSID',
              prefixIcon: Icon(Icons.wifi_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _ssidController.text.trim().isNotEmpty && !_isSendingWifi
                      ? _sendWifiCredentials
                      : null,
              child: _isSendingWifi
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send to Device'),
            ),
          ),
        ],
      ),
    );
  }

  // Step 4: Connecting
  Widget _buildStep4() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppTheme.accentTeal),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Connecting Device',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your device is connecting to Wi-Fi.\nThis may take up to 30 seconds.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (_connectError != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.statusRed.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _connectError!,
                style: const TextStyle(color: AppTheme.statusRed),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _connectError = null;
                  _connectAttempts++;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.accentTeal,
                side: const BorderSide(color: AppTheme.accentTeal),
              ),
            ),
          ] else ...[
            const SizedBox(height: 24),
            Text(
              'Attempt ${_connectAttempts + 1}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Simulate connection success (in production, poll ESP32)
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) _nextStep();
                });
              },
              child: const Text('Continue (Demo)'),
            ),
          ),
        ],
      ),
    );
  }

  // Step 5: Success / Naming
  Widget _buildStep5() {
    final roomsAsync = ref.watch(roomsStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.statusGreen.withAlpha(20),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppTheme.statusGreen,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Device Connected!',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _deviceNameController,
            decoration: const InputDecoration(
              labelText: 'Device Name',
              prefixIcon: Icon(Icons.label_outline),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedRoom.isEmpty ? null : _selectedRoom,
            decoration: const InputDecoration(
              labelText: 'Room',
              prefixIcon: Icon(Icons.room_outlined),
            ),
            items: [
              const DropdownMenuItem(
                value: '',
                child: Text('Select a room',
                    style: TextStyle(color: AppTheme.textSecondary)),
              ),
              ...roomsAsync.valueOrNull?.map((room) =>
                      DropdownMenuItem(
                        value: room.name,
                        child: Text(room.name),
                      )) ??
                  [],
            ],
            onChanged: (v) => setState(() => _selectedRoom = v ?? ''),
            dropdownColor: AppTheme.surfaceColor,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<DeviceType>(
            value: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Device Type',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: DeviceType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.name
                    .replaceAll('_', ' ')
                    .split(' ')
                    .map((w) => w[0].toUpperCase() + w.substring(1))
                    .join(' ')),
              );
            }).toList(),
            onChanged: (v) => setState(() => _selectedType = v ?? DeviceType.light),
            dropdownColor: AppTheme.surfaceColor,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _deviceNameController.text.trim().isNotEmpty &&
                      _selectedRoom.isNotEmpty &&
                      !_isSaving
                  ? _saveDevice
                  : null,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add Device'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index <= currentStep;
          final isLast = index == totalSteps - 1;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.accentTeal
                        : AppTheme.surfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive
                            ? const Color(0xFF1A1B2F)
                            : AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isActive
                          ? AppTheme.accentTeal
                          : AppTheme.textSecondary.withAlpha(40),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  final int number;
  final String text;

  const _InstructionStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.accentTeal.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: AppTheme.accentTeal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
