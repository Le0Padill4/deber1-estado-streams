import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  ConexionCubit({
    required this.consultarConexion,
    required this.observarConexion,
  }) : super(EstadoConexion.otro);

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;
  StreamSubscription<EstadoConexion>? _subscription;
  int cambiosRecibidos = 0;

  Future<void> iniciar() async {
    emit(await consultarConexion());
    _subscription = observarConexion().listen(
      (estado) {
        cambiosRecibidos++;
        emit(estado);
      },
      onError: (Object error, StackTrace stackTrace) =>
          emit(EstadoConexion.otro),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
