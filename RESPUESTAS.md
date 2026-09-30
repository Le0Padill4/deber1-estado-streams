# Respuestas — Deber 1: manejo de estado y streams

> **Nota de evidencia:** redacté las respuestas con el código y las verificaciones que sí pude ejecutar. No afirmo haber visto cambios causados por apagar el Wi‑Fi en un teléfono. El emulador Android disponible no inició porque reportó espacio insuficiente para el AVD. Las pruebas marcadas como pendientes requieren que Leonardo las haga en un teléfono Android o en un emulador que arranque.

## Parte A — La misma app, tres veces

### 1. ¿Qué pasó al usar el botón atrás del sistema en la versión `setState`?

**Pendiente de observación en Android.** Según el código, al pulsar `+1`, el caso de uso guarda el nuevo número en `SharedPreferences` y la pantalla Control actualiza su propio estado. Si se sale con atrás del sistema, la ruta termina sin devolver un número al visor. El visor conserva en memoria su `_contador` anterior y por eso puede mostrar un valor desactualizado aunque el disco tenga el nuevo. Al volver a abrir la aplicación, `ObtenerContador` vuelve a leer el valor persistido.

Para mover el dato al usar el botón «Volver» se coordinan cuatro puntos de presentación: el estado del visor, el `Navigator.push` que pasa el número y los casos de uso, el estado de Control y el `Navigator.pop`/resultado que el visor recibe y aplica con `setState`.

### 2. ¿Por qué el botón atrás no rompe el estado con Riverpod? ¿Dónde vive el contador?

En esta implementación, el contador vive en `ContadorNotifier`, accesible mediante `contadorProvider` dentro del `ProviderScope`. Las dos pantallas leen o modifican ese mismo estado; la navegación solo quita una ruta y no necesita devolver un valor. Por eso el visor vuelve a leer el valor compartido cuando se reconstruye. **La navegación con el botón físico queda pendiente de observar en Android.**

### 3. ¿Qué permite ver `BlocObserver` y cuándo sería útil?

El `ContadorObserver` registra en consola cada cambio del Cubit con el formato pedido, por ejemplo `ContadorCubit: 3 -> 4`. Esto deja una secuencia de transiciones que ayuda a encontrar cuándo cambió un estado y qué acción lo produjo; sería útil al investigar un contador que salta o se actualiza en un orden inesperado. Verifiqué que el observador está registrado y que la rama compila; queda pendiente ejecutar la app y copiar una secuencia real de la consola.

### 4. ¿Qué demuestran los comandos `git diff`?

Las dos primeras salidas quedaron vacías:

```text
git diff version/setstate version/riverpod -- lib/domain lib/data
(sin salida)

git diff version/setstate version/bloc -- lib/domain lib/data
(sin salida)
```

La tercera salida sí reporta cambios en `presentation`:

```text
 .../lib/presentation/estado/contador_cubit.dart    | 32 +++++++++
 .../presentation/pantallas/pantalla_control.dart   | 81 +++++++++------------
 .../lib/presentation/pantallas/pantalla_visor.dart | 83 +++++++---------------
 3 files changed, 92 insertions(+), 104 deletions(-)
```

Esto demuestra que las tres ramas comparten el mismo `domain` y `data`, mientras reemplazan la capa de presentación para usar distintos administradores de estado. Si cambiara Riverpod por otro paquete, reescribiría `presentation` y su composición en `main.dart`; los casos de uso y el repositorio del contador no tendrían que cambiar.

### 5. ¿Cuál elegiría para una pantalla y para ocho pantallas con cinco datos compartidos?

Para una sola pantalla elegiría `setState`: el estado es local y no necesito instalar ni mantener otra herramienta. Para ocho pantallas que comparten cinco datos elegiría Riverpod en este ejercicio, porque cada pantalla puede observar el estado compartido sin pasárselo por los constructores. Si el equipo necesita transiciones explícitas y trazas para depurar, Cubit también sería una opción razonable.

`setState` sí es la opción correcta cuando el dato solo afecta a un widget o a una pantalla. En ese caso, su sencillez evita una capa de estado que no aporta valor.

## Parte B — Future vs Stream

### 6. ¿Por qué `Future` siguió mostrando Wi‑Fi después de apagarlo?

**Pendiente de la prueba con Wi‑Fi real.** La pantalla `PantallaFoto` hace una consulta puntual al pulsar el botón y guarda el resultado junto con la hora de esa consulta. No escucha cambios posteriores. Por eso, si se apaga el Wi‑Fi después, la pantalla conserva un dato que era correcto al consultarlo, pero corresponde a un momento anterior; al pulsar «Consultar ahora» obtiene una nueva foto.

### 7. ¿Qué pasaría si se elimina `cancel()` de `close()`?

Cada vez que se abre la pantalla Stream se crea un Cubit que se suscribe a los cambios del sistema. Al salir de la pantalla, `BlocProvider` cierra el Cubit. Si `close()` no cancelara su `StreamSubscription`, esa escucha podría quedar activa después de cerrar la pantalla. Al entrar y salir muchas veces, se acumularían suscripciones innecesarias y cada cambio podría seguir llegando a Cubits que ya no se usan. El código actual guarda la suscripción y la cancela con `await` en `close()`.

### 8. ¿Por qué Future es una foto y Stream una película?

Un `Future` consulta la conexión una vez: puede mostrar Wi‑Fi en el momento de la consulta y conservar ese resultado aunque después se pierda la señal. Un `Stream` mantiene la escucha abierta y puede avisar que la conexión cambió mientras la pantalla sigue visible. La traducción de esos avisos está implementada; observar el cambio real al apagar y encender Wi‑Fi queda pendiente.

En una app pediría con `Future` el perfil del usuario al abrir su cuenta y la lista de productos al entrar al catálogo. Observaría con `Stream` los mensajes nuevos de un chat y la ubicación mientras se comparte un recorrido.

## Comparación de la Parte A

La tabla describe la implementación que se puede comprobar en el código. Las celdas de navegación indican el comportamiento esperado; el botón físico de Android está pendiente de prueba manual.

| | `setState` | Riverpod | Cubit |
|---|---|---|---|
| ¿Dónde vive el contador? | En `_contador`, dentro del `State` del visor; Control mantiene su propio estado mientras está abierta. | En `ContadorNotifier`, accesible mediante `contadorProvider` y `ProviderScope`. | En el estado entero de `ContadorCubit`, compartido por las rutas mediante `BlocProvider`. |
| ¿Las pantallas se pasan datos? | Sí: el visor pasa el valor y los casos de uso a Control; Control devuelve el valor al visor al tocar «Volver». | No; ambas consultan el provider. | No; ambas consultan el mismo Cubit. |
| Archivos de `presentation/` que se tocaron | `pantalla_visor.dart`, `pantalla_control.dart`. | `contador_provider.dart`, `pantalla_visor.dart`, `pantalla_control.dart`. | `contador_cubit.dart`, `pantalla_visor.dart`, `pantalla_control.dart`. |
| ¿Qué pasa con el botón atrás? | El visor no recibe resultado y puede conservar su número viejo en memoria. **Pendiente de observar en Android.** | El estado compartido permanece disponible al volver. **Pendiente de observar en Android.** | El estado compartido permanece disponible al volver. **Pendiente de observar en Android.** |
| ¿Tuve que tocar `domain/`? | No. | No. | No. |

## Evidencia y checklist de entrega

- Las ramas `version/setstate`, `version/riverpod` y `version/bloc` existen y parten del commit común de `main` que contiene `domain` y `data`.
- `flutter analyze` terminó sin problemas en cada variante de Parte A y en Parte B.
- `flutter build apk --debug` compiló las tres variantes de Parte A y Parte B. Limpié los APK y carpetas de compilación después para recuperar espacio; no forman parte de la estructura pedida.
- Los dos `git diff` de `domain` y `data` no imprimieron diferencias. El `--stat` de `presentation` mostró tres archivos distintos entre `setState` y Cubit (salida copiada en la respuesta 4).
- El dominio no importa Flutter ni paquetes externos. `presentation` no importa `shared_preferences` ni `connectivity_plus`.
- `grep -r 'connectivity' lib/ --include='*.dart' -l` en `parte_b_conexion` devuelve únicamente `lib/data/repositories/conexion_plus_repository.dart`.
- `ConexionPlusRepository` maneja `List<ConnectivityResult>` (connectivity_plus 7.3.1), prioriza Wi‑Fi y luego datos móviles, y reconoce la lista vacía o `none` como sin conexión.
- `ConexionCubit.close()` cancela con `await` su `StreamSubscription` antes de cerrar el Cubit.
- **Pendiente:** observación con el botón atrás en Android, prueba manual de cambios de Wi‑Fi/datos móviles y grabación de `demo.mp4` de 15–20 segundos. No se incluyó un archivo de video vacío o ficticio.
