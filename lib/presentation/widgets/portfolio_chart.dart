import 'package:fin_track/domain/entities/asset.dart';
import 'package:fin_track/presentation/utils/asset_icon_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PortfolioChart extends StatelessWidget {
  final List<Asset> assets;

  const PortfolioChart({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) return const SizedBox.shrink();

    final totalValue = assets.fold(0.0, (sum, asset) => sum + asset.totalValue);
    
    // Group assets by type
    final Map<String, double> allocation = {};
    for (var asset in assets) {
      final type = asset.type;
      allocation[type.name] = (allocation[type.name] ?? 0) + asset.totalValue;
    }

    final sections = allocation.entries.map((entry) {
      final typeName = entry.key;
      final value = entry.value;
      final percentage = (value / totalValue) * 100;
      
      // Find asset type enum from name
      final assetType = assets.firstWhere((a) => a.type.name == typeName).type;

      return PieChartSectionData(
        color: AssetIconHelper.getColor(assetType),
        value: value,
        title: percentage > 5 ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }
}
