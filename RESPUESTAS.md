# Respuestas — Deber 1

## Parte A — La misma app, tres veces

### 1. ¿Qué pasó al usar el botón atrás del sistema en la versión `setState`?

Pulsé +1 tres veces y Volver: el visor mostró 3, incluso después de reabrir la app. Luego sumé una vez más y salí con atrás de Android. El visor siguió en 3, pero al reabrir apareció 4. El número sí se guardó; la pantalla no recibió el cambio. Con setState tuve que coordinar cuatro partes: visor, ida a Control, Control y regreso.

### 2. ¿Por qué el botón atrás no rompe el estado con Riverpod? ¿Dónde vive el contador?

Con Riverpod sumé dos veces y volví con atrás: el visor mostró 2. Al reabrir seguía en 2. El contador vive en el provider que comparten las dos pantallas.

### 3. ¿Qué permite ver `BlocObserver` y cuándo sería útil?

Al pulsar +1, +1 y -1, vi estas líneas reales en la consola:

```text
ContadorCubit: 0 -> 1
ContadorCubit: 1 -> 2
ContadorCubit: 2 -> 1
```

Me sirve para ver en qué momento cambió el contador si aparece un valor raro.

### 4. ¿Qué demuestran los comandos `git diff`?

Comparé las ramas desde la raíz del repositorio:

```text
git diff version/setstate version/riverpod -- parte_a_contador/lib/domain parte_a_contador/lib/data

git diff version/setstate version/bloc -- parte_a_contador/lib/domain parte_a_contador/lib/data

git diff version/setstate version/bloc --stat -- parte_a_contador/lib/presentation
 .../lib/presentation/estado/contador_cubit.dart    | 32 +++++++++
 .../presentation/pantallas/pantalla_control.dart   | 81 +++++++++------------
 .../lib/presentation/pantallas/pantalla_visor.dart | 83 +++++++---------------
3 files changed, 92 insertions(+), 104 deletions(-)
```

Los dos primeros comandos no mostraron nada; el tercero sí mostró cambios en tres archivos. Entiendo que cambié la presentación, pero no la lógica ni el guardado. Si reemplazara Riverpod, tocaría la presentación y main.dart.

### 5. ¿Cuál elegiría para una pantalla y para ocho pantallas con cinco datos compartidos?

Para una pantalla usaría setState porque es sencillo y alcanza. Para ocho pantallas con cinco datos compartidos elegiría Riverpod, porque todas pueden leer esos datos sin pasarlos de una a otra. Cubit me serviría si quisiera seguir cada cambio en la consola.

setState sí es buena opción cuando el dato solo importa en una pantalla o un widget. Para algo pequeño, prefiero no agregar más código.

## Parte B — Future vs Stream

### 6. ¿Por qué `Future` siguió mostrando Wi‑Fi después de apagarlo?

Primero vi Wi‑Fi a las 23:33:39. Apagué el Wi‑Fi y esperé 10 segundos, pero la pantalla seguía igual. Solo al consultar otra vez mostró Datos móviles a las 23:34:01. La primera respuesta era correcta cuando la pedí; después quedó vieja.

### 7. ¿Qué pasaría si se elimina `cancel()` de `close()`?

Quedarían escuchas abiertas aunque yo saliera de la pantalla. Si entrara y saliera 50 veces, podría acumular muchas. Por eso `close()` cancela la suscripción.

### 8. ¿Por qué Future es una foto y Stream una película?

Future me dio una foto: mostró Wi‑Fi y no cambió hasta que consulté de nuevo. Stream siguió atento: al activar modo avión pasó solo a Sin conexión (contador 2) y, al volver el Wi‑Fi, cambió a Wi‑Fi (contador 4).

Usaría `Future` para cargar mi perfil y una lista de productos. Usaría `Stream` para mensajes nuevos y para seguir una ubicación en vivo.

## Comparación de la Parte A

| | `setState` | Riverpod | Cubit |
|---|---|---|---|
| ¿Dónde vive el contador? | En el visor y, mientras está abierta, en Control. | En un provider. | En el Cubit. |
| ¿Las pantallas se pasan datos? | Sí. | No. | No. |
| Archivos de `presentation/` que se tocaron | `pantalla_visor.dart` y `pantalla_control.dart`. | Los dos de pantallas y `contador_provider.dart`. | Los dos de pantallas y `contador_cubit.dart`. |
| ¿Qué pasa con el botón atrás? | El visor quedó en 3; al reabrir apareció el 4 guardado. | El visor mostró 2 y siguió en 2 al reabrir. | El visor mostró 2 y siguió en 2 al reabrir. |
| ¿Tuve que tocar `domain/`? | No. | No. | No. |

## Estado de la entrega

- Las tres ramas y la app de conexión corrieron en el emulador. `flutter analyze` pasó en las cuatro.
- En Parte B, `connectivity_plus` solo aparece en `data`; el Cubit cancela la suscripción al cerrarse.
- Los widget tests y `flutter analyze` pasaron en las cuatro versiones.
