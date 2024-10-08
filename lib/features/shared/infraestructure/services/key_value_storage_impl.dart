import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage.dart';

//* clase que me servira para almacenar en el dispositivo local
//* Se esta implementado elpatron adaptador para hacer mas facil mudarse de tecnologias como(Isar, etc)
//*sin tener que refactorizar todo el codigo

class KeyValueStorageImpl extends KeyValueStorage {
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      case int:
        return prefs.getInt(key) as T?;
      case String:
        return prefs.getString(key) as T?;
      default:
        throw UnimplementedError(
            'Get not implemented for type ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKetValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();

    if (value is int) {
      prefs.setInt(key, value as int);
    } else if (value is String) {
      prefs.setString(key, value as String);
    } else {
      throw UnimplementedError('Set not implemented for type ${T.runtimeType}');
    }
  }
}
