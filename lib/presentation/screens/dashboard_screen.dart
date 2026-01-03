import 'package:fin_track/domain/entities/asset.dart';
import 'package:fin_track/domain/entities/asset_type.dart';
import 'package:fin_track/presentation/providers/asset_provider.dart';
import 'package:fin_track/presentation/providers/currency_provider.dart';
import 'package:fin_track/presentation/providers/theme_provider.dart'; // Import ThemeProvider
import 'package:fin_track/presentation/utils/asset_icon_helper.dart';
import 'package:fin_track/presentation/widgets/portfolio_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(assetsProvider);
    final currencyState = ref.watch(currencyProvider);
    final themeMode = ref.watch(themeProvider); // Watch theme to update UI

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('FinTrack'),
            actions: [
               // Theme Toggle
               IconButton(
                 icon: Icon(
                   switch(themeMode) {
                     AppThemeMode.light => Icons.wb_sunny,
                     AppThemeMode.dark => Icons.nightlight_round,
                     AppThemeMode.sepia => Icons.coffee,
                   },
                   color: Theme.of(context).primaryColor,
                 ),
                 onPressed: () {
                   ref.read(themeProvider.notifier).toggleTheme();
                 },
               ),
               // Currency Toggle Button
               TextButton.icon(
                onPressed: () {
                   ref.read(currencyProvider.notifier).toggleCurrency();
                },
                icon: Icon(Icons.currency_exchange, color: Theme.of(context).primaryColor),
                label: Text(
                  currencyState.currency.name.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                ),
               ),
            ],
          ),
          assetsAsync.when(
            data: (assets) {
              // Calculate Totals
              final totalValue = assets.fold(0.0, (sum, item) => sum + item.totalValue);
              final totalCost = assets.fold(0.0, (sum, item) => sum + item.totalCost);
              final totalProfit = totalValue - totalCost;
              final totalProfitPercent = totalCost == 0 ? 0.0 : (totalProfit / totalCost) * 100;
              final isProfit = totalProfit >= 0;

              // Aggregate by Type
              final Map<AssetType, double> typeValues = {};
              for (var type in AssetType.values) {
                if (type == AssetType.other) continue;
                typeValues[type] = 0;
              }
              for (var asset in assets) {
                typeValues[asset.type] = (typeValues[asset.type] ?? 0) + asset.totalValue;
              }

              return SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Portfolio Value Card
                        Card(
                          elevation: 8, // Increased elevation
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Net Worth',
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  totalValue.toCurrency(currencyState),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack).fadeIn(),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${totalProfit.abs().toCurrency(currencyState)} (${totalProfitPercent.toStringAsFixed(2)}%)',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate().slideY(begin: 0.5, end: 0, delay: 300.ms, duration: 600.ms).fadeIn(),
                              ],
                            ),
                          ),
                        ).animate().slideY(begin: -0.2, end: 0, duration: 800.ms, curve: Curves.easeOutCirc),

                        const SizedBox(height: 32),

                        // Allocation Chart (Only show if there are assets)
                        if (assets.isNotEmpty) ...[
                          Text('Allocation', style: Theme.of(context).textTheme.titleLarge)
                              .animate()
                              .fadeIn(delay: 500.ms),
                          const SizedBox(height: 16),
                          PortfolioChart(assets: assets).animate().scale(delay: 600.ms, duration: 800.ms, curve: Curves.elasticOut),
                          const SizedBox(height: 32),
                        ],
                        
                        // Categories Header
                        Text('Categories', style: Theme.of(context).textTheme.titleLarge)
                           .animate().fadeIn(delay: 700.ms),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ]),
              );
            },
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (err, stack) => SliverFillRemaining(child: Center(child: Text('Error: $err'))),
          ),
          
          // Grid Layout
          assetsAsync.when(
            data: (assets) {
               // Re-calculate aggregations for grid
              final Map<AssetType, double> typeValues = {};
              for (var type in AssetType.values) {
                if (type == AssetType.other) continue;
                typeValues[type] = 0;
              }
              for (var asset in assets) {
                typeValues[asset.type] = (typeValues[asset.type] ?? 0) + asset.totalValue;
              }

              final categories = AssetType.values.where((e) => e != AssetType.other).toList();

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Smaller grid items
                    mainAxisSpacing: 12, // Reduced spacing
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9, // Taller to fit content
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final type = categories[index];
                      final value = typeValues[type] ?? 0;
                      final color = AssetIconHelper.getColor(type);
                      final icon = AssetIconHelper.getIcon(type);

                      return InkWell(
                        onTap: () => context.go('/assets/${type.name}'),
                        child: Card(
                          elevation: 2, // Slight reduction
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Container(
                            decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(16),
                               gradient: LinearGradient(
                                 begin: Alignment.topLeft,
                                 end: Alignment.bottomRight,
                                 colors: [
                                   Theme.of(context).cardColor,
                                   Theme.of(context).cardColor.withOpacity(0.9),
                                 ]
                               )
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 20, // Smaller icon
                                  backgroundColor: color.withOpacity(0.15),
                                  child: Icon(icon, color: color, size: 24),
                                ).animate(target: 1).scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut, duration: 600.ms),
                                const SizedBox(height: 8),
                                Text(
                                  type.name.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11, // Smaller text
                                    color: Theme.of(context).hintColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  value.toCurrency(currencyState),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 13, // Smaller value text
                                    color: type == AssetType.loan ? Colors.red : null,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Prevent overflow
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().scale(
                        delay: (800 + (index * 50)).ms, // Faster stagger
                        duration: 600.ms, 
                        curve: Curves.easeOutBack,
                        begin: const Offset(0.5, 0.5)
                      ).fadeIn();
                    },
                    childCount: categories.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(), // Handled above
            error: (e, s) => const SliverToBoxAdapter(),
          ),
          
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
      // Removed FAB
    );
  }
}
