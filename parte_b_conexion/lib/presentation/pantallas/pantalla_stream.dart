import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';
import '../estado/conexion_cubit.dart';

class PantallaStream extends StatelessWidget {
  const PantallaStream({
    required this.consultarConexion,
    required this.observarConexion,
    super.key,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ConexionCubit(
      consultarConexion: consultarConexion,
      observarConexion: observarConexion,
    )..iniciar(),
    child: const _ContenidoStream(),
  );
}

class _ContenidoStream extends StatefulWidget {
  const _ContenidoStream();

  @override
  State<_ContenidoStream> createState() => _ContenidoStreamState();
}

class _ContenidoStreamState extends State<_ContenidoStream> {
  int _cambiosRecibidos = 0;

  String _nombre(EstadoConexion estado) => switch (estado) {
    EstadoConexion.wifi => 'Wi-Fi',
    EstadoConexion.datosMoviles => 'Datos móviles',
    EstadoConexion.otro => 'Otra conexión',
    EstadoConexion.sinConexion => 'Sin conexión',
  };

  IconData _icono(EstadoConexion estado) => switch (estado) {
    EstadoConexion.wifi => Icons.wifi,
    EstadoConexion.datosMoviles => Icons.signal_cellular_alt,
    EstadoConexion.otro => Icons.device_hub,
    EstadoConexion.sinConexion => Icons.wifi_off,
  };

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<ConexionCubit, EstadoConexion>(
        listener: (context, estado) => setState(() {
          _cambiosRecibidos = context.read<ConexionCubit>().cambiosRecibidos;
        }),
        builder: (context, estado) {
          final conectado = estado != EstadoConexion.sinConexion;
          final color = conectado ? Colors.green : Colors.red;
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_icono(estado), size: 72, color: color),
                const SizedBox(height: 12),
                Text(
                  _nombre(estado),
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(color: color),
                ),
                const SizedBox(height: 8),
                Text('Cambios recibidos: $_cambiosRecibidos'),
              ],
            ),
          );
        },
      );
}
