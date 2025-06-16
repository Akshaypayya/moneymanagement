import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<bool?> showBiometricEnableSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<bool>(
    context: context,
    isDismissible: false,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fingerprint, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Enable Fingerprint Login?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Would you like to enable fingerprint (biometric) authentication for faster and more secure login?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Not Now'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Enable'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
