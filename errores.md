Aparecieron estos dos errores cuando abrr la app

Error Title: An error occurred
Error Message: Cannot use the Ref of trophyProvider after it has been disposed. This typically happens if:
- A provider rebuilt, but the previous "build" was still pending and is still performing operations.
  You should therefore either use `ref.onDispose` to cancel pending work, or
  check `ref.mounted` after async gaps or anything that could invalidate the provider.
- You tried to use Ref inside `onDispose` or other life-cycles.
  This is not supported, as the provider is already being disposed.


Stack Trace:
#0      Ref._throwIfInvalidUsage (package:riverpod/src/core/ref.dart:236)
#1      Ref.read (package:riverpod/src/core/ref.dart:538)
#2      TrophyNotifier.refresh (package:wger/features/trophies/presentation/providers/trophy_provider.dart:96)
#3      _HomeTabsScreenState._loadEntries (package:wger/screens/home_tabs_screen.dart:131)
<asynchronous suspension>
#4      _FutureBuilderState._subscribe.<anonymous closure> (package:flutter/src/widgets/async.dart:641)
<asynchronous suspension>

2026-05-14T10:40:51.794257 SEVERE [main] Error caught by FlutterError.onError: Cannot use the Ref of trophyProvider after it has been disposed. This typically happens if:
- A provider rebuilt, but the previous "build" was still pending and is still performing operations.
  You should therefore either use `ref.onDispose` to cancel pending work, or
  check `ref.mounted` after async gaps or anything that could invalidate the provider.
- You tried to use Ref inside `onDispose` or other life-cycles.
  This is not supported, as the provider is already being disposed.

2026-05-14T10:40:51.787405 INFO [MeasurementApiService] Fetching all measurement categories
2026-05-14T10:40:51.787098 INFO [BodyWeightApiService] Fetching all body weight entries
2026-05-14T10:40:51.783967 INFO [TrophyApiService] Fetching trophy progression
2026-05-14T10:40:51.783876 INFO [TrophyApiService] Fetching user trophies
2026-05-14T10:40:51.783569 INFO [TrophyApiService] Fetching all trophies
2026-05-14T10:40:51.727637 INFO [HomeTabsScreen] Loading routines, weight, measurements and gallery
2026-05-14T10:40:51.727383 INFO [ExercisesProvider] Loading all exercises from API
2026-05-14T10:40:51.613896 INFO [ExercisesProvider] Loaded 386 exercises from DB cache
2026-05-14T10:40:51.605473 INFO [ExercisesProvider] Loaded 11 equipment from cache
2026-05-14T10:40:51.604033 INFO [ExercisesProvider] Loaded 30 languages from cache
2026-05-14T10:40:51.601182 INFO [ExercisesProvider] Loaded 8 categories from cache
2026-05-14T10:40:51.600848 INFO [ExercisesProvider] Loaded 16 muscles from cache
2026-05-14T10:40:51.584083 INFO [NutritionPlansProvider] Read 0 ingredients from db cache
2026-05-14T10:40:51.577709 INFO [RoutinesProvider] Read workout units data from cache. Valid till 2026-06-03T10:30:09.126597
2026-05-14T10:40:51.565077 INFO [ExercisesProvider] Fetching initial exercise data
2026-05-14T10:40:51.564780 INFO [HomeTabsScreen] Loading base data
2026-05-14T10:40:51.564646 INFO [MeasurementApiService] Fetching all measurement categories
2026-05-14T10:40:51.564411 INFO [GalleryApiService] Fetching gallery images
2026-05-14T10:40:51.564043 INFO [TrophyApiService] Fetching trophy progression
2026-05-14T10:40:51.563930 INFO [TrophyApiService] Fetching user trophies
2026-05-14T10:40:51.563672 INFO [TrophyApiService] Fetching all trophies
2026-05-14T10:40:51.559286 INFO [AuthProvider] autologin successful
2026-05-14T10:40:51.558899 INFO [AuthProvider] autologin successful