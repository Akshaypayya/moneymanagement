import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clipboardProvider = Provider<ClipboardService>((ref) {
  return ClipboardService();
});

class ClipboardService {
  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
