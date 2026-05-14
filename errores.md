Aparecieron estos dos errores cuando abrr la app

Error Title: An error occurred
Error Message: Cannot use the Ref of measurementProvider after it has been disposed. This typically happens if:
- A provider rebuilt, but the previous "build" was still pending and is still performing operations.
  You should therefore either use `ref.onDispose` to cancel pending work, or
  check `ref.mounted` after async gaps or anything that could invalidate the provider.
- You tried to use Ref inside `onDispose` or other life-cycles.
  This is not supported, as the provider is already being disposed.


Stack Trace:
#0      Ref._throwIfInvalidUsage (package:riverpod/src/core/ref.dart:236)
#1      AnyNotifier.state= (package:riverpod/src/core/provider/notifier_provider.dart:91)
#2      MeasurementNotifier.refresh (package:wger/providers/measurement_riverpod.dart:108)
#3      _HomeTabsScreenState._loadEntries (package:wger/screens/home_tabs_screen.dart:132)
<asynchronous suspension>
#4      _FutureBuilderState._subscribe.<anonymous closure> (package:flutter/src/widgets/async.dart:641)
<asynchronous suspension>.





2026-05-13T22:23:09.139163 SEVERE [main] Error caught by FlutterError.onError: Cannot use the Ref of measurementProvider after it has been disposed. This typically happens if:
- A provider rebuilt, but the previous "build" was still pending and is still performing operations.
  You should therefore either use `ref.onDispose` to cancel pending work, or
  check `ref.mounted` after async gaps or anything that could invalidate the provider.
- You tried to use Ref inside `onDispose` or other life-cycles.
  This is not supported, as the provider is already being disposed.

2026-05-13T22:23:08.966096 INFO [HomeTabsScreen] Loading routines, weight, measurements and gallery
2026-05-13T22:23:08.965756 INFO [ExercisesProvider] Loading all exercises from API
2026-05-13T22:23:08.965488 INFO [ExercisesProvider] Loaded 0 exercises from DB cache
2026-05-13T22:23:08.964579 INFO [ExercisesProvider] Saved 30 languages to cache (valid till 2026-05-20 22:23:08.960017)
2026-05-13T22:23:08.645182 INFO [ExercisesProvider] Loading equipment from API
2026-05-13T22:23:08.644705 INFO [ExercisesProvider] Loading languages from API
2026-05-13T22:23:08.644376 INFO [ExercisesProvider] Loading exercise categories from API
2026-05-13T22:23:08.643997 INFO [ExercisesProvider] Loading muscles from API
2026-05-13T22:23:08.622242 INFO [NutritionPlansProvider] Read 0 ingredients from db cache
2026-05-13T22:23:08.509670 INFO [ExercisesProvider] Fetching initial exercise data
2026-05-13T22:23:08.509011 INFO [HomeTabsScreen] Loading base data
2026-05-13T22:22:53.511380 INFO [AuthProvider] autologin failed, no saved user data
2026-05-13T22:22:53.508034 INFO [AuthProvider] autologin failed, no saved user data