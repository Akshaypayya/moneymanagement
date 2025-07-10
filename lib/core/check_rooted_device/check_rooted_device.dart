import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';

final jailbreakErrorProvider = StateProvider<String>((ref) => '');

Future<bool> isVpnActive() async {
  try {
    final interfaces = await NetworkInterface.list(includeLoopback: false, type: InternetAddressType.any);
    for (final iface in interfaces) {
      final name = iface.name.toLowerCase();
      if (name.contains("tun") || name.contains("ppp") || name.contains("ipsec")) {
        return true;
      }
    }
  } catch (e) {
    debugPrint("VPN detection failed: $e");
  }
  return false;
}

final isDeviceSecureProvider = FutureProvider<bool>((ref) async {
  final issues = await JailbreakRootDetection.instance.checkForIssues;

  final Map<String, String> issueMessages = {
    'debugged': 'USB Debugging is turned on.',
    'devMode': 'Developer mode is enabled.',
    'jailbroken': 'Device is jailbroken or rooted.',
    'externalStorage': 'App is installed on external storage.',
    'dangerousAppInstalled': 'A potentially dangerous app is installed.',
    'notRealDevice': 'Running on an emulator or virtual device.',
    'magisk': 'Magisk detected on the device.',
    'suExists': '`su` binary found – root access possible.',
    'xposed': 'Xposed framework is installed.',
  };

  final issueDescriptions = issues.map((e) => issueMessages[e.name] ?? e.name).toList();

  // VPN Check
  final isVpn = await isVpnActive();
  if (isVpn) {
    issueDescriptions.add('VPN is active. Please disable VPN to continue.');
  }

  final message = issueDescriptions.isEmpty
      ? ''
      : 'Issues detected:\n\n• ${issueDescriptions.join('\n• ')}';

  ref.read(jailbreakErrorProvider.notifier).state = message;

  return issueDescriptions.isEmpty;
});
