/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (c) 2020 - 2026 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:wger/core/exceptions/http_exception.dart';
import 'package:wger/core/locator.dart';
import 'package:wger/features/body_weight/presentation/screens/weight_screen.dart';
import 'package:wger/features/measurement/presentation/screens/measurement_categories_screen.dart';
import 'package:wger/features/measurement/presentation/screens/measurement_entries_screen.dart';
import 'package:wger/helpers/errors.dart';
import 'package:wger/helpers/locale.dart';
import 'package:wger/helpers/shared_preferences.dart';
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/providers/add_exercise.dart';
import 'package:wger/providers/base_provider.dart';
import 'package:wger/providers/exercises.dart';
import 'package:wger/providers/nutrition.dart';
import 'package:wger/providers/routines.dart';
import 'package:wger/providers/user.dart';
import 'package:wger/providers/wger_base_riverpod.dart';
import 'package:wger/screens/add_exercise_screen.dart';
import 'package:wger/screens/auth_screen.dart';
import 'package:wger/screens/dashboard.dart';
import 'package:wger/screens/exercise_screen.dart';
import 'package:wger/screens/exercises_screen.dart';
import 'package:wger/screens/form_screen.dart';
import 'package:wger/screens/gallery_screen.dart';
import 'package:wger/screens/gym_mode.dart';
import 'package:wger/screens/home_tabs_screen.dart';
import 'package:wger/screens/log_meal_screen.dart';
import 'package:wger/screens/log_meals_screen.dart';
import 'package:wger/screens/nutritional_diary_screen.dart';
import 'package:wger/screens/nutritional_plan_screen.dart';
import 'package:wger/screens/nutritional_plans_screen.dart';
import 'package:wger/screens/routine_edit_screen.dart';
import 'package:wger/screens/routine_list_screen.dart';
import 'package:wger/screens/routine_logs_screen.dart';
import 'package:wger/screens/routine_screen.dart';
import 'package:wger/screens/settings_dashboard_widgets_screen.dart';
import 'package:wger/screens/settings_plates_screen.dart';
import 'package:wger/screens/splash_screen.dart';
import 'package:wger/screens/trophy_screen.dart';
import 'package:wger/screens/update_app_screen.dart';
import 'package:wger/screens/update_server_screen.dart';
import 'package:wger/theme/theme.dart';
import 'package:wger/widgets/core/about.dart';
import 'package:wger/widgets/core/log_overview.dart';
import 'package:wger/widgets/core/settings.dart';

import 'helpers/logs.dart';
import 'providers/auth.dart';

void _setupLogging() {
  Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time} [${record.loggerName}] ${record.message}');
    InMemoryLogStore().add(record);
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Needs to be called before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Logger
  _setupLogging();

  final logger = Logger('main');

  // Locator to initialize exerciseDB
  await ServiceLocator().configure();

  // SharedPreferences to SharedPreferencesAsync migration function
  await PreferenceHelper.instance.migrationSupportFunctionForSharedPreferences();
  // Catch errors from Flutter itself (widget build, layout, paint, etc.)
  //
  // NOTE: it seems this sometimes makes problems and even freezes the flutter
  //       process when widgets overflow, so it is disabled in dev mode.
  if (!kDebugMode) {
    FlutterError.onError = (FlutterErrorDetails details) {
      final stack = details.stack ?? StackTrace.empty;
      logger.severe('Error caught by FlutterError.onError: ${details.exception}');

      FlutterError.dumpErrorToConsole(details);

      // Don't show the full error dialog for network image loading errors.
      if (details.exception is NetworkImageLoadException) {
        return;
      }

      showGeneralErrorDialog(details.exception, stack);
      // throw details.exception;
    };
  }

  // Catch errors that happen outside of the Flutter framework (e.g., in async operations)
  PlatformDispatcher.instance.onError = (error, stack) {
    // Skip the StackFrame assertion error from the stack_trace package.
    // This is a known Flutter framework issue where async gap markers in stack
    // traces cause an assertion failure in StackFrame.fromStackTraceLine.
    if (error is AssertionError && error.toString().contains('asynchronous gap')) {
      logger.warning('Suppressed StackFrame assertion error (known Flutter issue)');
      return true;
    }

    logger.severe('Error caught by PlatformDispatcher.instance.onError: $error');
    logger.severe('Stack trace: $stack');

    if (error is WgerHttpException) {
      showHttpExceptionErrorDialog(error);
    } else {
      showGeneralErrorDialog(error, stack);
    }

    // Return true to indicate that the error has been handled.
    return true;
  };

  // Application
  final authProvider = AuthProvider();
  final baseProvider = WgerBaseProvider(authProvider);
  final exercisesProvider = ExercisesProvider(baseProvider);
  final routinesProvider = RoutinesProvider(baseProvider, exercisesProvider, []);

  // Validate auth state synchronization
  void validateAuthState() {
    // Ensure all providers have consistent auth state
    if (baseProvider.auth != authProvider) {
      logger.warning('Auth state inconsistency detected between baseProvider and authProvider');
    }
  }

  // Listen for auth state changes to validate synchronization
  authProvider.addListener(validateAuthState);

  runApp(
    riverpod.ProviderScope(
      overrides: [
        wgerBaseProvider.overrideWithValue(baseProvider),
        exercisesRiverpodProvider.overrideWithValue(exercisesProvider),
        routinesRiverpodProvider.overrideWithValue(routinesProvider),
      ],
      child: MainApp(
        authProvider: authProvider,
        baseProvider: baseProvider,
        exercisesProvider: exercisesProvider,
        routinesProvider: routinesProvider,
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  final AuthProvider authProvider;
  final WgerBaseProvider baseProvider;
  final ExercisesProvider exercisesProvider;
  final RoutinesProvider routinesProvider;

  const MainApp({
    required this.authProvider,
    required this.baseProvider,
    required this.exercisesProvider,
    required this.routinesProvider,
  });

  Widget _getHomeScreen(AuthProvider auth) {
    switch (auth.state) {
      case AuthState.loggedIn:
        return HomeTabsScreen();
      case AuthState.updateRequired:
        return const UpdateAppScreen();
      case AuthState.serverUpdateRequired:
        return const UpdateServerScreen();
      default:
        return FutureBuilder(
          future: auth.tryAutoLogin(),
          builder: (ctx, authResultSnapshot) =>
              authResultSnapshot.connectionState == ConnectionState.waiting
              ? const SplashScreen()
              : const AuthScreen(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<ExercisesProvider>.value(value: exercisesProvider),
        ChangeNotifierProvider<RoutinesProvider>.value(value: routinesProvider),
        ChangeNotifierProxyProvider<AuthProvider, NutritionPlansProvider>(
          create: (context) => NutritionPlansProvider(
            baseProvider,
            [],
          ),
          update: (context, auth, previous) =>
              previous ?? NutritionPlansProvider(baseProvider, []),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (context) => UserProvider(baseProvider),
          update: (context, base, previous) => previous ?? UserProvider(baseProvider),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AddExerciseProvider>(
          create: (context) => AddExerciseProvider(baseProvider),
          update: (context, base, previous) =>
              previous ?? AddExerciseProvider(baseProvider),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
          return Consumer<UserProvider>(
            builder: (ctx, user, _) => MaterialApp(
              title: 'wger',
              navigatorKey: navigatorKey,
              theme: wgerLightTheme,
              darkTheme: wgerDarkTheme,
              highContrastTheme: wgerLightThemeHc,
              highContrastDarkTheme: wgerDarkThemeHc,
              themeMode: user.themeMode,
              home: _getHomeScreen(auth),
              routes: {
                DashboardScreen.routeName: (ctx) => const DashboardScreen(),
                FormScreen.routeName: (ctx) => const FormScreen(),
                GalleryScreen.routeName: (ctx) => const GalleryScreen(),
                GymModeScreen.routeName: (ctx) => const GymModeScreen(),
                HomeTabsScreen.routeName: (ctx) => HomeTabsScreen(),
                MeasurementCategoriesScreen.routeName: (ctx) =>
                    const MeasurementCategoriesScreen(),
                MeasurementEntriesScreen.routeName: (ctx) => const MeasurementEntriesScreen(),
                NutritionalPlansScreen.routeName: (ctx) => const NutritionalPlansScreen(),
                NutritionalDiaryScreen.routeName: (ctx) => const NutritionalDiaryScreen(),
                NutritionalPlanScreen.routeName: (ctx) => const NutritionalPlanScreen(),
                LogMealsScreen.routeName: (ctx) => const LogMealsScreen(),
                LogMealScreen.routeName: (ctx) => const LogMealScreen(),
                WeightScreen.routeName: (ctx) {
                  final profile = ctx.read<UserProvider>().profile;
                  if (profile == null) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return WeightScreen(
                    profile: profile,
                    plans: ctx.read<NutritionPlansProvider>().items,
                  );
                },
                RoutineScreen.routeName: (ctx) => const RoutineScreen(),
                RoutineEditScreen.routeName: (ctx) => const RoutineEditScreen(),
                WorkoutLogsScreen.routeName: (ctx) => const WorkoutLogsScreen(),
                RoutineListScreen.routeName: (ctx) => const RoutineListScreen(),
                ExercisesScreen.routeName: (ctx) => const ExercisesScreen(),
                ExerciseDetailScreen.routeName: (ctx) => const ExerciseDetailScreen(),
                AddExerciseScreen.routeName: (ctx) => const AddExerciseScreen(),
                AboutPage.routeName: (ctx) => const AboutPage(),
                SettingsPage.routeName: (ctx) => const SettingsPage(),
                LogOverviewPage.routeName: (ctx) => const LogOverviewPage(),
                ConfigurePlatesScreen.routeName: (ctx) => const ConfigurePlatesScreen(),
                ConfigureDashboardWidgetsScreen.routeName: (ctx) =>
                    const ConfigureDashboardWidgetsScreen(),
                TrophyScreen.routeName: (ctx) => const TrophyScreen(),
              },
              localeListResolutionCallback: resolveLocale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          );
        },
      ),
    );
  }
}
