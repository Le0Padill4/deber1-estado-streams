import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';
import 'pantalla_control.dart';

class PantallaVisor extends StatelessWidget {
  const PantallaVisor({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Visor')),
    body: Center(
      child: BlocBuilder<ContadorCubit, int>(
        builder: (context, contador) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contador: $contador',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PantallaControl(),
                ),
              ),
              child: const Text('Ir a Control'),
            ),
          ],
        ),
      ),
    ),
  );
}
