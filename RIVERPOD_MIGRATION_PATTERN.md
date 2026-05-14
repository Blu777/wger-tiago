# Riverpod Migration Pattern (Definitivo)

Patrón único, mínimo y consistente para migrar features a Riverpod. Basado en `body_weight`, corregido y generalizado.

---

## 1. Reglas obligatorias

- **Repository como provider separado**: nunca `late final` en `build()` del notifier.
- **AsyncNotifier para estado**: estado = `Future<List<Model>>`, permite `AsyncError` en carga inicial.
- **Optimistic updates con rollback**: mutar `state` antes del await; si falla, revertir a `previous` y propagar error.
- **Modelos inmutables**: `final` fields, `copyWith`, constructor `const`.
- **Un solo archivo `_riverpod.dart`**: repository + notifier + provider generado. No split innecesario.
- **Una feature a la vez**: nunca migrar múltiples features en paralelo.
- **Sin lógica de negocio en widgets**: los widgets consumen estado y disparan acciones; la lógica va en el notifier.

---

## 2. Estructura de archivos por feature

```
lib/
  models/<feature>/
    <model>.dart              # Modelo inmutable
    <model>.g.dart            # Generado por json_serializable
  providers/
    <feature>_riverpod.dart   # Repository provider + AsyncNotifier
    <feature>_riverpod.g.dart # Generado por riverpod_generator
  screens/
    <feature>_screen.dart     # StatelessWidget mínimo (si no consume provider)
  widgets/<feature>/
    <feature>_overview.dart   # ConsumerWidget que consume el provider
    forms.dart                # ConsumerStatefulWidget inmutable

test/
  <feature>/
    <feature>_provider_test.dart   # Tests de notifier con ProviderContainer
    <feature>_screen_test.dart   # Tests de UI con ProviderScope
```

**Cuándo dividir `_riverpod.dart`:**
- Por defecto: un solo archivo.
- Excepción: si el repository tiene más de ~10 métodos o hay múltiples notifiers relacionados. En ese caso separar en `<feature>_repository.dart` y `<feature>_notifier.dart`.

---

## 3. Naming conventions estrictas

| Concepto            | Patrón                              | Ejemplo                          |
|---------------------|-------------------------------------|----------------------------------|
| Modelo              | `PascalCase` singular               | `WeightEntry`                    |
| Repository class    | `PascalCase` + `Repository`         | `BodyWeightRepository`           |
| Repository provider | `camelCase` + `RepositoryProvider`  | `bodyWeightRepositoryProvider`   |
| Notifier class      | `PascalCase` + `Notifier`           | `BodyWeightNotifier`             |
| Notifier provider   | `camelCase` + `Provider`            | `bodyWeightProvider`             |
| Screen              | `PascalCase` + `Screen`             | `WeightScreen`                   |
| Overview widget     | `PascalCase` + `Overview`           | `WeightOverview`                 |
| Form widget         | `PascalCase` + `Form`               | `WeightForm`                     |

---

## 4. Modelo inmutable

```dart
// models/<feature>/<model>.dart

@JsonSerializable()
class WeightEntry {
  @JsonKey(required: true)
  final int? id;

  @JsonKey(required: true, fromJson: stringToNum, toJson: numToString)
  final num weight;

  @JsonKey(required: true, fromJson: utcIso8601ToLocalDate, toJson: dateToUtcIso8601)
  final DateTime date;

  const WeightEntry({this.id, required this.weight, required this.date});

  WeightEntry copyWith({int? id, num? weight, DateTime? date}) => WeightEntry(
    id: id ?? this.id,
    weight: weight ?? this.weight,
    date: date ?? this.date,
  );

  factory WeightEntry.fromJson(Map<String, dynamic> json) => _$WeightEntryFromJson(json);
  Map<String, dynamic> toJson() => _$WeightEntryToJson(this);
}
```

**Reglas:**
- Campos `final`.
- `copyWith` usa `field ?? this.field` (no `this.field ?? field`).
- Constructor con `required` para campos no nulos.
- Nunca mutar modelo en widgets/forms/notifiers.

---

## 5. Repository como provider separado

```dart
// providers/<feature>_riverpod.dart

class BodyWeightRepository {
  final _logger = Logger('BodyWeightRepository');
  final WgerBaseProvider _base;

  BodyWeightRepository(this._base);

  static const _path = 'weightentry';

  Future<List<WeightEntry>> fetchEntries() async {
    _logger.info('Fetching all body weight entries');
    final data = await _base.fetchPaginated(
      _base.makeUrl(
        _path,
        query: {'ordering': '-date', 'limit': API_MAX_PAGE_SIZE},
      ),
    );
    return data.map((e) => WeightEntry.fromJson(e)).toList();
  }

  Future<WeightEntry> addEntry(WeightEntry entry) async {
    final data = await _base.post(entry.toJson(), _base.makeUrl(_path));
    return WeightEntry.fromJson(data);
  }

  Future<void> editEntry(WeightEntry entry) async {
    await _base.patch(
      entry.toJson(),
      _base.makeUrl(_path, id: entry.id),
    );
  }

  Future<void> deleteEntry(int id) async {
    await _base.deleteRequest(_path, id);
  }
}

@riverpod
BodyWeightRepository bodyWeightRepository(Ref ref) {
  final base = ref.watch(wgerBaseProvider);
  return BodyWeightRepository(base);
}
```

**Reglas:**
- Repository es una clase Dart pura, sin dependencia de Riverpod.
- El provider del repository es funcional (`@riverpod`), no clase.
- Usa `ref.watch(wgerBaseProvider)` para recibir el provider base.
- **NUNCA** crear `late final _repo` dentro del notifier.

---

## 6. AsyncNotifier (estado)

```dart
// providers/<feature>_riverpod.dart (mismo archivo)

@Riverpod(name: 'bodyWeightProvider')
class BodyWeightNotifier extends _$BodyWeightNotifier {
  @override
  Future<List<WeightEntry>> build() async {
    return ref.watch(bodyWeightRepositoryProvider).fetchEntries();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(bodyWeightRepositoryProvider).fetchEntries(),
    );
  }

  Future<void> addEntry(WeightEntry entry) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(
      [...previous, entry]..sort((a, b) => b.date.compareTo(a.date)),
    );

    try {
      final newEntry = await ref.read(bodyWeightRepositoryProvider).addEntry(entry);
      final current = state.asData?.value ?? [];
      state = AsyncValue.data(
        [
          ...current.where(
            (e) => entry.id == null ? e.id != null : e.id != entry.id,
          ),
          newEntry,
        ]..sort((a, b) => b.date.compareTo(a.date)),
      );
    } catch (err, stackTrace) {
      state = AsyncValue.data(previous);
      rethrow;
    }
  }

  Future<void> editEntry(WeightEntry entry) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(
      previous.map((e) => e.id == entry.id ? entry : e).toList(),
    );

    try {
      await ref.read(bodyWeightRepositoryProvider).editEntry(entry);
    } catch (err, stackTrace) {
      state = AsyncValue.data(previous);
      rethrow;
    }
  }

  Future<void> deleteEntry(int id) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(previous.where((e) => e.id != id).toList());

    try {
      await ref.read(bodyWeightRepositoryProvider).deleteEntry(id);
    } catch (err, stackTrace) {
      state = AsyncValue.data(previous);
      rethrow;
    }
  }

  WeightEntry? getNewestEntry() => state.asData?.value.firstOrNull;

  void clear() => state = const AsyncValue.data([]);
}
```

**Reglas:**
- `build()` async retorna `Future<List<Model>>`. El estado inicial puede ser `AsyncError`; la UI lo maneja.
- `refresh()` recarga desde el servidor. `AsyncValue.guard` maneja loading + error automáticamente.
- **Optimistic update**: mutar `state` inmediatamente, antes del `await`.
- **Rollback**: en `catch`, `state = AsyncValue.data(previous)`.
- **Propagar error**: usar `rethrow` (preserva stack trace automáticamente).
- Guardar `previous = state.asData?.value ?? []` al inicio de cada acción.

---

## 7. ref.watch vs ref.read

| Contexto | Método | Razón |
|----------|--------|-------|
| `build()` del notifier | `ref.watch(repositoryProvider)` | Si el repository cambia (ej: login/logout), `build()` se recomputea y recarga datos. |
| Acciones del notifier (add/edit/delete/refresh) | `ref.read(repositoryProvider)` | No se necesita escuchar cambios; se lee una vez para ejecutar la acción. |
| `build()` de widget | `ref.watch(provider)` | Reconstruir widget cuando el estado cambia. |
| Callbacks/event handlers en widgets | `ref.read(provider.notifier)` | No se necesita rebuild; se lee una vez para disparar la acción. |

**Reglas:**
- `ref.watch` solo en `build()` (widgets y notifiers).
- `ref.read` solo en callbacks, event handlers y métodos de acción.
- Nunca `ref.watch` dentro de `onPressed`, `onTap`, etc.

---

## 8. clear() y recomputación de build()

### clear()

```dart
void clear() => state = const AsyncValue.data([]);
```

- **Uso**: llamar en logout o cambio de usuario para limpiar estado en memoria.
- **No usar** como reemplazo de `refresh()` en flujos normales.

### Recomputación de build()

El notifier se recomputea (se ejecuta `build()` de nuevo) cuando cualquier dependencia declarada con `ref.watch` cambia:

```dart
@override
Future<List<WeightEntry>> build() async {
  return ref.watch(bodyWeightRepositoryProvider).fetchEntries();
}
```

Si `bodyWeightRepositoryProvider` se invalida (porque `wgerBaseProvider` cambió en login/logout), el notifier automáticamente vuelve a cargar datos. Esto es correcto y deseado.

**Reglas:**
- No llamar `fetchEntries()` manualmente en respuesta a cambios de autenticación; dejar que Riverpod recompute.
- `clear()` es para casos donde se necesita estado vacío explícito antes de la siguiente carga.

---

## 9. Flujo completo

```
UI (ConsumerWidget / ConsumerStatefulWidget)
  ↓ ref.watch(bodyWeightProvider)
Notifier (AsyncNotifier)
  ↓ ref.watch(bodyWeightRepositoryProvider)
Repository (clase pura)
  ↓ _base.fetchPaginated / _base.post / _base.patch / _base.deleteRequest
API/DB (WgerBaseProvider)
```

- La UI nunca habla directamente con el Repository.
- El Notifier nunca crea instancias del Repository; siempre usa `ref.watch/read(bodyWeightRepositoryProvider)`.
- El Repository nunca toca estado de Riverpod; es una clase Dart pura con lógica de API.
- El Widget nunca contiene lógica de negocio (sorting, filtros, cálculos); eso va en el notifier o repository.

---

## 10. Widgets

### Overview (ConsumerWidget)

```dart
class WeightOverview extends ConsumerWidget {
  final Profile profile;
  final List<NutritionalPlan> plans;

  const WeightOverview({required this.profile, required this.plans});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(bodyWeightProvider);

    return entriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (entries) {
        return RefreshIndicator(
          onRefresh: () => ref.read(bodyWeightProvider.notifier).refresh(),
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                title: Text('${entry.weight}'),
                subtitle: Text('${entry.date}'),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Edit'),
                      onTap: () => /* navigate to form with entry */,
                    ),
                    PopupMenuItem(
                      child: const Text('Delete'),
                      onTap: () async {
                        await ref.read(bodyWeightProvider.notifier).deleteEntry(entry.id!);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Deleted')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
```

**Reglas:**
- Overview = `ConsumerWidget`.
- Screen = `StatelessWidget` si no consume provider directamente.
- No esconder errores; mostrar al usuario.
- `RefreshIndicator` delega a `ref.read(provider.notifier).refresh()`.
- No lógica de negocio en el widget (sorting, cálculos, filtros van en notifier).

### Form (ConsumerStatefulWidget)

```dart
class WeightForm extends ConsumerStatefulWidget {
  final WeightEntry? initialEntry;

  const WeightForm({super.key, this.initialEntry});

  @override
  ConsumerState<WeightForm> createState() => _WeightFormState();
}

class _WeightFormState extends ConsumerState<WeightForm> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final entry = widget.initialEntry;
    _dateController = TextEditingController(text: entry != null ? dateFormat.format(entry.date) : '');
    _timeController = TextEditingController(text: entry != null ? timeFormat.format(entry.date) : '');
    _weightController = TextEditingController(text: entry != null ? '${entry.weight}' : '');
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          // ... fields con controllers
          ElevatedButton(
            onPressed: () async {
              if (!_form.currentState!.validate()) return;

              final newEntry = WeightEntry(
                id: widget.initialEntry?.id,
                weight: parsedWeight,
                date: parsedDateTime,
              );

              try {
                final notifier = ref.read(bodyWeightProvider.notifier);
                newEntry.id == null
                  ? await notifier.addEntry(newEntry)
                  : await notifier.editEntry(newEntry);

                if (mounted) Navigator.of(context).pop();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
```

**Reglas:**
- Form con `TextEditingController` debe ser `ConsumerStatefulWidget`, no `ConsumerWidget`.
- No mutar `widget.initialEntry`. Construir nuevo `Model` al submit.
- Usar `try/catch` en el `onPressed` para manejar errores de la acción.
- Si la acción falla, mostrar `SnackBar` con el error; no hacer pop.
- Usar `mounted` (no `context.mounted`) dentro de `State`.

---

## 11. Testing con ProviderContainer

### Unit tests de notifier

```dart
@GenerateMocks([WgerBaseProvider])
void main() {
  late MockWgerBaseProvider mockBaseProvider;
  late ProviderContainer container;

  setUp(() {
    mockBaseProvider = MockWgerBaseProvider();
    container = ProviderContainer(
      overrides: [
        wgerBaseProvider.overrideWithValue(mockBaseProvider),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('BodyWeightNotifier', () {
    test('fetches entries on build', () async {
      when(mockBaseProvider.makeUrl(any, query: anyNamed('query')))
        .thenReturn(Uri.parse('https://localhost/api/v2/weightentry/'));
      when(mockBaseProvider.fetchPaginated(any))
        .thenAnswer((_) async => [{'id': 1, 'weight': '80', 'date': '2021-01-01'}]);

      await container.read(bodyWeightProvider.future);
      final state = container.read(bodyWeightProvider);

      expect(state.value, isA<List<WeightEntry>>());
      expect(state.value?.length, 1);
    });

    test('adds entry with optimistic update', () async {
      when(mockBaseProvider.makeUrl(any, query: anyNamed('query')))
        .thenReturn(Uri.parse('https://localhost/api/v2/weightentry/'));
      when(mockBaseProvider.fetchPaginated(any)).thenAnswer((_) async => []);
      when(mockBaseProvider.post(any, any)).thenAnswer(
        (_) async => {'id': 25, 'weight': '80', 'date': '2021-01-01'},
      );

      await container.read(bodyWeightProvider.future);
      await container.read(bodyWeightProvider.notifier).addEntry(
        WeightEntry(date: DateTime.utc(2021, 1, 1), weight: 80),
      );
      final state = container.read(bodyWeightProvider);

      expect(state.value?.length, 1);
      expect(state.value?.first.id, 25);
    });

    test('rolls back on add error', () async {
      when(mockBaseProvider.makeUrl(any, query: anyNamed('query')))
        .thenReturn(Uri.parse('https://localhost/api/v2/weightentry/'));
      when(mockBaseProvider.fetchPaginated(any)).thenAnswer(
        (_) async => [{'id': 1, 'weight': '80', 'date': '2021-01-01'}],
      );
      when(mockBaseProvider.post(any, any)).thenThrow(Exception('Network error'));

      await container.read(bodyWeightProvider.future);
      expect(container.read(bodyWeightProvider).value?.length, 1);

      await expectLater(
        container.read(bodyWeightProvider.notifier).addEntry(
          WeightEntry(date: DateTime.utc(2021, 1, 2), weight: 81),
        ),
        throwsException,
      );

      final state = container.read(bodyWeightProvider);
      expect(state.value?.length, 1);
      expect(state.value?.first.id, 1);
    });
  });
}
```

**Reglas:**
- Crear `ProviderContainer` con `overrides` sobre `wgerBaseProvider`.
- Usar `container.read(provider.future)` para esperar la carga inicial.
- Probar optimistic update: verificar estado después de la acción.
- Probar rollback: hacer que el mock falle, verificar que el estado vuelve al `previous`.
- Usar `await expectLater(..., throwsException)` para errores propagados.

### Widget tests

```dart
Widget createWeightScreen() {
  return ProviderScope(
    overrides: [
      wgerBaseProvider.overrideWithValue(mockBaseProvider),
    ],
    child: MaterialApp(
      home: const WeightScreen(),
    ),
  );
}
```

**Reglas:**
- Usar `ProviderScope` con overrides.
- No mezclar `ProviderScope` con `MultiProvider` legacy.
- Si el screen necesita providers legacy, mockarlos por fuera y pasar datos como parámetros.

---

## 12. Checklist de migración paso a paso

1. **Crear modelo inmutable**
   - [ ] Campos `final`
   - [ ] `copyWith` correcto
   - [ ] `fromJson` / `toJson` con `json_serializable`

2. **Crear repository como provider separado**
   - [ ] Clase `FeatureRepository` con métodos CRUD
   - [ ] Provider funcional `@riverpod FeatureRepository featureRepository(Ref ref)`
   - [ ] Usar `ref.watch(wgerBaseProvider)`

3. **Crear AsyncNotifier**
   - [ ] `@Riverpod(name: 'featureProvider') class FeatureNotifier extends _$FeatureNotifier`
   - [ ] `build()` llama a `ref.watch(featureRepositoryProvider).fetchAll()`
   - [ ] `refresh()` con `AsyncValue.guard`
   - [ ] `add/edit/delete` con optimistic update + rollback + `rethrow`

4. **Refactorizar overview widget**
   - [ ] Cambiar a `ConsumerWidget`
   - [ ] Usar `ref.watch(featureProvider)` + `when(loading/error/data)`
   - [ ] `RefreshIndicator` con `ref.read(featureProvider.notifier).refresh()`
   - [ ] Sin lógica de negocio (sorting, filtros, cálculos) en el widget

5. **Refactorizar form**
   - [ ] Cambiar a `ConsumerStatefulWidget` (si usa controllers)
   - [ ] No mutar `initialEntry`; construir nuevo `Model` al submit
   - [ ] Usar `try/catch` alrededor de la llamada al notifier
   - [ ] Mostrar error con `SnackBar` si falla; solo hacer `pop` si tiene éxito

6. **Refactorizar screen**
   - [ ] Eliminar `package:provider` si es posible
   - [ ] Si necesita datos de providers legacy, pasarlos como parámetros al overview

7. **Eliminar provider legacy**
   - [ ] Borrar `<feature>.dart` viejo (`ChangeNotifier`)
   - [ ] Actualizar imports

8. **Migrar tests**
   - [ ] Crear `test/<feature>/<feature>_provider_test.dart`
   - [ ] Usar `ProviderContainer` con `wgerBaseProvider.overrideWithValue(mock)`
   - [ ] Test: fetch inicial, optimistic update, rollback en error
   - [ ] Crear/actualizar `test/<feature>/<feature>_screen_test.dart`
   - [ ] Usar `ProviderScope` con overrides; evitar `MultiProvider`

9. **Verificar**
   - [ ] `flutter analyze` sin errores
   - [ ] Tests pasan: `flutter test test/<feature>/`
   - [ ] Funcionalidad manual OK (add/edit/delete/refresh)

---

## 13. Mejoras detectadas en body_weight (aplicar antes de usar como template)

| Problema | Impacto | Solución |
|----------|---------|----------|
| `addEntry` tiene sorting por fecha hardcodeado | No generalizable | Documentar como "lógica de dominio opcional"; cada feature decide su ordenamiento en el notifier |
| Tests no cubren rollback en error | Puede regresar bug | Agregar test que fuerce error en mock y verifica `state.value` vuelve al original |
| Screen test mezcla `ProviderScope` + `MultiProvider` | Patrón híbrido confuso | Refactorizar screen para que no dependa de `package:provider` legacy; pasar `profile` y `plans` como parámetros |
| Form no maneja errores de acción | Usuario no sabe si falló | Agregar `try/catch` en `onPressed` con `SnackBar` en error |
| Overview muestra `Text('Error: $err')` muy básico | UX pobre | Considerar widget de error reutilizable con retry |
| Form usa `ConsumerWidget` con controllers | Memory leaks, bugs | Cambiar a `ConsumerStatefulWidget` con `dispose()` |

---

## 14. Referencia viva

Feature completa migrada (con mejoras aplicadas):
- **Domain**: `lib/features/body_weight/domain/models/weight_entry.dart`
- **Data**: `lib/features/body_weight/data/api/body_weight_api_service.dart`
- **Data**: `lib/features/body_weight/data/local/body_weight_local_source.dart`
- **Data**: `lib/features/body_weight/data/repositories/body_weight_repository.dart`
- **Presentation**: `lib/features/body_weight/presentation/providers/body_weight_provider.dart`
- **Presentation**: `lib/features/body_weight/presentation/screens/weight_screen.dart`
- **Presentation**: `lib/features/body_weight/presentation/widgets/weight_overview.dart`
- **Presentation**: `lib/features/body_weight/presentation/widgets/weight_form.dart`
- **Tests**: `test/features/body_weight/domain/weight_entry_test.dart`
- **Tests**: `test/features/body_weight/presentation/body_weight_provider_test.dart`
- **Tests**: `test/features/body_weight/presentation/weight_screen_test.dart`
- **Tests**: `test/features/body_weight/presentation/weight_form_test.dart`

Archivos viejos eliminados:
- `lib/models/body_weight/weight_entry.dart`
- `lib/providers/body_weight_riverpod.dart`
- `lib/widgets/weight/weight_overview.dart`
- `lib/widgets/weight/forms.dart`
- `lib/screens/weight_screen.dart`
- `test/weight/weight_provider_test.dart`
- `test/weight/weight_screen_test.dart`
