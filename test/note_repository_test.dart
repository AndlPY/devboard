import 'package:devboard/data/note_repository.dart';
import 'package:devboard/domain/note.dart';
import 'package:devboard/domain/ports/note_storage.dart';
import 'package:flutter_test/flutter_test.dart';

/// Третя реалізація порту — список у пам'яті. Доводить, що порт не протікає.
class InMemoryNoteStorage implements NoteStorage {
  List<Note> saved = [];

  @override
  Future<List<Note>> readAll() async => saved;

  @override
  Future<void> writeAll(List<Note> notes) async => saved = notes;
}

void main() {
  late InMemoryNoteStorage storage;
  late NoteRepository repository;

  setUp(() {
    storage = InMemoryNoteStorage();
    repository = NoteRepository(storage);
  });

  test('add зберігає обрізаний текст у сховище', () async {
    await repository.add('  купити каву  ');

    expect(storage.saved.single.text, 'купити каву');
  });

  test('порожня нотатка не зберігається', () async {
    await expectLater(repository.add('   '), throwsArgumentError);
    expect(storage.saved, isEmpty);
  });

  test('remove видаляє нотатку за id', () async {
    await repository.add('перша');
    await repository.add('друга');

    await repository.remove(storage.saved.first.id);

    expect(storage.saved.map((n) => n.text), ['друга']);
  });

  test('нотатки читаються новим репозиторієм (між запусками)', () async {
    await repository.add('залишуся');

    final restarted = NoteRepository(storage);

    expect((await restarted.getAll()).single.text, 'залишуся');
  });
}
