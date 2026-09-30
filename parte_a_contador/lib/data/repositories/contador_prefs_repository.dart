import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/contador_repository.dart';

class ContadorPrefsRepository implements ContadorRepository {
  static const _clave = 'contador';
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  @override
  Future<int> leer() async => await _preferences.getInt(_clave) ?? 0;

  @override
  Future<void> guardar(int valor) => _preferences.setInt(_clave, valor);
}
