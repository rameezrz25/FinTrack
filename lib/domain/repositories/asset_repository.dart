import 'package:fin_track/domain/entities/asset.dart';

abstract class AssetRepository {
  Future<List<Asset>> getAssets();
  Future<void> addAsset(Asset asset);
  Future<void> updateAsset(Asset asset);
  Future<void> deleteAsset(String id);
  Stream<List<Asset>> watchAssets();
}
