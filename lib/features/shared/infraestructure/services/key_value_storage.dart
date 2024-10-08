abstract class KeyValueStorage {
  Future<void> setKetValue<T>(String key, T value);

  Future<T?> getValue<T>(String key);

  Future<bool> removeKey(String key);
}
