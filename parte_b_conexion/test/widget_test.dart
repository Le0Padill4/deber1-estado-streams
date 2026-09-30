import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/main.dart';

class _ConexionEnMemoria implements ConexionRepository {
  final _cambios = StreamController<EstadoConexion>.broadcast();
  EstadoConexion estado = EstadoConexion.wifi;

  @override
  Future<EstadoConexion> consultarAhora() async => estado;

  @override
  Stream<EstadoConexion> observarCambios() => _cambios.stream;

  void cambiar(EstadoConexion nuevoEstado) {
    estado = nuevoEstado;
    _cambios.add(nuevoEstado);
  }

  Future<void> cerrar() => _cambios.close();
}

void main() {
  testWidgets('Future conserva la última consulta hasta volver a pulsar', (
    tester,
  ) async {
    final repositorio = _ConexionEnMemoria();
    addTearDown(repositorio.cerrar);

    await tester.pumpWidget(
      ConexionApp(
        consultarConexion: ConsultarConexion(repositorio),
        observarConexion: ObservarConexion(repositorio),
      ),
    );
    await tester.tap(find.text('Consultar ahora'));
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);

    repositorio.cambiar(EstadoConexion.sinConexion);
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);

    await tester.tap(find.text('Consultar ahora'));
    await tester.pumpAndSettle();
    expect(find.text('Sin conexión'), findsOneWidget);
  });

  testWidgets('Stream cambia la pantalla sin volver a consultar', (
    tester,
  ) async {
    final repositorio = _ConexionEnMemoria();
    addTearDown(repositorio.cerrar);

    await tester.pumpWidget(
      ConexionApp(
        consultarConexion: ConsultarConexion(repositorio),
        observarConexion: ObservarConexion(repositorio),
      ),
    );
    await tester.tap(find.text('Con Stream'));
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(find.text('Cambios recibidos: 0'), findsOneWidget);

    repositorio.cambiar(EstadoConexion.sinConexion);
    await tester.pumpAndSettle();
    expect(find.text('Sin conexión'), findsOneWidget);
    expect(find.text('Cambios recibidos: 1'), findsOneWidget);

    repositorio.cambiar(EstadoConexion.wifi);
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(find.text('Cambios recibidos: 2'), findsOneWidget);
  });
}
