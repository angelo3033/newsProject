import 'package:flutter/material.dart';
import 'package:newsproject/src/navigation/routes.dart';

/// Creamos el material APP
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings) => Routes.routes(settings),
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
    );
  }
}
