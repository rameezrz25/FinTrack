import 'package:fin_track/domain/entities/asset.dart';
import 'package:fin_track/domain/entities/asset_type.dart';
import 'package:fin_track/presentation/providers/asset_provider.dart';
import 'package:fin_track/presentation/providers/currency_provider.dart';
import 'package:fin_track/presentation/utils/asset_icon_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AssetListScreen extends ConsumerWidget {
  final AssetType? filterType;

  const AssetListScreen({super.key, this.filterType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(assetsProvider);
    final currencyState = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(filterType?.name.toUpperCase() ?? 'All Assets'),
      ),
      body: assetsAsync.when(
        data: (assets) {
          final filteredAssets = filterType != null 
              ? assets.where((a) => a.type == filterType).toList() 
              : assets;
          
          if (filteredAssets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_open, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No assets found in ${filterType?.name.toUpperCase() ?? "portfolio"}.'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                      onPressed: () {
                         context.go('/add-asset', extra: filterType);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add First Item')
                  )
                ],
              ),
            );
          }

          // Stats
          final totalValue = filteredAssets.fold(0.0, (sum, item) => sum + item.totalValue);
          final totalCost = filteredAssets.fold(0.0, (sum, item) => sum + item.totalCost);
          final totalProfit = totalValue - totalCost;
          final totalProfitPercent = totalCost == 0 ? 0.0 : (totalProfit / totalCost) * 100;
          final isProfit = totalProfit >= 0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary Card
              Card(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                       Column(
                         children: [
                           const Text('Total Value', style: TextStyle(color: Colors.white70)),
                           Text(
                             totalValue.toCurrency(currencyState),
                             style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                           ),
                         ],
                       ),
                       Container(height: 40, width: 1, color: Colors.white24),
                       Column(
                         children: [
                           const Text('Profit / Loss', style: TextStyle(color: Colors.white70)),
                           Row(
                             children: [
                               Icon(isProfit ? Icons.arrow_upward : Icons.arrow_downward, color: Colors.white, size: 16),
                               const SizedBox(width: 4),
                               Text(
                                 '${totalProfitPercent.abs().toStringAsFixed(2)}%',
                                 style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                               ),
                             ],
                           ),
                            Text(
                             totalProfit.toCurrency(currencyState),
                             style: const TextStyle(color: Colors.white70, fontSize: 12),
                           ),
                         ],
                       )
                    ],
                  ),
                ),
              ).animate().fadeIn(),
              
              const SizedBox(height: 24),
              const Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // List Items
              ...filteredAssets.map((asset) {
                final profit = asset.profitLoss;
                final profitPercent = asset.profitLossPercentage;
                final isAssetProfit = profit >= 0;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                       backgroundColor: AssetIconHelper.getColor(asset.type).withOpacity(0.1),
                       child: Icon(AssetIconHelper.getIcon(asset.type), color: AssetIconHelper.getColor(asset.type)),
                    ),
                    title: Text(asset.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${asset.quantity} units'),
                        Text('Buy: ${asset.purchasePrice.toCurrency(currencyState)} | Cur: ${asset.currentPrice.toCurrency(currencyState)}', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          asset.totalValue.toCurrency(currencyState),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                             color: isAssetProfit ? Colors.green.shade50 : Colors.red.shade50,
                             borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                             '${isAssetProfit ? '+' : ''}${profitPercent.toStringAsFixed(2)}%',
                               style: TextStyle(
                                  color: isAssetProfit ? Colors.green.shade700 : Colors.red.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold
                                ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      context.go('/asset/${asset.id}', extra: asset);
                    },
                  ),
                ).animate().slideX(begin: 0.1);
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           // Pass the current filter type as initial selection
           context.go('/add-asset', extra: filterType);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
