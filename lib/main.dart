import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paisa/core/enum/box_types.dart';
import 'package:paisa/features/recurring/domain/repository/recurring_repository.dart';
import 'package:paisa/app.dart';
import 'package:paisa/dependency_injection/dependency_injection.dart';
import 'package:paisa/src/rust/api/logs.dart';
import 'package:paisa/src/rust/api/simple.dart';
import 'package:paisa/src/rust/frb_generated.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  await RustLib.init();
  Stream<String> nativeLogs = setupLogs();
  nativeLogs.handleError((e) {
    print("Failed to set up native logs: $e");
  }).listen((logRow) {
    print("[native] $logRow");
  });

  WidgetsFlutterBinding.ensureInitialized();
  await configInjector(getIt);
  getIt.get<RecurringRepository>().checkForRecurring();
  final Box<dynamic> settings =
      getIt.get<Box<dynamic>>(instanceName: BoxType.settings.name);
  runApp(PaisaApp(settings: settings));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: Center(
          child: Text(
              'Action: Call Rust `greet("Tom")`\nResult: `${greet(name: "Tom")}`'),
        ),
      ),
    );
  }
}
