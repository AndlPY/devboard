import 'package:flutter/material.dart';

import 'data/note_repository.dart';
import 'platform/clipboard/clipboard.dart';
import 'platform/env/env.dart';
import 'platform/storage/storage.dart';
import 'presentation/notes_page.dart';

void main() {
  // ЄДИНЕ місце у проєкті, яке знає про конкретні реалізації
  runApp(
    DevBoardApp(
      repository: NoteRepository(createNoteStorage()),
      env: createEnvInfo(),
      clipboard: createClipboardPort(),
    ),
  );
}
