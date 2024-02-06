import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paisa/core/enum/box_types.dart';
import 'package:paisa/features/recurring/domain/repository/recurring_repository.dart';
import 'package:paisa/app.dart';
import 'package:paisa/dependency_injection/dependency_injection.dart';
import 'package:paisa/src/rust/api/db/db.dart';
import 'package:paisa/src/rust/api/logs.dart';
import 'package:paisa/src/rust/frb_generated.dart';
import 'package:path_provider/path_provider.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  await RustLib.init();
  Stream<String> nativeLogs = setupLogs();
  nativeLogs.handleError((e) {
    debugPrint("Failed to set up native logs: $e");
  }).listen((logRow) {
    debugPrint("[native] $logRow");
  });

  WidgetsFlutterBinding.ensureInitialized();
  await configInjector(getIt);
  getIt.get<RecurringRepository>().checkForRecurring();

  ProfileRepository profileRepository = ProfileRepository(
    db: await openProfileDb(
      path: getApplicationDocumentsDirectory().toString(),
    ),
  );
  final Box<dynamic> settings =
      getIt.get<Box<dynamic>>(instanceName: BoxType.settings.name);
  runApp(
    RepositoryProvider(
      create: (context) => profileRepository,
      child: PaisaApp(settings: settings),
    ),
  );
}
