# DevBoard

Локальний журнал нотаток на Flutter: один код для **Windows Desktop** і **Web**.
Практична робота «Один додаток — дві платформи», індивідуальний варіант № 1 — `ClipboardPort`.

| Порт (`lib/domain/ports`) | Windows | Web |
|---|---|---|
| `NoteStorage` | файл `devboard_notes.json` (`dart:io`) | `localStorage` |
| `EnvInfo` | `Platform.operatingSystem` | `navigator.userAgent` |
| `ClipboardPort` | `Clipboard` (Flutter) | `navigator.clipboard` |

Адаптер обирається під час компіляції через conditional imports (`lib/platform/*/*.dart`),
конкретні реалізації знає лише composition root — `lib/main.dart`.

```bash
flutter run -d windows
flutter run -d chrome
flutter test
```
