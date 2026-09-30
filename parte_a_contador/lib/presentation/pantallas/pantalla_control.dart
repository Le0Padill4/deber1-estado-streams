import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';

class PantallaControl extends StatefulWidget {
  const PantallaControl({
    required this.valorInicial,
    required this.incrementar,
    required this.decrementar,
    super.key,
  });

  final int valorInicial;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaControl> createState() => _PantallaControlState();
}

class _PantallaControlState extends State<PantallaControl> {
  late int _contador = widget.valorInicial;

  Future<void> _incrementar() async {
    final valor = await widget.incrementar();
    if (mounted) setState(() => _contador = valor);
  }

  Future<void> _decrementar() async {
    final valor = await widget.decrementar();
    if (mounted) setState(() => _contador = valor);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Control')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Contador: $_contador', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 24),
              FilledButton(onPressed: _incrementar, child: const Text('+1')),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: _decrementar, child: const Text('-1')),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(_contador),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
}
