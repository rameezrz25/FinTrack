import 'package:fin_track/domain/entities/asset.dart';
import 'package:fin_track/domain/entities/asset_type.dart';
import 'package:hive/hive.dart';

part 'asset_hive_model.g.dart';

@HiveType(typeId: 0)
class AssetHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type; // Store enum as string

  @HiveField(3)
  final double quantity;

  @HiveField(4)
  final double purchasePrice;

  @HiveField(5)
  final double currentPrice;

  @HiveField(6)
  final DateTime purchaseDate;

  @HiveField(7)
  final String currency;

  @HiveField(8)
  final String? notes;

  AssetHiveModel({
    required this.id,
    required this.name,
    required this.type,
    required this.quantity,
    required this.purchasePrice,
    required this.currentPrice,
    required this.purchaseDate,
    required this.currency,
    this.notes,
  });

  factory AssetHiveModel.fromEntity(Asset asset) {
    return AssetHiveModel(
      id: asset.id,
      name: asset.name,
      type: asset.type.name,
      quantity: asset.quantity,
      purchasePrice: asset.purchasePrice,
      currentPrice: asset.currentPrice,
      purchaseDate: asset.purchaseDate,
      currency: asset.currency,
      notes: asset.notes,
    );
  }

  Asset toEntity() {
    return Asset(
      id: id,
      name: name,
      type: AssetType.values.firstWhere((e) => e.name == type, orElse: () => AssetType.other),
      quantity: quantity,
      purchasePrice: purchasePrice,
      currentPrice: currentPrice,
      purchaseDate: purchaseDate,
      currency: currency,
      notes: notes,
    );
  }
}
