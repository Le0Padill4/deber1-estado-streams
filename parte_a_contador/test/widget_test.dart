import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';
import 'package:parte_a_contador/main.dart';

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
  testWidgets('Volver actualiza el visor; atrás no lo actualiza', (
    tester,
  ) async {
    final repositorio = _RepositorioEnMemoria();
    ContadorApp crearApp() => ContadorApp(
      obtenerContador: ObtenerContador(repositorio),
      incrementar: Incrementar(repositorio),
      decrementar: Decrementar(repositorio),
    );

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();
    expect(find.text('Contador: 0'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 1'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Contador: 1'), findsOneWidget);
    expect(await repositorio.leer(), 2);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();
    expect(find.text('Contador: 2'), findsOneWidget);
  });
}
