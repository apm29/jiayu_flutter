import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiayu_flutter/application/Application.dart';
import 'package:jiayu_flutter/pages/SplashPage.dart';
import 'package:jiayu_flutter/store/ReduxApp.dart';
import 'package:sentry/sentry.dart';

final SentryClient sentry = new SentryClient(dsn: "https://d374b2ab1e6c41619a3bef3fdde4133b@o424313.ingest.sentry.io/5356009");

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
  if (detail != null) {
    print(detail);
  } else {
    print(error);
    print(stackTrace);
  }
  sentry.captureException(exception: error,stackTrace: stackTrace);
}
