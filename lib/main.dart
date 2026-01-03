import 'package:fin_track/presentation/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  // await Hive.openBox('settings'); // Example box

  runApp(
    const ProviderScope(
      child: FinTrackApp(),
    ),
  );
}
