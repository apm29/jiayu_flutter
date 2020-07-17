import 'package:flutter/material.dart';
import 'package:jiayu_flutter/application/Application.dart';
import 'package:jiayu_flutter/pages/SplashPage.dart';
import 'package:jiayu_flutter/store/ReduxApp.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Application.init();

  runApp(
    ReduxApp(
      firstPage: SplashPage(),
    ),
  );
}
