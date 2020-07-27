import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiayu_flutter/application/Application.dart';
import 'package:jiayu_flutter/pages/SplashPage.dart';
import 'package:jiayu_flutter/store/ReduxApp.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Application.init();
  FlutterError.onError = (FlutterErrorDetails details) {
    customerReport(detail: details);
  };
  runZoned(
        () => runApp(ReduxApp(
          firstPage: SplashPage(),
        )),
    onError: (Object obj, StackTrace stack) {
      customerReport(error: obj, stackTrace: stack);
    },
  );
}

customerReport(
    {FlutterErrorDetails detail, Object error, StackTrace stackTrace}) {
    print(detail??"NO DETAIL");
    print(detail?.stack??"NO DETAIL STACK");
    print(detail?.exception??"NO DETAIL EXCEPTION");
    print(error??"NO ERROR");
    print(stackTrace??"NO STACKTRACE");
}
