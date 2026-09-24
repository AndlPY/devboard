abstract interface class ClipboardPort {
  Future<void> copyText(String text);

  /// Текст із буфера обміну; порожній рядок, якщо тексту там немає.
  Future<String> readText();
}

/// Доменна помилка: адаптери перетворюють на неї винятки своєї платформи.
class ClipboardFailure implements Exception {
  const ClipboardFailure(this.message);

  final String message;

  @override
  String toString() => 'Буфер обміну недоступний: $message';
}
