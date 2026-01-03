import 'package:fin_track/data/repositories/hive_asset_repository.dart';
import 'package:fin_track/domain/entities/asset.dart';
import 'package:fin_track/domain/repositories/asset_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  return HiveAssetRepository();
});

final assetsProvider = StreamProvider<List<Asset>>((ref) {
  final repository = ref.watch(assetRepositoryProvider);
  return repository.watchAssets();
});
