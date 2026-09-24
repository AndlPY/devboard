import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../../domain/ports/clipboard_port.dart';

ClipboardPort createClipboardPort() => NavigatorClipboard();

/// Async Clipboard API працює лише в безпечному контексті (HTTPS або localhost),
/// а читання браузер дозволяє тільки після згоди користувача.
class NavigatorClipboard implements ClipboardPort {
  web.Clipboard get _clipboard => web.window.navigator.clipboard;

  @override
  Future<void> copyText(String text) async {
    try {
      await _clipboard.writeText(text).toDart;
    } catch (e) {
      throw ClipboardFailure('$e');
    }
  }

  @override
  Future<String> readText() async {
    try {
      return (await _clipboard.readText().toDart).toDart;
    } catch (e) {
      throw ClipboardFailure('$e');
    }
  }
}
