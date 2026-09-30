import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/main.dart';
import 'package:parte_a_contador/presentation/estado/contador_provider.dart';

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
  testWidgets('El visor comparte el contador al volver con atrás', (
    tester,
  ) async {
    final repositorio = _RepositorioEnMemoria();
    ProviderScope crearApp() => ProviderScope(
      overrides: [contadorRepositoryProvider.overrideWithValue(repositorio)],
      child: const ContadorApp(),
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
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Contador: 2'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();
    expect(find.text('Contador: 2'), findsOneWidget);
  });
}
