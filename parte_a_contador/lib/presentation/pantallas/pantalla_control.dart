import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';

class PantallaControl extends StatelessWidget {
  const PantallaControl({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Control')),
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
              onPressed: () => context.read<ContadorCubit>().incrementar(),
              child: const Text('+1'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.read<ContadorCubit>().decrementar(),
              child: const Text('-1'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    ),
  );
}
