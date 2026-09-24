import '../domain/note.dart';
import '../domain/ports/note_storage.dart';

class NoteRepository {
  NoteRepository(this._storage);
  final NoteStorage _storage;

  List<Note>? _cache;

  // Годинник Windows може повернути той самий час для двох швидких додавань,
  // тому до часу в id додаємо лічильник.
  int _seq = 0;

  Future<List<Note>> getAll() async => _cache ??= await _storage.readAll();

  Future<void> add(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Порожня нотатка не зберігається');
    }
    final now = DateTime.now();
    final note = Note(
      id: '${now.microsecondsSinceEpoch}-${_seq++}',
      text: trimmed,
      createdAt: now,
    );
    _cache = [...await getAll(), note];
    await _storage.writeAll(_cache!);
  }

  Future<void> remove(String id) async {
    _cache = (await getAll()).where((n) => n.id != id).toList();
    await _storage.writeAll(_cache!);
  }
}
