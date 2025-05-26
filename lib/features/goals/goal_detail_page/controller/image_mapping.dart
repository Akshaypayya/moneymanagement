class IconMappingService {
  static Map<String, String> _goalIconMapping = {};

  static void storeGoalIcon(String goalName, String iconName) {
    _goalIconMapping[goalName] = iconName;
    print('ICON MAPPING: Stored $goalName -> $iconName');
  }

  static String? getStoredIcon(String goalName) {
    final icon = _goalIconMapping[goalName];
    print('ICON MAPPING: Retrieved $goalName -> $icon');
    return icon;
  }

  static void clearMapping(String goalName) {
    _goalIconMapping.remove(goalName);
    print('ICON MAPPING: Cleared mapping for $goalName');
  }

  static void clearAllMappings() {
    _goalIconMapping.clear();
    print('ICON MAPPING: Cleared all mappings');
  }

  static Map<String, String> getAllMappings() {
    return Map.from(_goalIconMapping);
  }

  static void debugPrintAllMappings() {
    print('ICON MAPPING: All stored mappings:');
    _goalIconMapping.forEach((goalName, iconName) {
      print('  $goalName -> $iconName');
    });
  }
}
