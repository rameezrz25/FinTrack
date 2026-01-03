import 'package:fin_track/domain/entities/asset_type.dart';

class Asset {
  final String id;
  final String name;
  final AssetType type;
  final double quantity;
  final double purchasePrice; // Per unit or total? Usually per unit.
  final double currentPrice;
  final DateTime purchaseDate;
  final String currency;
  final String? notes;

  const Asset({
    required this.id,
    required this.name,
    required this.type,
    required this.quantity,
    required this.purchasePrice,
    required this.currentPrice,
    required this.purchaseDate,
    this.currency = 'USD',
    this.notes,
  });

  double get totalValue => quantity * currentPrice;
  double get totalCost => quantity * purchasePrice;
  double get profitLoss => totalValue - totalCost;
  double get profitLossPercentage => totalCost == 0 ? 0 : (profitLoss / totalCost) * 100;
}
