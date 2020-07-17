import 'package:fluro/fluro.dart';
import 'package:jiayu_flutter/route/route.dart';
import 'package:jiayu_flutter/storage/LocalCache.dart';

///
/// author : apm29
/// date : 2020/7/6 2:48 PM
/// description :
///
class Application {
  static Router router;

  static  init() async {
    Router router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    await LocalCache().init();
  }
}
