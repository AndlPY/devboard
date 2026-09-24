abstract interface class EnvInfo {
  /// Людиночитана назва платформи: "Windows 11", "Chrome / Web"
  String get platformName;

  /// Де фізично лежать дані — для навчальної демонстрації
  String get storageLocation;
}
