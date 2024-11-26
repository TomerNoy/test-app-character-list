import 'package:flutter/material.dart';
import 'package:testapp/src/app.dart';
import 'package:testapp/src/services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceProvider.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => App();
}
