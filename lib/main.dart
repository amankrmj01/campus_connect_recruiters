import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'infrastructure/controllers/controller_initializer.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  // Initialize all controllers when app starts
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all GetX controllers
  ControllerInitializer.init();

  var initialRoute = await Routes.initialRoute;
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;

  const Main(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: Nav.routes,
    );
  }
}
