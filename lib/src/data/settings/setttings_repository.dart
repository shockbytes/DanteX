

abstract class SettingsRepository {

  void setTheme();
  Stream getTheme();

  void setSortingStrategy();
  void getSortingStrategy();

  void setIsTrackingEnabled();
  bool isTrackingEnabled();

  void setIsRandomBooksEnabled();
  bool isRandomBooksEnabled();
}