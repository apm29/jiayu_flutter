import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jiayu_flutter/store/stores.dart';
import 'package:jiayu_flutter/config/Config.dart';
import 'package:jiayu_flutter/generated/l10n.dart';
import 'package:oktoast/oktoast.dart';

///
/// author : apm29
/// date : 2020/7/8 1:48 PM
/// description :
///
class ReduxApp extends StatelessWidget {
  final Widget firstPage;

  const ReduxApp({Key key, this.firstPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<JiaYuState>(
      store: appStore,
      child: OKToast(
        //StoreConnector<JiaYuState, Locale> provide locale for material app
        child: StoreConnector<JiaYuState, Locale>(
          converter: (s) => s.state.locale,
          builder: (context, locale) => MaterialApp(
            debugShowCheckedModeBanner: Config.AppDebug,
            localizationsDelegates: [
              // ... app-specific localization delegate[s] here
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate
            ],
            locale: locale,
            supportedLocales: S.delegate.supportedLocales,
            theme: ThemeData(
              primarySwatch: MaterialColor(
                0xffb69444,
                <int, Color>{
                  50: Color(0xFFB6D13A),
                  100: Color(0xFFB6C509),
                  200: Color(0xFFB6B8D8),
                  300: Color(0xFFB6ACA7),
                  400: Color(0xFFB6A075),
                  500: Color(0xffb69444),
                  600: Color(0xFFB68813),
                  700: Color(0xFFB68200),
                  800: Color(0xFFB67600),
                  900: Color(0xFFB67000),
                },
              ),
              platform: TargetPlatform.iOS,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData.dark().copyWith(
              platform: TargetPlatform.iOS,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Stack(children: [
              firstPage,
              StoreConnector<JiaYuState, int>(
                converter: (store) => store.state.loading,
                builder: (context, loading) => Offstage(
                  offstage: loading > 0,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
