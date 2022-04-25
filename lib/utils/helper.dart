class Helper {
  static parseBool(String value) {
    return value.toLowerCase() == 'true';
  }

  static boolToString(bool value) {
    return value ? 'true' : 'false';
  }
}