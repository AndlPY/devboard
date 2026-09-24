import 'package:flutter/services.dart';

import '../../domain/ports/clipboard_port.dart';

ClipboardPort createClipboardPort() => FlutterClipboard();

class FlutterClipboard implements ClipboardPort {
  @override
  Future<void> copyText(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } on PlatformException catch (e) {
      throw ClipboardFailure(e.message ?? e.code);
    }
  }

  @override
  Future<String> readText() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      return data?.text ?? '';
    } on PlatformException catch (e) {
      throw ClipboardFailure(e.message ?? e.code);
    }
  }
}
