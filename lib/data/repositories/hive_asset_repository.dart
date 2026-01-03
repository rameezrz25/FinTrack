import 'package:fin_track/data/models/asset_hive_model.dart';
import 'package:fin_track/domain/entities/asset.dart';
import 'package:fin_track/domain/repositories/asset_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveAssetRepository implements AssetRepository {
  static const String boxName = 'assets';

  Future<Box<AssetHiveModel>> _openBox() async {
    if (!Hive.isAdapterRegistered(0)) {
       Hive.registerAdapter(AssetHiveModelAdapter());
    }
    return Hive.openBox<AssetHiveModel>(boxName);
  }

  @override
  Future<void> addAsset(Asset asset) async {
    final box = await _openBox();
    await box.put(asset.id, AssetHiveModel.fromEntity(asset));
  }

  @override
  Future<void> deleteAsset(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  @override
  Future<List<Asset>> getAssets() async {
    final box = await _openBox();
    return box.values.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> updateAsset(Asset asset) async {
    await addAsset(asset); // Hive put handles update if key exists
  }

  @override
  Stream<List<Asset>> watchAssets() async* {
    final box = await _openBox();
    // Yield specific initial value
    yield box.values.map((e) => e.toEntity()).toList();
    
    yield* box.watch().map((event) {
      return box.values.map((e) => e.toEntity()).toList();
    });
  }
}
