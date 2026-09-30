import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/repositories/conexion_repository.dart';

class ConexionPlusRepository implements ConexionRepository {
  ConexionPlusRepository({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  EstadoConexion _traducir(List<ConnectivityResult> resultados) {
    if (resultados.contains(ConnectivityResult.wifi)) {
      return EstadoConexion.wifi;
    }
    if (resultados.contains(ConnectivityResult.mobile)) {
      return EstadoConexion.datosMoviles;
    }
    if (resultados.isEmpty || resultados.contains(ConnectivityResult.none)) {
      return EstadoConexion.sinConexion;
    }
    return EstadoConexion.otro;
  }

  @override
  Future<EstadoConexion> consultarAhora() async =>
      _traducir(await _connectivity.checkConnectivity());

  @override
  Stream<EstadoConexion> observarCambios() =>
      _connectivity.onConnectivityChanged.map(_traducir);
}
