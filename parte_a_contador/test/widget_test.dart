import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';
import 'package:parte_a_contador/presentation/estado/contador_cubit.dart';
import 'package:parte_a_contador/presentation/pantallas/pantalla_visor.dart';

class _RepositorioEnMemoria implements ContadorRepository {
  int valor = 0;

  @override
  Future<int> leer() async => valor;

  @override
  Future<void> guardar(int nuevoValor) async {
    valor = nuevoValor;
  }
}

void main() {
  testWidgets('Cubit actualiza ambas pantallas y conserva el valor', (
    tester,
  ) async {
    final repositorio = _RepositorioEnMemoria();
    Widget crearApp() => BlocProvider(
      create: (_) => ContadorCubit(
        obtenerContador: ObtenerContador(repositorio),
        incrementarCaso: Incrementar(repositorio),
        decrementarCaso: Decrementar(repositorio),
      )..cargar(),
      child: const MaterialApp(home: PantallaVisor()),
    );

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();
    expect(find.text('Contador: 0'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('-1'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Contador: 1'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();
    expect(find.text('Contador: 1'), findsOneWidget);
  });
}
