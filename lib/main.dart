import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/category_provider.dart';
import 'providers/locale_provider.dart'; // Import LocaleProvider
import 'providers/user_provider.dart'; // Import UserProvider
import 'routes.dart'; // Import AppRoutes
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()), // Provide LocaleProvider globally
        ChangeNotifierProvider(create: (_) => UserProvider()), // Provide UserProvider globally
      ],
      child: Consumer2<LocaleProvider, UserProvider>(
        builder: (context, localeProvider, userProvider, _) {
          return MaterialApp(
            title: 'Authentication App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('ar', ''), // Arabic
              Locale('he', ''), // Hebrew
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: localeProvider.locale, // Use the locale from LocaleProvider
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              return supportedLocales.first; // Default to the first locale
            },
            initialRoute: '/',
            routes: AppRoutes.getRoutes(), // Static routes
            onGenerateRoute: AppRoutes.generateRoute, // Dynamic routes
          );
        },
      ),
    );
  }
}


