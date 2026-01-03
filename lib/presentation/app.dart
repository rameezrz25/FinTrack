import 'package:fin_track/core/theme/app_theme.dart';
import 'package:fin_track/domain/entities/asset.dart';
import 'package:fin_track/domain/entities/asset_type.dart';
import 'package:fin_track/presentation/providers/theme_provider.dart';
import 'package:fin_track/presentation/screens/add_asset_screen.dart';
import 'package:fin_track/presentation/screens/asset_list_screen.dart';
import 'package:fin_track/presentation/screens/dashboard_screen.dart';
import 'package:fin_track/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FinTrackApp extends ConsumerWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
          routes: [
            GoRoute(
              path: 'add-asset',
              builder: (context, state) {
                // Check if extra is AssetType (for initial type) or Asset (for edit - handled in other route but just in case)
                 AssetType? initialType;
                 if (state.extra is AssetType) {
                   initialType = state.extra as AssetType;
                 }
                 return AddAssetScreen(initialType: initialType);
              },
            ),
            GoRoute(
              path: 'assets/:type',
              builder: (context, state) {
                final typeStr = state.pathParameters['type'];
                final type = AssetType.values.firstWhere((e) => e.name == typeStr);
                return AssetListScreen(filterType: type);
              },
            ),
             GoRoute(
              path: 'asset/:id',
              builder: (context, state) {
                final asset = state.extra as Asset;
                return AddAssetScreen(assetToEdit: asset);
              },
            ),
          ],
        ),
      ],
    );

    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return MaterialApp.router(
      title: 'FinTrack',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.currentThemeData, // We manually handle theme switching via provider for custom 'sepia' logic
      // darkTheme: AppTheme.darkTheme, // Disable default dark theme handling to allow 3-state logic
      // themeMode: ThemeMode.light, // Force light mode so we can control ThemeData directly
      routerConfig: router,
    );
  }
}
