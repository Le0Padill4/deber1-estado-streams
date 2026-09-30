import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';

class PantallaFoto extends StatefulWidget {
  const PantallaFoto({required this.consultarConexion, super.key});

  final ConsultarConexion consultarConexion;

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto> {
  EstadoConexion? _estado;
  DateTime? _horaConsulta;
  bool _consultando = false;

  Future<void> _consultar() async {
    setState(() => _consultando = true);
    try {
      final estado = await widget.consultarConexion();
      if (!mounted) return;
      setState(() {
        _estado = estado;
        _horaConsulta = DateTime.now();
      });
    } finally {
      if (mounted) setState(() => _consultando = false);
    }
  }

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
  Widget build(BuildContext context) {
    final estado = _estado;
    final color = estado == null || estado == EstadoConexion.sinConexion
        ? Colors.red
        : Colors.green;
    final hora = _horaConsulta;
    final horaTexto = hora == null
        ? 'Todavía no consultado'
        : '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}:${hora.second.toString().padLeft(2, '0')}';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            estado == null ? Icons.help_outline : _icono(estado),
            size: 72,
            color: color,
          ),
          const SizedBox(height: 12),
          Text(
            estado == null ? 'Pulsa para consultar' : _nombre(estado),
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(color: color),
          ),
          const SizedBox(height: 8),
          Text('Consulta: $horaTexto'),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _consultando ? null : _consultar,
            child: Text(_consultando ? 'Consultando…' : 'Consultar ahora'),
          ),
        ],
      ),
    );
  }
}
