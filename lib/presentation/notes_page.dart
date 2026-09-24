import 'package:flutter/material.dart';

import '../data/note_repository.dart';
import '../domain/note.dart';
import '../domain/ports/clipboard_port.dart';
import '../domain/ports/env_info.dart';

class DevBoardApp extends StatelessWidget {
  const DevBoardApp({
    super.key,
    required this.repository,
    required this.env,
    required this.clipboard,
  });

  final NoteRepository repository;
  final EnvInfo env;
  final ClipboardPort clipboard;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'DevBoard',
    home: NotesPage(repository: repository, env: env, clipboard: clipboard),
  );
}

class NotesPage extends StatefulWidget {
  const NotesPage({
    super.key,
    required this.repository,
    required this.env,
    required this.clipboard,
  });

  final NoteRepository repository;
  final EnvInfo env;
  final ClipboardPort clipboard;

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _input = TextEditingController();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final notes = await widget.repository.getAll();
    setState(() => _notes = notes);
  }

  Future<void> _add() async {
    try {
      await widget.repository.add(_input.text);
      _input.clear();
      await _reload();
    } on ArgumentError catch (e) {
      _show('${e.message}');
    }
  }

  Future<void> _remove(Note note) async {
    await widget.repository.remove(note.id);
    await _reload();
  }

  Future<void> _copy(Note note) async {
    try {
      await widget.clipboard.copyText(note.text);
      _show('Скопійовано в буфер обміну');
    } on ClipboardFailure catch (e) {
      _show('$e');
    }
  }

  Future<void> _paste() async {
    try {
      _input.text += await widget.clipboard.readText();
    } on ClipboardFailure catch (e) {
      _show('$e');
    }
  }

  void _show(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DevBoard')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${widget.env.platformName}\n${widget.env.storageLocation}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    decoration: const InputDecoration(hintText: 'Нова нотатка'),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                IconButton(
                  tooltip: 'Вставити з буфера',
                  icon: const Icon(Icons.content_paste),
                  onPressed: _paste,
                ),
                IconButton(
                  tooltip: 'Додати',
                  icon: const Icon(Icons.add),
                  onPressed: _add,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, i) {
                final note = _notes[i];
                return ListTile(
                  title: Text(note.text),
                  subtitle: Text(_format(note.createdAt)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Копіювати',
                        icon: const Icon(Icons.copy),
                        onPressed: () => _copy(note),
                      ),
                      IconButton(
                        tooltip: 'Видалити',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _remove(note),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 2026-09-24 18:05 — без пакета intl.
  static String _format(DateTime d) => d.toLocal().toString().substring(0, 16);
}
