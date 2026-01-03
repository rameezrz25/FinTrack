import 'package:fin_track/domain/entities/asset_type.dart';
import 'package:flutter/material.dart';

class AssetIconHelper {
  static IconData getIcon(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return Icons.show_chart;
      case AssetType.mutualFund:
        return Icons.pie_chart;
      case AssetType.etf:
        return Icons.bar_chart;
      case AssetType.crypto:
        return Icons.currency_bitcoin;
      case AssetType.gold:
        return Icons.diamond; // Or a custom gold icon if available
      case AssetType.realEstate:
        return Icons.apartment;
      case AssetType.fixedDeposit:
        return Icons.lock_clock;
      case AssetType.bond:
        return Icons.receipt_long;
      case AssetType.loan: // New
        return Icons.money_off; 
      case AssetType.cash:
        return Icons.attach_money;
      default:
        return Icons.category;
    }
  }

  static Color getColor(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return Colors.blue;
      case AssetType.mutualFund:
        return Colors.purple;
      case AssetType.etf:
        return Colors.indigo;
      case AssetType.crypto:
        return Colors.orange;
      case AssetType.gold:
        return Colors.amber;
      case AssetType.realEstate:
        return Colors.brown;
      case AssetType.fixedDeposit:
        return Colors.teal;
      case AssetType.bond:
        return Colors.cyan;
      case AssetType.loan: // New
        return Colors.red;
      case AssetType.cash:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
