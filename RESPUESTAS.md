# Respuestas — Deber 1

Probé las apps en el emulador Android. Los cambios de conexión también los hice ahí, no en un teléfono.

## Parte A — La misma app, tres veces

### 1. ¿Qué pasó al usar el botón atrás del sistema en la versión `setState`?

Pulsé `+1` tres veces y «Volver»: el visor mostró **3**, incluso después de cerrar y abrir la app. Luego sumé una vez más y usé el botón atrás de Android. El visor siguió en **3**, pero al reabrir mostró **4**. El número sí se guardó; lo que quedó viejo fue el visor, porque atrás no le devolvió el nuevo valor. Para pasar ese dato tuve que coordinar cuatro lugares: el visor, la navegación de ida, Control y el regreso.

### 2. ¿Por qué el botón atrás no rompe el estado con Riverpod? ¿Dónde vive el contador?

Con Riverpod sumé dos veces y volví con atrás: el visor mostró **2**. Al reabrir, seguía en **2**. El contador vive en el provider, que comparten las dos pantallas, así que no hace falta devolverlo al navegar.

### 3. ¿Qué permite ver `BlocObserver` y cuándo sería útil?

Al pulsar `+1`, `+1` y `-1`, vi estas líneas reales en la consola:

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
(sin salida)

git diff version/setstate version/bloc -- parte_a_contador/lib/domain parte_a_contador/lib/data
(sin salida)

git diff version/setstate version/bloc --stat -- parte_a_contador/lib/presentation
 .../lib/presentation/estado/contador_cubit.dart    | 32 +++++++++
 .../presentation/pantallas/pantalla_control.dart   | 81 +++++++++------------
 .../lib/presentation/pantallas/pantalla_visor.dart | 83 +++++++---------------
3 files changed, 92 insertions(+), 104 deletions(-)
```

Eso muestra que cambié la forma de manejar el estado en `presentation`, pero no la lógica ni el guardado del contador. Si cambiara Riverpod por otro paquete, tocaría `presentation` y `main.dart`.

### 5. ¿Cuál elegiría para una pantalla y para ocho pantallas con cinco datos compartidos?

Para una pantalla usaría `setState`: es sencillo y alcanza. Para ocho pantallas con cinco datos compartidos elegiría Riverpod, porque todas pueden leer esos datos sin pasarlos de una a otra. Cubit me serviría si quisiera seguir cada cambio en la consola.

`setState` sí es buena opción cuando el dato solo importa en una pantalla o un widget. Para algo pequeño, prefiero no agregar más código.

## Parte B — Future vs Stream

### 6. ¿Por qué `Future` siguió mostrando Wi‑Fi después de apagarlo?

La primera consulta mostró **Wi‑Fi, 23:33:39**. Apagué el Wi‑Fi y esperé 10 segundos: la pantalla seguía igual. Cuando consulté otra vez, mostró **Datos móviles, 23:34:01**. El primer dato era correcto cuando lo pedí, pero ya estaba desactualizado.

### 7. ¿Qué pasaría si se elimina `cancel()` de `close()`?

Quedarían escuchas abiertas aunque yo saliera de la pantalla. Si entrara y saliera 50 veces, podría acumular muchas. Por eso `close()` cancela la suscripción.

### 8. ¿Por qué Future es una foto y Stream una película?

Con `Future` vi el estado que había al consultar, pero no cambió solo cuando apagué Wi‑Fi. Con `Stream`, al activar modo avión pasó solo de **Wi‑Fi** a **Sin conexión** (contador **2**); al restablecer Wi‑Fi volvió a **Wi‑Fi** (contador **4**). Por eso lo veo como una foto frente a una película.

Usaría `Future` para cargar mi perfil y una lista de productos. Usaría `Stream` para mensajes nuevos y para seguir una ubicación en vivo.

## Comparación de la Parte A

| | `setState` | Riverpod | Cubit |
|---|---|---|---|
| ¿Dónde vive el contador? | En el visor y, mientras está abierta, en Control. | En un provider. | En el Cubit. |
| ¿Las pantallas se pasan datos? | Sí. | No. | No. |
| Archivos de `presentation/` que se tocaron | Visor y Control. | Provider, Visor y Control. | Cubit, Visor y Control. |
| ¿Qué pasa con el botón atrás? | El visor quedó en 3; al reabrir apareció el 4 guardado. | El visor mostró 2 y siguió en 2 al reabrir. | El visor mostró 2 y siguió en 2 al reabrir. |
| ¿Tuve que tocar `domain/`? | No. | No. | No. |

## Estado de la entrega

- Las tres ramas y la app de conexión corrieron en el emulador. `flutter analyze` pasó en las cuatro.
- En Parte B, `connectivity_plus` solo aparece en `data`; el Cubit cancela la suscripción al cerrarse.
- `flutter test` falló: los tests de Parte A no preparan `SharedPreferencesAsync` y el de Parte B todavía espera la pantalla inicial del contador.
- Falta `demo.mp4`. No hice esa grabación.
