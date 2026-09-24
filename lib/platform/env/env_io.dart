import 'dart:io';

import '../../domain/ports/env_info.dart';

EnvInfo createEnvInfo() => IoEnvInfo();

class IoEnvInfo implements EnvInfo {
  @override
  String get platformName {
    final version = Platform.operatingSystemVersion;
    // Windows 11 у реєстрі досі називає себе «Windows 10»,
    // відрізнити їх можна лише за номером збірки (з 22000).
    final build = RegExp(r'Build (\d+)').firstMatch(version)?.group(1);
    if (build != null && int.parse(build) >= 22000) {
      return 'Windows 11 (збірка $build)';
    }
    return version;
  }

  @override
  String get storageLocation => 'Файл devboard_notes.json у папці документів';
}
