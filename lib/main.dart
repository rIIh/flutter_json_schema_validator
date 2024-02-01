// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:json_schema_validate/router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: kRouter,
      title: 'JSON Schema Validator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFCDE5C)),
        useMaterial3: true,
      ),
    );
  }
}
