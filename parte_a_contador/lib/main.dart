import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/decrementar.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/obtener_contador.dart';
import 'presentation/estado/contador_cubit.dart';
import 'presentation/pantallas/pantalla_visor.dart';

void main() {
  Bloc.observer = ContadorObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ContadorPrefsRepository();
    return BlocProvider(
      create: (_) => ContadorCubit(
        obtenerContador: ObtenerContador(repository),
        incrementarCaso: Incrementar(repository),
        decrementarCaso: Decrementar(repository),
      )..cargar(),
      child: MaterialApp(
        title: 'Contador compartido',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const PantallaVisor(),
      ),
    );
  }
}
