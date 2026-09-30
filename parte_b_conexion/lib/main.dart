import 'package:flutter/material.dart';

import 'data/repositories/conexion_plus_repository.dart';
import 'domain/usecases/consultar_conexion.dart';
import 'domain/usecases/observar_conexion.dart';
import 'presentation/pantallas/pantalla_foto.dart';
import 'presentation/pantallas/pantalla_stream.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ConexionPlusRepository();
    return ConexionApp(
      consultarConexion: ConsultarConexion(repository),
      observarConexion: ObservarConexion(repository),
    );
  }
}

class ConexionApp extends StatelessWidget {
  const ConexionApp({
    required this.consultarConexion,
    required this.observarConexion,
    super.key,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Future vs Stream',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
    home: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Estado de conexión'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Con Future'),
              Tab(text: 'Con Stream'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PantallaFoto(consultarConexion: consultarConexion),
            PantallaStream(
              consultarConexion: consultarConexion,
              observarConexion: observarConexion,
            ),
          ],
        ),
      ),
    ),
  );
}
