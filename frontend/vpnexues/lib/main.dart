import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/shared/providers/auth_provider.dart';
import 'package:vpnexues_pvt/shared/providers/theme_provider.dart';
import 'package:vpnexues_pvt/features/address/providers/address_provider.dart';
import 'package:vpnexues_pvt/features/support/providers/chat_provider.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';
import 'package:vpnexues_pvt/features/notifications/providers/notification_provider.dart';
import 'package:vpnexues_pvt/features/cart/providers/payment_method_provider.dart';
import 'package:vpnexues_pvt/features/splash/splash_screen.dart';
import 'package:vpnexues_pvt/core/theme/app_theme.dart';
import 'package:vpnexues_pvt/core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('NotificationService init skipped: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => PaymentMethodProvider()),
      ],
      child: _AppInit(
        child: Consumer2<ThemeProvider, LanguageProvider>(
          builder: (context, themeProvider, langProvider, _) {
            final locale = Locale(langProvider.currentLanguage);
            return MaterialApp(
              title: 'VP Nexues',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              locale: locale,
              supportedLocales: const [
                Locale('en'),
                Locale('hi'),
                Locale('ta'),
                Locale('si'),
                Locale('ar'),
                Locale('zh'),
                Locale('ur'),
                Locale('ml'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}

class _AppInit extends StatefulWidget {
  final Widget child;
  const _AppInit({required this.child});

  @override
  State<_AppInit> createState() => _AppInitState();
}

class _AppInitState extends State<_AppInit> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LanguageProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
