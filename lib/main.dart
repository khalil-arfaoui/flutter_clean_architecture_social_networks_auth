import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/const/app_constants.dart';
import 'features/user/presentation/bloc/user_bloc.dart';
import 'features/user/presentation/models_providers/auth_provider.dart';
import 'features/user/presentation/pages/auth/auth_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
// void _enablePlatformOverrideForDesktop() {
//   if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
//     debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // _enablePlatformOverrideForDesktop();
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (_) => sl<UserBloc>(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

ThemeData themeData() {
  return ThemeData(
    primarySwatch: Colors.blue,
    accentColor: Colors.orangeAccent,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(elevation: 8.0),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        primary: Color(0xFFfc6011),
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: Size(400.0, 52.0),
        side: BorderSide(
          color: Color(0xFFfc6011),
        ),
      ),
    ),
    iconTheme: IconThemeData(color: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFfc6011),
        shape: StadiumBorder(),
        minimumSize: Size(400.0, 52.0),
        onPrimary: Colors.white,
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        /// Turned on if you want to see the debug banner
        debugShowCheckedModeBanner: false,
        title: APP_NAME,
        theme: themeData(),
        home: AuthPage(title: 'Flutter Demo Home Page'),

        /// Translation Side
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('fr'), // French
          const Locale('en'), // English
          const Locale('ar'), // Arabic
          // ... other locales the app supports
        ],
        locale: Locale('fr'), // Current language
      ),
    );
  }
}
