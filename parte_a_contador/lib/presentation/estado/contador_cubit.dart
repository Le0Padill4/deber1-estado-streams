import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

class ContadorCubit extends Cubit<int> {
  ContadorCubit({
    required this.obtenerContador,
    required this.incrementarCaso,
    required this.decrementarCaso,
  }) : super(0);

  final ObtenerContador obtenerContador;
  final Incrementar incrementarCaso;
  final Decrementar decrementarCaso;

  Future<void> cargar() async => emit(await obtenerContador());
  Future<void> incrementar() async => emit(await incrementarCaso());
  Future<void> decrementar() async => emit(await decrementarCaso());
}

class ContadorObserver extends BlocObserver {
  @override
  void onChange(BlocBase<Object?> bloc, Change<Object?> change) {
    if (bloc is ContadorCubit) {
      // ignore: avoid_print
      print('ContadorCubit: ${change.currentState} -> ${change.nextState}');
    }
    super.onChange(bloc, change);
  }
}
