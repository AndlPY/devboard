import '../domain/note.dart';
import '../domain/ports/note_storage.dart';

class NoteRepository {
  NoteRepository(this._storage);
  final NoteStorage _storage;

  List<Note>? _cache;

  Future<List<Note>> getAll() async => _cache ??= await _storage.readAll();

  Future<void> add(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Порожня нотатка не зберігається');
    }
    final notes = await getAll();
    final now = DateTime.now();
    final note = Note(
      // Годинник Windows може повернути той самий час для двох швидких
      // додавань, тому до часу додаємо номер нотатки.
      id: '${now.microsecondsSinceEpoch}-${notes.length}',
      text: trimmed,
      createdAt: now,
    );
    _cache = [...notes, note];
    await _storage.writeAll(_cache!);
  }

  Future<void> remove(String id) async {
    _cache = (await getAll()).where((n) => n.id != id).toList();
    await _storage.writeAll(_cache!);
  }
}
