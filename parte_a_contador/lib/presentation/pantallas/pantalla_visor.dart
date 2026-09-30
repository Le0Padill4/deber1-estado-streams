import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';
import 'pantalla_control.dart';

class PantallaVisor extends StatefulWidget {
  const PantallaVisor({
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
    super.key,
  });

  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaVisor> createState() => _PantallaVisorState();
}

class _PantallaVisorState extends State<PantallaVisor> {
  int _contador = 0;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final valor = await widget.obtenerContador();
    if (mounted) setState(() => _contador = valor);
  }

  Future<void> _irAControl() async {
    final resultado = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => PantallaControl(
          valorInicial: _contador,
          incrementar: widget.incrementar,
          decrementar: widget.decrementar,
        ),
      ),
    );
    if (resultado != null && mounted) setState(() => _contador = resultado);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Visor')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Contador: $_contador', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 24),
              FilledButton(onPressed: _irAControl, child: const Text('Ir a Control')),
            ],
          ),
        ),
      );
}
