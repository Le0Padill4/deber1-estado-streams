import 'package:flutter/material.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/decrementar.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/obtener_contador.dart';
import 'presentation/pantallas/pantalla_visor.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ContadorPrefsRepository();
    return ContadorApp(
      obtenerContador: ObtenerContador(repository),
      incrementar: Incrementar(repository),
      decrementar: Decrementar(repository),
    );
  }
}

class ContadorApp extends StatelessWidget {
  const ContadorApp({
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
    super.key,
  });

  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Contador compartido',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    home: PantallaVisor(
      obtenerContador: obtenerContador,
      incrementar: incrementar,
      decrementar: decrementar,
    ),
  );
}
